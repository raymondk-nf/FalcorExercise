//
//  Syntax.swift
//  FalcorEx
//
//  Created by Raymond Kim on 11/21/17.
//  Copyright © 2017 Netflix. All rights reserved.
//

import Foundation


public enum JSONPrimitive {
    case String(String)
    case Null
    case Number(Int)
    case Boolean(Bool)
}

public indirect enum JSON {
    case Object( [String: JSON] )
    case Array( [JSON] )
    case Value( JSONPrimitive )
}

public enum JSONGraphSentinal {
    case Atom( JSON )
    case Error( JSON )
    case Ref(  JSONRefPath )
    case Primitive( JSON )
}

public indirect enum JSONGraph {
    case Object ( [String: JSONGraph] )
    case Sentinal (JSONGraphSentinal)
}

public enum JSONPathKey {
    case String (String)
    case Number (Int)
    
    // TODO: Ranges
//    case Range(Int, Int)
    
    var associatedValue:  String {
        get {
            switch self {
            case .String(let string):
                return string
            case .Number(let number):
                return "\(number)"
            }
        }
    }
}

public typealias JSONRefPathKey = String
public typealias JSONRefPath = [JSONRefPathKey]
public typealias JSONPathKeySet = [JSONPathKey]
public typealias JSONPathSet = [JSONPathKeySet]


extension Array where Element == JSONRefPathKey {
    func convertToJSONPathSet() -> JSONPathSet {

        return self.map { [JSONPathKey.String($0)] }
    }
}
