 //
//  FalcorService.swift
//  FalcorService
//
//  Created by Raymond Kim on 11/21/17.
//  Copyright © 2017 Netflix. All rights reserved.
//

import Foundation

open class FalcorService {
    
    public func getJSONGraph(jsonGraph: JSONGraph?, path: [Any], originalJsonGraph: JSONGraph? = nil ) throws -> (jsonGraph: JSONGraph?, optimizedPaths: [Any]? )  {
        
        print("Entering getJSONGraph. path: \(path)")
        
        if let aJsonGraph = jsonGraph {
            
            // Check for valid primitive types
            switch aJsonGraph {
            case .Object(_):
                guard path.count > 0 else { throw FalcorError.InvalidAttempt }
            case .Sentinal(_):
                guard path.count > 0 else { return (jsonGraph, nil) }
            }

            // Determine if at root of graph
            var passOriginalJsonGraph = originalJsonGraph
            var root = false
            if passOriginalJsonGraph == nil {
                passOriginalJsonGraph = jsonGraph
                root = true
            }
            
            // Normalize arguments
            let arguments = path.parseFirstArgument()
            
            var rebuildJsonGraph = [String:JSONGraph]()
            var optimizedPaths = [Any]()
            
            try arguments.forEach({ (key) in
                let stringKey = String(describing: key)
                let subPath = path.dropFirst()
                
                print("Iterating subpath: \(subPath) for key: \(key)")
                
                switch aJsonGraph {
                    
                case .Object(let dictionary):
                    
                    if let subGraph = dictionary[stringKey] {
                        let resultTuple = try getJSONGraph(jsonGraph: subGraph, path: Array(subPath), originalJsonGraph: passOriginalJsonGraph)
                        
                        if let graph = resultTuple.jsonGraph, let op = resultTuple.optimizedPaths {
                            rebuildJsonGraph[stringKey] = graph
                            optimizedPaths = op
                            
                        } else if let graph = resultTuple.jsonGraph {
                            rebuildJsonGraph[stringKey] = graph
                            
                        } else if let op = resultTuple.optimizedPaths  {
                            rebuildJsonGraph[stringKey] = subGraph
                            let flattenArray = [op, subPath].flatMap {$0}
                            optimizedPaths.append(flattenArray)

                        } else {
                            rebuildJsonGraph[stringKey] = subGraph
                        }
                    }
                    
                    
                case .Sentinal(let sentinal):
                    
                    switch (sentinal) {
                    case .Ref(let refPath):
                        optimizedPaths = refPath
                    case .Atom(_):
                        break
                    case .Error(_):
                        break
                    case .Primitive(_):
                        break

                        
                    }
                    
                }
            })
            
            // Run through Optimized Paths
            if root,
                optimizedPaths.count > 0 {
                try optimizedPaths.forEach({ (path ) in
                    if let aPath = path as? [Any] {
                        let resultTuple = try getJSONGraph(jsonGraph: jsonGraph, path: aPath)
                        
                        if let graph = resultTuple.jsonGraph {

                            switch (graph) {
                            case .Object(let dictionary):
                                rebuildJsonGraph = rebuildJsonGraph.deepMergeJSONGraph(with: dictionary )
                                
                            case .Sentinal(_):
                                break
                            }

                        }
                    }
                })
            }
            
            return ( (rebuildJsonGraph.count>0) ? JSONGraph.Object(rebuildJsonGraph) : nil,
                     (optimizedPaths.count>0) ? optimizedPaths : nil)
        }
        
        return (nil, nil)
        
    }
    
}

