 //
 //  FalcorService.swift
 //  FalcorService
 //
 //  Created by Raymond Kim on 11/21/17.
 //  Copyright © 2017 Netflix. All rights reserved.
 //
 
 import Foundation
 
 
 open class FalcorService {
    
    typealias JsonGraphDictionaryOptionalTuple = ( jsonGraphDictionary:(String, JSONGraph)?, optimizedPaths: [JSONPathSet]? )
    typealias JsonGraphOptimizedPathsTuple = (jsonGraph: JSONGraph, optimizedPaths: [JSONPathSet]? )

    public func getJSONGraph(jsonGraph: JSONGraph, path: JSONPathSet) throws -> JSONGraph {
        
        var buildJSONGraph = [String:JSONGraph]()
        var optimizedPaths = [path]
        
        while !optimizedPaths.isEmpty {
            
            let resultTuple: JsonGraphOptimizedPathsTuple
            do {
                resultTuple = try getJSONGraph(jsonGraph: jsonGraph, path: ArraySlice(optimizedPaths.removeFirst()))
            }
            catch FalcorError.InvalidAttempt {
                if !buildJSONGraph.isEmpty {
                    return JSONGraph.Object(buildJSONGraph)
                }
                else {
                    throw FalcorError.InvalidAttempt
                }
            }
            
            let (resultGraph, resultOptimizedPaths) = resultTuple
            
            switch (resultGraph) {
            case .Object(let dictionary):
                buildJSONGraph = buildJSONGraph.deepMergeJSONGraph(with: dictionary )
            case .Sentinal(_):
                return resultGraph
            }

            if let resultOptimizedPaths = resultOptimizedPaths {
                optimizedPaths += resultOptimizedPaths
            }
        }
        
        return JSONGraph.Object(buildJSONGraph)
        
    }
    
    func getJSONGraph(jsonGraph: JSONGraph, path: ArraySlice<JSONPathKeySet> ) throws -> JsonGraphOptimizedPathsTuple  {
        
        switch jsonGraph {
        case .Object(let dictionary):
            guard !path.isEmpty else { throw FalcorError.InvalidAttempt }

            let pathKeySet = path.first!.toStringArray
            let subPathSlice = path.dropFirst()
            
            let jsonGraphDictionaryOptionalTupleArray = try pathKeySet.map{ (stringKey) -> JsonGraphDictionaryOptionalTuple in
                
                guard let subGraph = dictionary[stringKey] else { return ( nil, nil) }

                let (resultGraph, resultOptimizedPaths) = try getJSONGraph(jsonGraph: subGraph, path: subPathSlice)

                return ( (stringKey, resultGraph), resultOptimizedPaths)
            }

            // Extract dictionary tuples and filter out nils
            let jsonGraphTupleArray = jsonGraphDictionaryOptionalTupleArray.flatMap { $0.jsonGraphDictionary }
            let combinedJsonGraph = JSONGraph.Object( Dictionary(uniqueKeysWithValues: jsonGraphTupleArray) )
            
            // Extract optimized paths and filter out nils
            // Then flatten array of arrays again
            // jsonGraphDictionaryOptionalTupleArray = [[JSONPathSet]?]
            // jsonGraphDictionaryOptionalTupleArray.flatMap { $0.optimizedPaths } = [[ JSONPathSet ]]
            // jsonGraphDictionaryOptionalTupleArray.flatMap { $0.optimizedPaths }.flatMap { $0 } = [ JSONPathSet ]
            let combinedOptimizedPaths = jsonGraphDictionaryOptionalTupleArray.flatMap { $0.optimizedPaths }.flatMap { $0 }

            return (combinedJsonGraph, combinedOptimizedPaths)
            
        case .Sentinal(let sentinal):
            
            switch (sentinal) {
            case .Atom(_):
                fallthrough
            case .Error(_):
                fallthrough
            case .Primitive(_):
                return (jsonGraph, nil)
                
            case .Ref(let refPath):
                return (jsonGraph, (path.isEmpty) ? nil : [ refPath.convertToJSONPathSet() + path ] )
            }
            
        }
    }
 }
 
