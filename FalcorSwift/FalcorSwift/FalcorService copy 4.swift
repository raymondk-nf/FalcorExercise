 //
 //  FalcorService.swift
 //  FalcorService
 //
 //  Created by Raymond Kim on 11/21/17.
 //  Copyright © 2017 Netflix. All rights reserved.
 //
 
 import Foundation
 
 typealias JsonGraphTuple = (jsonGraph: JSONGraph?, optimizedPaths: [[JSONPath]]? )
 
 open class FalcorService {
    
    public func getJSONGraph(jsonGraph: JSONGraph?, path: [JSONPath]) throws -> JSONGraph? {
        
        var buildJSONGraph = [String:JSONGraph]()
        var optimizedPaths = [path]
        
        while optimizedPaths.count > 0 {
            
            let resultTuple: JsonGraphTuple
            do {
                resultTuple = try getJSONGraphRecursive(jsonGraph: jsonGraph, path: optimizedPaths.removeFirst())
            }
            catch FalcorError.InvalidAttempt {
                if buildJSONGraph.count > 0 {
                    return JSONGraph.Object(buildJSONGraph)
                }
                else {
                    throw FalcorError.InvalidAttempt
                }
            }
            
            if let graph = resultTuple.jsonGraph,
            case .Object(let dictionary) = graph {
                    buildJSONGraph = buildJSONGraph.deepMergeJSONGraph(with: dictionary )
            }
            
            if let op = resultTuple.optimizedPaths {
                optimizedPaths = [optimizedPaths, op].flatMap {$0}
            }
        }
        
        return JSONGraph.Object(buildJSONGraph)
        
    }
    
    func getJSONGraphRecursive(jsonGraph: JSONGraph?, path: [JSONPath] ) throws -> JsonGraphTuple  {
        
        guard let aJsonGraph = jsonGraph else { throw FalcorError.InvalidJSONGraph }
        
        switch aJsonGraph {
        case .Object(_):
            guard path.count > 0 else { throw FalcorError.InvalidAttempt }

        case .Sentinal(let sentinal):
            if case .Ref(let refPath) = sentinal {
                return (nil, [refPath])
            } else {
                return (jsonGraph, nil)
            }
        }
        
        // Normalize arguments
        let arguments = path.parseFirstJSONPathArgument()
        

        return try arguments.map{ (jsonPathKey) -> JsonGraphTuple in
            
            let stringKey = JSONPathValue(jsonPathKey)
            let subPath = path.dropFirst()
            
            guard case .Object(let dictionary) = aJsonGraph else { throw FalcorError.InvalidJSONGraph }
            guard let subGraph = dictionary[stringKey] else { throw FalcorError.InvalidModel }
            
            let resultTuple = try getJSONGraphRecursive(jsonGraph: subGraph, path: Array(subPath))
        
            if let graph = resultTuple.jsonGraph {
                return (JSONGraph.Object([stringKey: graph]), resultTuple.optimizedPaths)
            
            } else if let op = resultTuple.optimizedPaths  {
                // Reference types
                let flattenArray = [op.first!, Array(subPath)].flatMap {$0}
                return (JSONGraph.Object([stringKey: subGraph]), [flattenArray])
            
            } else {
                return (JSONGraph.Object([stringKey: subGraph]), nil)
            }
            
        }.reduce( (JSONGraph.Object([String:JSONGraph]()), [[JSONPath]]() ) ) {
            
            
            let resultJSONGraph: JSONGraph?
            
            if let newJsonGraph = $1.jsonGraph,
                let resultJsonGraph = $0.jsonGraph,
                case .Object(let newDictionary) = newJsonGraph,
                case .Object(let resultDictionary) = resultJsonGraph {
                resultJSONGraph = JSONGraph.Object( resultDictionary.deepMergeJSONGraph(with: newDictionary) )
                
            } else {
                resultJSONGraph = nil
            }
            
            let optimizedPaths: [[JSONPath]]?
            
            if let newOptimizedPaths = $1.optimizedPaths,
                let resultOptimizedPaths = $0.optimizedPaths {
                
                optimizedPaths = [resultOptimizedPaths, newOptimizedPaths].flatMap {$0}
            } else {
                optimizedPaths =  nil
            }
            
            return (resultJSONGraph, optimizedPaths)
            
        }
    }
    
 }
 
