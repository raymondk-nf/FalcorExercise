//
//  Model.swift
//  FalcorEx
//
//  Created by Raymond Kim on 11/21/17.
//  Copyright © 2017 Netflix. All rights reserved.
//

import Foundation

class Model {

    var jsonGraph : JSONGraph
    
    var json : JSON
    
    var jsonDictionary: Dictionary<String, Any>
    
    init() {
        
        jsonGraph = JSONGraph.Object( [
            "list": .Object(
                ["0": .Sentinal( .Ref( ["videosById", "22" ] ) ),
                 "1": .Sentinal(.Ref( ["videosById", "44" ] ) ),
                 "2": .Object([
                    "0": .Sentinal(.Ref( ["videosById", "44" ] ) )
                    ]),
                 "3": .Sentinal(.Ref( ["episodesById", "23" ] ) ),
                 "-1": .Sentinal(.Ref( ["list", "1" ]  ) ),
                 "length": .Sentinal( .Primitive( .Value( .Number(4))))
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
            
            "episodesById": .Sentinal( .Atom( .Value( .Number(73973)))),
            
            "supportedLanguages": .Sentinal( .Atom(
                JSON.Array( [.Value( .String("fr")), .Value( .String("en")) ] )))
            ]
        )
        
        json = JSON.Object([
            "listsById" : JSON.Object([
                "792" : JSON.Object([
                    "length" : JSON.Value(.Number(3)),
                    "0" : JSON.Object([
                        "name" : .Value(.String("Die Hard")),
                        "rating" : .Value(.Number(5))
                        ]),
                    "1" : JSON.Object([
                        "name" : .Value(.String("Get Out")),
                        "rating" : .Value(.Number(3))
                        ]),
                    "2" : JSON.Value(.Null)
                    ])
                ])
            
            ])
        
        jsonDictionary = [
            "listsById" : [
                "792" : [
                    "length" : 3,
                    "0" : [
                        "name" : "Die Hard",
                        "rating" : 5
                    ],
                    "1" : [
                        "name" : "Get Out",
                        "rating" : 3
                    ],
                    "2" : 0
                ]
            ]
        ]
        
    }
    
}
