////
////  FalcorSearchTests.swift
////  FalcorExTests
////
////  Created by Raymond Kim on 12/12/17.
////  Copyright © 2017 Netflix. All rights reserved.
////
//
//import XCTest
//@testable import FalcorEx
//
//class FalcorSearchTests: XCTestCase {
//    
//    let falcorSearch = FalcorSearch()
//    
//    var json : JSON!
//    var jsonDictionary: Dictionary<String, Any>!
//    
//    override func setUp() {
//        super.setUp()
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//        
//        let model = Model()
//        json = model.json
//        jsonDictionary = model.jsonDictionary
//    }
//    
//    override func tearDown() {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//        super.tearDown()
//    }
//    
//    func testMatchListsByIdIndexName() {
//        
//        let inputJson = JSON.Object([
//            "listsById" : JSON.Object([
//                "$_id" : JSON.Object([
//                    "length" : JSON.Value(.Number(3)),
//                    "$_index" : JSON.Object([
//                        "name" : .Value(.String("$_name")),
//                        "rating" : .Value(.Number(5))
//                        ]),
//                    ])
//                ])
//            
//            ])
//        
//        let resultJSON = falcorSearch.matchJSON(inputJson: inputJson, json: json)
//
//        XCTAssertNotNil(resultJSON)
//        
////        match(
////          {
////            listsById:{
////              “$_id”: {
////                length: 3,
////                “$_index”: {
////                  name: “$_name”
////                  rating: 5
////                }
////              }
////            }
////          },
////          json)
////
////        // outputs…
////
////        [{ id: 792, index: 0, name: “Die Hard” }]
//        
//        if let resultJSON = resultJSON {
//            let resultString = String(describing: resultJSON)
//
//            let correctJSON = JSON.Array([
//                JSON.Object([
//                    "id" : .Value(.Number(792)),
//                    "index" : .Value(.Number(0)),
//                    "name" : .Value(.String("Die Hard"))
//                    ])
//                ])
//            
//            let correctString = String(describing: correctJSON)
//            
//            XCTAssertEqual(resultString, correctString)
//        }
//    }
//    
//    func testMatchListsByIdIndexNameRating() {
//        
//        let inputJson = JSON.Object([
//            "listsById" : JSON.Object([
//                "$_id" : JSON.Object([
//                    "length" : JSON.Value(.Number(3)),
//                    "$_index" : JSON.Object([
//                        "name" : .Value(.String("$_name")),
//                        "rating" : .Value(.String("$_rating"))
//                        ]),
//                    ])
//                ])
//            
//            ])
//        
//        let resultJSON = falcorSearch.matchJSON(inputJson: inputJson, json: json)
//        
//        XCTAssertNotNil(resultJSON)
//        
////        match(
////          {
////            listsById:{
////              “$_id”: {
////                length: 3,
////                “$_index”: {
////                  name: “$_name”
////                  rating: “$_rating”
////                }
////              }
////            }
////          },
////          json)
////
////        // outputs…
////
////        [
////          { id: 792, index: 0, name: “Die Hard”, rating: 5 },
////          { id: 792, index: 1, name: “Get Out”,  rating: 3 }
////        ]
//
//        if let resultJSON = resultJSON {
//            let resultString = String(describing: resultJSON)
//            let correctJSON = JSON.Array([
//                JSON.Object([
//                    "id" : .Value(.Number(792)),
//                    "index" : .Value(.Number(0)),
//                    "name" : .Value(.String("Die Hard")),
//                    "rating" : .Value(.Number(5))
//                    ]),
//                JSON.Object([
//                    "id" : .Value(.Number(792)),
//                    "index" : .Value(.Number(1)),
//                    "name" : .Value(.String("Get Out")),
//                    "rating" : .Value(.Number(3))
//                    ])
//                ])
//            
//            let correctString = String(describing: correctJSON)
//            
//            XCTAssertEqual(resultString, correctString)
//        }
//    }
//    
//    func testMatchListsByIdIndexResultLengthNameRating() {
//        
//        let inputJson = JSON.Object([
//            "listsById" : JSON.Object([
//                "$_id" : JSON.Object([
//                    "length" : JSON.Value(.String("$_length")),
//                    "$_index" : JSON.Object([
//                        "name" : .Value(.String("$_name")),
//                        "rating" : .Value(.String("$_rating"))
//                        ]),
//                    ])
//                ])
//            
//            ])
//        
//        let resultJSON = falcorSearch.matchJSON(inputJson: inputJson, json: json)
//        
//        XCTAssertNotNil(resultJSON)
//        
////        match(
////          {
////            listsById:{
////              “$_id”: {
////                length: “$_length”,
////                “$_index”: {
////                  name: “$_name”
////                  rating: “$_rating”
////                }
////              }
////            }
////          },
////          json)
////
////        // outputs…
////
////        [
////          { id: 792, index: 0, name: “Die Hard”, rating: 5, length: 3 },
////          { id: 792, index: 1, name: “Get Out”,  rating: 3, length: 3 }
////        ]
//
//        if let resultJSON = resultJSON {
//            let resultString = String(describing: resultJSON)
//            let correctJSON = JSON.Array([
//                JSON.Object([
//                    "id" : .Value(.Number(792)),
//                    "index" : .Value(.Number(0)),
//                    "name" : .Value(.String("Die Hard")),
//                    "rating" : .Value(.Number(5)),
//                    "length" : .Value(.Number(3))
//                    ]),
//                JSON.Object([
//                    "id" : .Value(.Number(792)),
//                    "index" : .Value(.Number(1)),
//                    "name" : .Value(.String("Get Out")),
//                    "rating" : .Value(.Number(3)),
//                    "length" : .Value(.Number(3))
//                    ])
//                ])
//            
//            let correctString = String(describing: correctJSON)
//            
//            XCTAssertEqual(resultString, correctString)
//        }
//
//        
//    }
//    
//    func testMatchOne() {
//        
//        let inputJson = JSON.Value(.Number(1))
//        let jsonModel = JSON.Value(.Number(2))
//        
//        let resultJSON = falcorSearch.matchJSON(inputJson: inputJson, json: jsonModel)
//        
//        XCTAssertNotNil(resultJSON)
//        
////        match(1, 2) // outputs []
//        
//        if let resultJSON = resultJSON {
//            let resultString = String(describing: resultJSON)
//
//            let correctJSON = JSON.Array([])
//            
//            let correctString = String(describing: correctJSON)
//            
//            XCTAssertEqual(resultString, correctString)
//        }
//    }
//    
//    func testMatchTwo() {
//        
//        let inputJson = JSON.Value(.Number(2))
//        let jsonModel = JSON.Value(.Number(2))
//        
//        let resultJSON = falcorSearch.matchJSON(inputJson: inputJson, json: jsonModel)
//        
//        XCTAssertNotNil(resultJSON)
//        
////        match(2, 2) // outputs [{}]
//        
//        if let resultJSON = resultJSON {
//            let resultString = String(describing: resultJSON)
//            
//            let correctJSON = JSON.Array([.Object([:])])
//            
//            let correctString = String(describing: correctJSON)
//            
//            XCTAssertEqual(resultString, correctString)
//        }
//    }
//    
//    func testMatchIdWithUndefined() {
//        
//        let inputJson = JSON.Value(.String("$_id"))
//        let jsonModel: JSON? = nil
//        
//        let resultJSON = falcorSearch.matchJSON(inputJson: inputJson, json: jsonModel)
//        
//        XCTAssertNotNil(resultJSON)
//        
////        match(“$_id”, undefined) // outputs []
//        
//        if let resultJSON = resultJSON {
//            let resultString = String(describing: resultJSON)
//         
//            let correctJSON = JSON.Array([.Object([:])])
//            
//            let correctString = String(describing: correctJSON)
//            
//            XCTAssertEqual(resultString, correctString)
//        }
//    }
//    
//    func testMatchIdWithNull() {
//        
//        let inputJson = JSON.Value(.String("$_id"))
//        let jsonModel = JSON.Value(.Null)
//        
//        let resultJSON = falcorSearch.matchJSON(inputJson: inputJson, json: jsonModel)
//        
//        XCTAssertNotNil(resultJSON)
//
////        match(“$_id”, null) // outputs [{id: null}]
//        
//        if let resultJSON = resultJSON {
//            let resultString = String(describing: resultJSON)
//
//            let correctJSON = JSON.Array([
//                .Object([
//                    "id": .Value(.Null) ])
//                ])
//            
//            let correctString = String(describing: correctJSON)
//            
//            XCTAssertEqual(resultString, correctString)
//        }
//    }
//    
//    func testMatchIdWithTwo() {
//        
//        let inputJson = JSON.Value(.String("$_id"))
//        let jsonModel = JSON.Value(.Number(2))
//        
//        let resultJSON = falcorSearch.matchJSON(inputJson: inputJson, json: jsonModel)
//        
//        XCTAssertNotNil(resultJSON)
//        
////        match(“$_id”, 2) // outputs [{id: 2}]
//
//        if let resultJSON = resultJSON {
//            let resultString = String(describing: resultJSON)
//
//            let correctJSON = JSON.Array([
//                .Object([
//                    "id": .Value(.Number(2)) ])
//                ])
//            
//            let correctString = String(describing: correctJSON)
//            
//            XCTAssertEqual(resultString, correctString)
//        }
//    }
//    
//    // MARK: - JSON Dictionary Tests
//    
//    
//    func testDictionaryMatchListsByIdIndexNameRating() {
//        
//        let inputJson = [
//            "listsById" : [
//                "$_id" : [
//                    "length" : 3,
//                    "$_index" : [
//                        "name" : "$_name",
//                        "rating" : "$_rating"
//                        ],
//                    ]
//                ]
//            ]
//        
//        let resultJSON = falcorSearch.matchJSONDicionary(inputJsonDictionary: inputJson, jsonDictionary: jsonDictionary)
//        
//        XCTAssertNotNil(resultJSON)
//        
//        //        match(
//        //          {
//        //            listsById:{
//        //              “$_id”: {
//        //                length: 3,
//        //                “$_index”: {
//        //                  name: “$_name”
//        //                  rating: “$_rating”
//        //                }
//        //              }
//        //            }
//        //          },
//        //          json)
//        //
//        //        // outputs…
//        //
//        //        [
//        //          { id: 792, index: 0, name: “Die Hard”, rating: 5 },
//        //          { id: 792, index: 1, name: “Get Out”,  rating: 3 }
//        //        ]
//        
//        if let resultJSON = resultJSON {
//            let resultString = String(describing: resultJSON)
//            let correctJSON = [
//                [
//                    "id" : 792,
//                    "index" : 0,
//                    "name" : "Die Hard",
//                    "rating" : 5
//                    ],
//                [
//                    "id" : 792,
//                    "index" : 1,
//                    "name" : "Get Out",
//                    "rating" : 3
//                    ]
//                ]
//            
//            let correctString = String(describing: correctJSON)
//            
//            XCTAssertEqual(resultString, correctString)
//        }
//    }
//    
//    func testDictionaryMatchIndexNameRating() {
//        
//        let modelJson = [
//            "length" : 3,
//            "0" : [
//                "name" : "Die Hard",
//                "rating" : 5
//            ],
//            "1" : [
//                "name" : "Get Out",
//                "rating" : 3
//            ]
//            ] as [String : Any]
//    
//        
//        let inputJson = [
//            "$_index" : [
//                "name" : "$_name",
//                "rating" : "$_rating"
//            ]
//        ]
//        
//        let resultJSON = falcorSearch.matchJSONDicionary(inputJsonDictionary: inputJson, jsonDictionary: modelJson)
//        
//        XCTAssertNotNil(resultJSON)
//        
//        if let resultJSON = resultJSON {
//            let resultString = String(describing: resultJSON)
//            let correctJSON = [
//                [
//                    "index" : 0,
//                    "name" : "Die Hard",
//                    "rating" : 5
//                ],
//                [
//                    "index" : 1,
//                    "name" : "Get Out",
//                    "rating" : 3
//                ]
//            ]
//            
//            let correctString = String(describing: correctJSON)
//            
//            XCTAssertEqual(resultString, correctString)
//        }
//    }
//    
//}

