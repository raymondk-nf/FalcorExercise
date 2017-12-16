//
//  FalcorClient.swift
//  FalcorEx
//
//  Created by Raymond Kim on 11/30/17.
//  Copyright © 2017 Netflix. All rights reserved.
//

import Foundation

open class FalcorClient {
    
    public func getJSON(jsonGraph rootJsonGraph: JSONGraph, path: JSONPathSet) throws -> JSON {
        
        func getJSON(currentJsonGraph: JSONGraph, path: ArraySlice<JSONPathKeySet> ) throws -> JSON  {
            
            switch currentJsonGraph {
                
            case .Object(let dictionary):
                guard path.count > 0 else { throw FalcorError.InvalidAttempt }
                
                let pathKeySet = path.first!
                let subPathSlice = path.dropFirst()
                
                let jsonTuples = try pathKeySet.map{ (jsonPathKey) -> (String, JSON)? in
                    
                    let stringKey = jsonPathKey.toString
                    let json: JSON
                    
                    guard let subGraph = dictionary[stringKey] else { return  nil }
                    
                    switch subGraph {
                    case .Object(_):
                        json = try getJSON(currentJsonGraph: subGraph, path: subPathSlice)
                        
                    case .Sentinal(let sentinal):
                        guard let resultJson = try processSentinal(sentinal, subPathSlice: subPathSlice) else { return nil }
                        json = resultJson
                    }
                    
                    return (stringKey, json)
                    
                }
                
                let tupleArray = jsonTuples.flatMap { $0 }
                
                let resultDictionary = Dictionary(uniqueKeysWithValues: tupleArray)
                
                return JSON.Object(resultDictionary)
                
            case .Sentinal(let sentinal):
                
                guard let resultJson = try processSentinal(sentinal, subPathSlice: nil) else { return JSON.Object([:]) }
                return resultJson
            }
        }
        
        func processSentinal(_ sentinal: JSONGraphSentinal, subPathSlice: ArraySlice<JSONPathKeySet>?) throws -> JSON? {
            
            switch (sentinal) {
            case .Atom(let atomJson):
                return atomJson
                
            case .Error(let errorJson):
                throw FalcorError.InvalidJSONGraphError(errorJson)
                
            case .Primitive(let primJson):
                return primJson
                
            case .Ref(let jsonRefPath):
                guard let subPathSlice = subPathSlice, !subPathSlice.isEmpty else { return nil }
                
                guard let resolvedJsonGraph = resolveJsonPathReference(jsonGraph: rootJsonGraph, refPath: ArraySlice(jsonRefPath), rootJsonGraph: rootJsonGraph) else { return JSON.Object([:]) }
                    
                return try getJSON(currentJsonGraph: resolvedJsonGraph, path: subPathSlice)

            }
        }
        
        return try getJSON(currentJsonGraph: rootJsonGraph, path: ArraySlice(path))
    }
    
    
    
    // READ: Tail recursion
    // 1st TRY: Reduce after loop
    // 2nd try TODO: Re-write this as a loop
    // write recursive ADD with two BIG numbers.  Observe: should not see a stack overflow
    func resolveJsonPathReference(jsonGraph: JSONGraph, refPath: ArraySlice<JSONRefPathKey>, rootJsonGraph: JSONGraph ) -> JSONGraph? {
        
        switch jsonGraph {
        case .Object(let dictionary):
            guard refPath.count > 0 else { return jsonGraph }
            guard let subJsonGraph = dictionary[ refPath.first! ] else { return jsonGraph }
            return resolveJsonPathReference(jsonGraph: subJsonGraph, refPath: refPath.dropFirst(), rootJsonGraph: rootJsonGraph)

        case .Sentinal(let sentinal):
 
            if refPath.isEmpty {
                switch (sentinal) {
                case .Atom(_):
                    return jsonGraph
                case .Error(_):
                    return jsonGraph
                case .Primitive(_):
                    return jsonGraph
                case .Ref(let jsonRefPath):
                    return resolveJsonPathReference(jsonGraph: rootJsonGraph, refPath: ArraySlice(jsonRefPath), rootJsonGraph: rootJsonGraph)
                }
            } else {
                return nil
            }

        }
    }
}



