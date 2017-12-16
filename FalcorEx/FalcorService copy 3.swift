 //
 //  FalcorService.swift
 //  FalcorService
 //
 //  Created by Raymond Kim on 11/21/17.
 //  Copyright © 2017 Netflix. All rights reserved.
 //
 
 import Foundation
 
 open class FalcorService {
    
    public func getJSONGraph(jsonGraph: JSONGraph?, path: [JSONPath] ) throws -> (jsonGraph: JSONGraph?, optimizedPaths: [[JSONPath]]? )  {
        
        guard let aJsonGraph = jsonGraph else { throw FalcorError.InvalidJSONGraph }
        
        if case .Object(_) = aJsonGraph {
            guard path.count > 0 else { throw FalcorError.InvalidAttempt }
        }
        
        // Normalize arguments
        let arguments = path.parseFirstJSONPathArgument()
        
        var rebuildJsonGraph = [String:JSONGraph]()
        var optimizedPaths = [[JSONPath]]()
        
        try arguments.forEach({ (jsonPathKey) in
            
            let stringKey = JSONPathValue(jsonPathKey)
            let subPath = path.dropFirst()
            
            switch aJsonGraph {
                
            case .Object(let dictionary):
                
                if let subGraph = dictionary[stringKey] {
                    let resultTuple = try getJSONGraph(jsonGraph: subGraph, path: Array(subPath))
                    
                    if let graph = resultTuple.jsonGraph {
                        rebuildJsonGraph[stringKey] = graph
                        
                        if let optimizedPaths = resultTuple.optimizedPaths {
                            try optimizedPaths.forEach({ (optimizedPath ) in
                                let resultTuple = try getJSONGraph(jsonGraph: jsonGraph, path: optimizedPath)
                                
                                if let graph = resultTuple.jsonGraph {
                                    if case .Object(let dictionary) = graph {
                                        rebuildJsonGraph = rebuildJsonGraph.deepMergeJSONGraph(with: dictionary )
                                    }
                                }
                            })
                        }
                    } else if let op = resultTuple.optimizedPaths  {
                        rebuildJsonGraph[stringKey] = subGraph
                        let flattenArray = [op.first!, Array(subPath)].flatMap {$0}
                        optimizedPaths.append(flattenArray )
                        
                    } else {
                        rebuildJsonGraph[stringKey] = subGraph
                    }
                }
                
                
            case .Sentinal(let sentinal):
                
                if case .Ref(let refPath) = sentinal {
                    optimizedPaths.append(refPath)
                }
            }
        })
        
        return ( (rebuildJsonGraph.count>0) ? JSONGraph.Object(rebuildJsonGraph) : nil,
                 (optimizedPaths.count>0) ? optimizedPaths : nil)
    }
    
 }
 
