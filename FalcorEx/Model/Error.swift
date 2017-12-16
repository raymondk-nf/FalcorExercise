//
//  Error.swift
//  FalcorEx
//
//  Created by Raymond Kim on 11/30/17.
//  Copyright © 2017 Netflix. All rights reserved.
//

import Foundation

public enum FalcorError: Error {
    case InvalidAttempt
    case InvalidJSONGraph
    case InvalidJSONGraphError(JSON)
    case InvalidJSONPath
    case InvalidJSON
    case InvalidModel
    
}

