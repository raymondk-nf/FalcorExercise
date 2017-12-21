 //
//  FalcorService.swift
//  FalcorService
//
//  Created by Raymond Kim on 11/21/17.
//  Copyright © 2017 Netflix. All rights reserved.
//

import Foundation

open class FalcorService {
    
    public func getJSONGraph(jsonGraph: JSONGraph?, path: [Any] ) throws -> (jsonGraph: JSONGraph?, optimizedPaths: [Any]? )  {
        
        if let aJsonGraph = jsonGraph {
            
            // Check for valid primitive types
            switch aJsonGraph {
            case .Object(_):
                guard path.count > 0 else { throw FalcorError.InvalidAttempt }
            case .Sentinal(_):
                break
            }
            
            // Normalize arguments
            let arguments = path.parseFirstArgument()
            
            var rebuildJsonGraph = [String:JSONGraph]()
            var optimizedPaths = [Any]()
            
            try arguments.forEach({ (key) in
                let stringKey = String(describing: key)
                let subPath = path.dropFirst()
                
                switch aJsonGraph {
                    
                case .Object(let dictionary):
                    
                    if let subGraph = dictionary[stringKey] {
                        let resultTuple = try getJSONGraph(jsonGraph: subGraph, path: Array(subPath))
                        
                        if let graph = resultTuple.jsonGraph, let op = resultTuple.optimizedPaths {
                            rebuildJsonGraph[stringKey] = graph
                            optimizedPaths = op
                        
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
                            
                        } else if let graph = resultTuple.jsonGraph {
                            rebuildJsonGraph[stringKey] = graph
                            
                        } else if let op = resultTuple.optimizedPaths  {
                            rebuildJsonGraph[stringKey] = subGraph
                            let flattenArray = [op, Array(subPath)].flatMap {$0}
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
            
            return ( (rebuildJsonGraph.count>0) ? JSONGraph.Object(rebuildJsonGraph) : nil,
                     (optimizedPaths.count>0) ? optimizedPaths : nil)
        }
        
        return (jsonGraph, nil)
        
    }
    
}

