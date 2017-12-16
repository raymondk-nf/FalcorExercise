//
//  FalcorClient.swift
//  FalcorEx
//
//  Created by Raymond Kim on 11/30/17.
//  Copyright © 2017 Netflix. All rights reserved.
//

import Foundation
// TODO: Read Tail Recursion
open class FalcorClient {
    
    public func getJSON(jsonGraph rootJsonGraph: JSONGraph, path: JSONPathSet) throws -> JSON? {
        
        // TODO: Move to nested function style
        func getJSON(currentJsonGraph: JSONGraph, path: ArraySlice<JSONPathKeySet> ) throws -> JSON  {
            
            switch currentJsonGraph {
            case .Object(_):
                guard path.count > 0 else { throw FalcorError.InvalidAttempt }
                
            case .Sentinal(_):
                // TODO: Test case, empty path to atom json, return atom
                // TODO: Test case, empty path to ref json, return ??
//                if case .Ref(let refPath) = sentinal {
//                    return (jsonGraph, (path.isEmpty) ? nil : [ refPath.convertToJSONPathSet() + path ] )
//                } else {
//                    return (jsonGraph, nil)
//                }
                break
            }
            
            guard let pathKeySet = path.first else { throw FalcorError.InvalidJSONPath }
            let subPathSlice = path.dropFirst()
            
            // TODO: Carry over optimizations to getJSONGraph
            // Tuple return value and simplying reduce
            let jsonTuples = try pathKeySet.map{ (jsonPathKey) -> (String, JSON)? in
                
                let stringKey = jsonPathKey.associatedValue
                let json: JSON
                
                // TODO: possibly reduce switch checks with .Object above
                // TODO: can be removed from map iteration
                guard case .Object(let dictionary) = currentJsonGraph else { throw FalcorError.InvalidJSONGraph }
                guard let subGraph = dictionary[stringKey] else { return  nil }
                
                switch subGraph {
                case .Object(_):
                    json = try getJSON(currentJsonGraph: subGraph, path: subPathSlice)
                case .Sentinal(let sentinal):
                    switch sentinal {
                    case .Atom(let atomJson):
                        json = atomJson
                        
                    case .Error(let errorJson):
                        throw FalcorError.InvalidJSONGraphError(errorJson)
                        
                    case .Ref(let jsonRefPath):
                        guard !subPathSlice.isEmpty else { return nil }
                        if let resolvedJsonGraph = resolveJsonPathReferenceRecursive(jsonGraph: rootJsonGraph, refPath: ArraySlice(jsonRefPath), rootJsonGraph: rootJsonGraph) {
                            
                            let resultJson = try getJSON(currentJsonGraph: resolvedJsonGraph, path: subPathSlice)
                            
                            json = resultJson
                        } else {
                            json = JSON.Object([:])
                        }
                        
                    case .Primitive(let primJson):
                        json = primJson
                        
                    }
                }
                
                return (stringKey, json)
                
            }
            
            let flattened = jsonTuples.flatMap { $0 }
            
            let reduced = Dictionary(uniqueKeysWithValues: flattened)
            
            return JSON.Object(reduced)
        }
        
        return try getJSON(currentJsonGraph: rootJsonGraph, path: ArraySlice(path))
    }
    
    
    // TODO: Rename recursive
    // READ: Tail recursion
    // 1st TRY: Reduce after loop
    // 2nd try TODO: Re-write this as a loop
    // write recursive ADD with two BIG numbers.  Observe: should not see a stack overflow
    func resolveJsonPathReferenceRecursive(jsonGraph: JSONGraph, refPath: ArraySlice<JSONRefPathKey>, rootJsonGraph: JSONGraph ) -> JSONGraph? {
        
        switch jsonGraph {
        case .Object(let dictionary):
            guard refPath.count > 0 else { return jsonGraph }
            guard let subJsonGraph = dictionary[ refPath.first! ] else { return jsonGraph }
            return resolveJsonPathReferenceRecursive(jsonGraph: subJsonGraph, refPath: refPath.dropFirst(), rootJsonGraph: rootJsonGraph)

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
                    return resolveJsonPathReferenceRecursive(jsonGraph: rootJsonGraph, refPath: ArraySlice(jsonRefPath), rootJsonGraph: rootJsonGraph)
                }
            } else {
                return nil
            }

        }
    }
}



