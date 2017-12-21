//
//  FalcorSearch.swift
//  FalcorEx
//
//  Created by Raymond Kim on 12/12/17.
//  Copyright © 2017 Netflix. All rights reserved.
//

import Foundation

open class FalcorSearch {
    
//    public func matchJSON(inputJson: JSON, json: JSON?) -> JSON? {
//
//        switch inputJson {
//        case .Array(_):
//            break
//        case .Object(let dictionary):
//            for (key, value) in dictionary {
//                if let json = json,
//                    case .Object(let secondaryJsonDictionary) = json {
//                    
//                }
//            }
//        
//        case .Value(_):
//            break
//
//        }
//        
//        return nil
//    }
//    
//    public func matchJSONDicionary(inputJsonDictionary: Dictionary<String, Any>, jsonDictionary: Dictionary<String, Any> ) -> [Any]? {
//        
//        _ = matchJSONDictionaryRecursive(inputJsonDictionary: inputJsonDictionary, jsonDictionary: jsonDictionary)
//        
//        return nil
//    }
//    
//    func matchJSONDictionaryRecursive(inputJsonDictionary: [String: Any], jsonDictionary: [String: Any]) -> [String: Any] {
//    
//        var searchKey: String
//        var retDictionary = [String: Any]()
//    
//        for (inputKey, inputValue) in inputJsonDictionary {
//            if inputKey.hasPrefix("$_") {
//                let index = inputKey.index(inputKey.startIndex, offsetBy: 2)
//                searchKey = String( inputKey[index...])
//    
//                for (modelKey, modelValue) in jsonDictionary {
//                    let resultDictionary = matchJSONDictionaryRecursive(inputJsonDictionary: inputValue as! Dictionary<String, Any>, jsonDictionary: modelValue as! Dictionary<String, Any>)
//                    retDictionary += resultDictionary
//                }
//    
//            } else if let inputValueString = inputValue as? String,
//                inputValueString.hasPrefix("$_"),
//                let modelValue = jsonDictionary[inputKey] as? String {
//    
//                retDictionary[inputKey] = modelValue
//            } else if let inputValueString = inputValue as? String,
//                inputValueString.hasPrefix("$_"),
//                let modelValue = jsonDictionary[inputKey] as? Int {
//    
//                retDictionary[inputKey] = modelValue
//            } else {
//    
//                return matchJSONDictionaryRecursive(inputJsonDictionary: inputJsonDictionary[inputKey] as! Dictionary<String, Any>, jsonDictionary: jsonDictionary[inputKey] as! Dictionary<String, Any>)
//            }
//        }
//
//        return retDictionary
//    }
}
