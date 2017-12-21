//
//  Model.swift
//  FalcorEx
//
//  Created by Raymond Kim on 11/21/17.
//  Copyright © 2017 Netflix. All rights reserved.
//

import Foundation

class Model {

    var jsonGraph : JSONGraph!
    init() {
        
        jsonGraph = JSONGraph.Object( [
            "list": .Object(
                ["0": .Sentinal(.Ref([ JSONPath.String("videosById"), JSONPath.String("22")]) ),
                 "1": .Sentinal(.Ref( [JSONPath.String("videosById"), JSONPath.String("44")] )),
                 "2": .Object([
                    "0": .Sentinal(.Ref( [JSONPath.String("videosById"), JSONPath.String("44")] ))
                    ]),
                 "-1": .Sentinal(.Ref( [ JSONPath.String("list"), JSONPath.String("1") ] )),
                 "length": .Sentinal( .Primitive( .Value( .Number(3))))
                ]),
            
            "videosById": .Object( [
                "22": .Object( [
                    "name": .Sentinal( .Primitive( .Value( .String("Die Hard")))),
                    "rating": .Sentinal( .Primitive( .Value( .Number(5)))),
                    "bookmark": .Sentinal( .Atom( .Value( .Number(73973))))
                    ]),
                "44": .Object( [
                    "name": .Sentinal( .Primitive( .Value( .String("Get Out")))),
                    "rating": .Sentinal( .Primitive( .Value( .Number(5)))),
                    "bookmark": .Sentinal( .Error( .Value( .String("Couldn't retrieve bookmark"))))
                    ])

                ]),
            
            "supportedLanguages": .Sentinal( .Atom(
                JSON.Array( [.Value( .String("fr")), .Value( .String("en")) ] )))
            ]
        )
        
    }
    
}
