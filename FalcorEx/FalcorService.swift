 //
 //  FalcorService.swift
 //  FalcorService
 //
 //  Created by Raymond Kim on 11/21/17.
 //  Copyright © 2017 Netflix. All rights reserved.
 //
 
 import Foundation
 
 
 open class FalcorService {
    
    typealias JsonGraphTuple = (jsonGraph: JSONGraph?, optimizedPaths: [JSONPathSet]? )

    public func getJSONGraph(jsonGraph: JSONGraph, path: JSONPathSet) throws -> JSONGraph? {
        
        var buildJSONGraph = [String:JSONGraph]()
        var optimizedPaths = [path]
        
        while !optimizedPaths.isEmpty {
            
            let resultTuple: JsonGraphTuple
            do {
                resultTuple = try getJSONGraphRecursive(jsonGraph: jsonGraph, path: ArraySlice(optimizedPaths.removeFirst()))
            }
            catch FalcorError.InvalidAttempt {
                if !buildJSONGraph.isEmpty {
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
    
    func getJSONGraphRecursive(jsonGraph: JSONGraph, path: ArraySlice<JSONPathKeySet> ) throws -> JsonGraphTuple  {
        
        switch jsonGraph {
        case .Object(_):
            guard !path.isEmpty else { throw FalcorError.InvalidAttempt }

        case .Sentinal(let sentinal):
            if case .Ref(let refPath) = sentinal {
                return (jsonGraph, (path.isEmpty) ? nil : [ refPath.convertToJSONPathSet() + path ] )
            } else {
                return (jsonGraph, nil)
            }
        }
        
        let pathKeySet = path.first!

        return try pathKeySet.map{ (jsonPathKey) -> JsonGraphTuple in
            
            let stringKey = jsonPathKey.associatedValue
            let subPathSlice = path.dropFirst()
            
            guard case .Object(let dictionary) = jsonGraph else { throw FalcorError.InvalidJSONGraph }
            guard let subGraph = dictionary[stringKey] else { return ( JSONGraph.Object([:]), nil) }
            
            let resultTuple = try getJSONGraphRecursive(jsonGraph: subGraph, path: subPathSlice)
        
            let resultJSONGraph: JSONGraph?
            let resultOptimizedPaths: [JSONPathSet]?
            
            if let graph = resultTuple.jsonGraph {
                resultJSONGraph = JSONGraph.Object([stringKey: graph])
            } else {
                resultJSONGraph = nil
            }
            
            if let op = resultTuple.optimizedPaths {
                resultOptimizedPaths = op
            } else {
                resultOptimizedPaths = nil
            }
            
            return (resultJSONGraph, resultOptimizedPaths)
            
        }.reduce( (JSONGraph.Object([String:JSONGraph]()), [JSONPathSet]() ) ) { (accumTuple, currentTuple) in
            
            
            let resultJSONGraph: JSONGraph?
            
            if let newJsonGraph = currentTuple.jsonGraph,
                let resultJsonGraph = accumTuple.jsonGraph,
                case .Object(let newDictionary) = newJsonGraph,
                case .Object(let resultDictionary) = resultJsonGraph {
                resultJSONGraph = JSONGraph.Object( resultDictionary.deepMergeJSONGraph(with: newDictionary) )
                
            } else {
                resultJSONGraph = nil
            }
            
            let optimizedPaths: [JSONPathSet]?
            
            if let newOptimizedPaths = currentTuple.optimizedPaths,
                let resultOptimizedPaths = accumTuple.optimizedPaths {
                
                optimizedPaths = [resultOptimizedPaths, newOptimizedPaths].flatMap {$0}
            } else {
                optimizedPaths =  nil
            }
            
            return (resultJSONGraph, optimizedPaths)
            
        }
    }
 }
 
