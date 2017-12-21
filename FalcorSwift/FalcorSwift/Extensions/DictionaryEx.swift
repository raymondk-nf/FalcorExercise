//
//  DictionaryEx.swift
//  FalcorEx
//
//  Created by Raymond Kim on 11/29/17.
//  Copyright © 2017 Netflix. All rights reserved.
//

import Foundation

extension Dictionary {
    func deepMergeJSONGraph(with other: [Key: Value]) -> [Key: Value]
    {
        var result: [Key: Value] = self
        for (key, value) in other {
            
            if let value = value as? JSONGraph,
                let existingGraph = result[key] as? JSONGraph {
                
                switch(existingGraph) {
                case .Object(let existingDictionary):
                    switch (value) {
                    case .Object(let valueDictionary):
                        let merged = existingDictionary.deepMergeJSONGraph(with: valueDictionary)
                        result[key] = JSONGraph.Object( merged ) as? Value
                        
                    case .Sentinal(_):
                        break
                    }
                    
                    
                case .Sentinal(_):
                    break
                }
            }
            else {
                result[key] = value
            }
        }
        return result
    }
    
    func deepMergeJSON(with other: [Key: Value]) -> [Key: Value]
    {
        var result: [Key: Value] = self
        for (key, value) in other {
            
            if let value = value as? JSON,
                let existingJSON = result[key] as? JSON {
                
                switch(existingJSON) {
                    
                case .Object(let existingDictionary):
                    switch (value) {
                    case .Object(let valueDictionary):
                        let merged = existingDictionary.deepMergeJSON(with: valueDictionary)
                        result[key] = JSON.Object( merged ) as? Value
                        

                    case .Array(_):
                        break
                    case .Value(_):
                        break
                    }

                case .Array(_):
                    break
                case .Value(_):
                    break
                }
            }
            else {
                result[key] = value
            }
        }
        return result
    }
    
    public static func +=(lhs: inout [Key: Value], rhs: [Key: Value]) {
        rhs.forEach({ lhs[$0] = $1})
    }
    
}
