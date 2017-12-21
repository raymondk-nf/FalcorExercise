//
//  FalcorClient.swift
//  FalcorEx
//
//  Created by Raymond Kim on 11/30/17.
//  Copyright © 2017 Netflix. All rights reserved.
//

import Foundation

open class FalcorClient {
    
    public func getJSON(jsonGraph: JSONGraph, path: JSONPathSet) throws -> JSON? {
        
        let json = try getJSONRecursive(jsonGraph: jsonGraph, path: ArraySlice(path), rootJsonGraph: jsonGraph)
        
        return json
    }
    
    func getJSONRecursive(jsonGraph: JSONGraph, path: ArraySlice<JSONPathKeySet>, rootJsonGraph: JSONGraph ) throws -> JSON  {
        
        switch jsonGraph {
        case .Object(_):
            guard path.count > 0 else { throw FalcorError.InvalidAttempt }

        case .Sentinal(_):
            break
        }
        
        guard let pathKeySet = path.first else { throw FalcorError.InvalidJSONPath }
        let subPathSlice = path.dropFirst()

        return try pathKeySet.map{ (jsonPathKey) -> JSON in
            
            let stringKey = jsonPathKey.associatedValue
            let json: JSON

            guard case .Object(let dictionary) = jsonGraph else { throw FalcorError.InvalidJSONGraph }
            guard let subGraph = dictionary[stringKey] else { return JSON.Object([:]) }
            
            switch subGraph {
            case .Object(_):
                let resultJson = try getJSONRecursive(jsonGraph: subGraph, path: subPathSlice, rootJsonGraph: rootJsonGraph)
                json = JSON.Object([stringKey: resultJson])
                
            case .Sentinal(let sentinal):
                switch sentinal {
                case .Atom(let atomJson):
                    json = JSON.Object([stringKey: atomJson])
                    
                case .Error(let errorJson):
//                    if case .Value(let value) = errorJson,
//                        case .String(let string) = value {
                        throw FalcorError.InvalidJSONGraphError(errorJson)
//                    }
//                    json = JSON.Object([:])
                    
                case .Ref(let jsonRefPath):
                    
                    if !subPathSlice.isEmpty {
                        let flattenArray = ArraySlice(jsonRefPath.convertToJSONPathSet() + subPathSlice)
                        
                        let resultJson = try getJSONRecursive(jsonGraph: rootJsonGraph, path: flattenArray, rootJsonGraph: rootJsonGraph)
                        
                        // seek to jsonRefPath in JSON Graph
                        let resultSeekJson = seekToJsonRecursive(json: resultJson, refPath: ArraySlice(jsonRefPath))
                        
                        // Then add to json
                        json = JSON.Object([stringKey: resultSeekJson])
                    } else {
                        json = JSON.Object([:])
                    }
                    
                case .Primitive(let primJson):
                    json = JSON.Object([stringKey: primJson])
                    
                }
            }

            return json
            
        }.reduce( JSON.Object([String:JSON]()) ) { (accumTuple, currentJson) in
            
            let resultJSON: JSON
            
            guard case .Object(let newDictionary) = currentJson,
                case .Object(let resultDictionary) = accumTuple else { throw FalcorError.InvalidJSON }
            
            resultJSON = JSON.Object( resultDictionary.deepMergeJSONGraph(with: newDictionary) )
            return resultJSON
            
        }
    }
    
    func seekToJsonRecursive(json: JSON, refPath: ArraySlice<JSONRefPathKey> ) -> JSON {
        guard refPath.count > 0 else { return json }
        guard case .Object(let dictionary) = json else { return json}
        guard let subJson = dictionary[ refPath.first! ] else { return json }
        
        return seekToJsonRecursive(json: subJson, refPath: refPath.dropFirst())
    }
    
}



