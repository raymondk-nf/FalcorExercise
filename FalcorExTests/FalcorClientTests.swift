//
//  FalcorClientTests.swift
//  FalcorExTests
//
//  Created by Raymond Kim on 11/30/17.
//  Copyright © 2017 Netflix. All rights reserved.
//

import XCTest
@testable import FalcorEx

class FalcorClientTests: XCTestCase {
    
    let falcorClient = FalcorClient()
    
    var jsonGraph : JSONGraph!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let model = Model()
        jsonGraph = model.jsonGraph
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testListZeroName() {
        // follow JSON Graph references when encountered
        
        let jsonPath = [
            [ JSONPathKey.String("list")],
            [ JSONPathKey.Number(0)],
            [ JSONPathKey.String("name")],
            ]
        
        let resultJSON: JSON?
        do {
            resultJSON = try falcorClient.getJSON(jsonGraph: jsonGraph,  path: jsonPath)
        } catch {
            resultJSON = nil
        }
        
        XCTAssertNotNil(resultJSON)
        let resultString = String(describing: resultJSON!)
        
        //        outputs ...
        //        {
        //            list: {
        //                0: {
        //                    name: “Die Hard”
        //                }
        //            }
        //        }
        
        let correctJSON = JSON.Object([
            "list": .Object([
                "0": .Object([
                    "name": .Value(.String("Die Hard"))
                    ])
                ])
            
            ])
        
        let correctString = String(describing: correctJSON)
        
        XCTAssertEqual(resultString, correctString)
        
    }
    
    func testListZeroAndOneName() {
        // follow JSON Graph references when encountered
        
        let jsonPath = [
            [ JSONPathKey.String("list")],
            [ JSONPathKey.Number(0), JSONPathKey.Number(1)],
            [ JSONPathKey.String("name")],
            ]
        
        let resultJSON: JSON?
        do {
            resultJSON = try falcorClient.getJSON(jsonGraph: jsonGraph,  path: jsonPath)
        } catch {
            resultJSON = nil
        }
        
        XCTAssertNotNil(resultJSON)
        let resultString = String(describing: resultJSON!)
        
//        outputs ...
//        {
//            list: {
//                0: {
//                    name: “Die Hard”
//                },
//                1: {
//                    name: “Get Out”
//                }
//            }
//        }

        let correctJSON = JSON.Object([
            "list": .Object([
                "0": .Object([
                    "name": .Value(.String("Die Hard"))
                    ]),
                "1": .Object([
                    "name": .Value(.String("Get Out"))
                    ])
                ])
        
            ])

        let correctString = String(describing: correctJSON)
        
        XCTAssertEqual(resultString, correctString)
        
    }
    
    
    func testListZeroAndOneNameAndRating() {

        
        let jsonPath = [
            [ JSONPathKey.String("list")],
            [ JSONPathKey.Number(0), JSONPathKey.Number(1)],
            [ JSONPathKey.String("name"), JSONPathKey.String("rating")],
            ]
        
        let resultJSON: JSON?
        do {
            resultJSON = try falcorClient.getJSON( jsonGraph: jsonGraph,  path: jsonPath)
        } catch {
            resultJSON = nil
        }

        XCTAssertNotNil(resultJSON)
        let resultString = String(describing: resultJSON!)

//         outputs ...
//        {
//            list: {
//              0: {
//                name: “Die Hard”,
//                rating: 5
//              },
//              1: {
//                name: “Get Out”,
//                rating: 5
//              }
//            }
//          }


        let correctJSON = JSON.Object([
            "list": .Object([
                "0": .Object([
                    "name": .Value(.String("Die Hard")),
                    "rating": .Value(.Number(5))
                    ]),
                "1": .Object([
                    "name": .Value(.String("Get Out")),
                    "rating": .Value(.Number(5))
                    ])
                ])

            ])
        let correctString = String(describing: correctJSON)

        XCTAssertEqual(resultString, correctString)

    }
    
    func testListZero() {
        
        let jsonPath = [
            [ JSONPathKey.String("list")],
            [ JSONPathKey.Number(0) ]
        ]
        
        let resultJSON: JSON?
        do {
            resultJSON = try falcorClient.getJSON( jsonGraph: jsonGraph,  path: jsonPath)
        } catch FalcorError.InvalidAttempt {
            resultJSON = nil
        } catch FalcorError.InvalidJSON {
            XCTAssertTrue(false)
            resultJSON = nil
        } catch FalcorError.InvalidJSONGraph {
            XCTAssertTrue(false)
            resultJSON = nil
        } catch FalcorError.InvalidJSONPath {
            XCTAssertTrue(false)
            resultJSON = nil
        } catch FalcorError.InvalidModel {
            XCTAssertTrue(false)
            resultJSON = nil
        } catch {
            XCTAssertTrue(false)
            resultJSON = nil
        }
        
        XCTAssertNotNil(resultJSON)
        let resultString = (resultJSON != nil) ? String(describing:  resultJSON!) : ""
        
        //         outputs ...
        //          {
        //            list: {
        //            }
        //          }
        
        let correctJSON = JSON.Object( [
            "list": JSON.Object([:])
            ] )
        let correctString = String(describing: correctJSON)
        
        XCTAssertEqual(resultString, correctString)
        
    }

    func testListZeroAndOne() {

        let jsonPath = [
            [ JSONPathKey.String("list")],
            [ JSONPathKey.Number(0), JSONPathKey.Number(1)]
            ]
        
        let resultJSON: JSON?
        do {
            resultJSON = try falcorClient.getJSON( jsonGraph: jsonGraph,  path: jsonPath)
        } catch FalcorError.InvalidAttempt {
            resultJSON = nil
        } catch FalcorError.InvalidJSON {
            XCTAssertTrue(false)
            resultJSON = nil
        } catch FalcorError.InvalidJSONGraph {
            XCTAssertTrue(false)
            resultJSON = nil
        } catch FalcorError.InvalidJSONPath {
            XCTAssertTrue(false)
            resultJSON = nil
        } catch FalcorError.InvalidModel {
            XCTAssertTrue(false)
            resultJSON = nil
        } catch {
            XCTAssertTrue(false)
            resultJSON = nil
        }

        XCTAssertNotNil(resultJSON)
        let resultString = (resultJSON != nil) ? String(describing:  resultJSON!) : ""

//         outputs ...
//          {
//            list: {
//            }
//          }

        let correctJSON = JSON.Object( [
            "list": JSON.Object([:])
            ] )
        let correctString = String(describing: correctJSON)

        XCTAssertEqual(resultString, correctString)

    }

    func testListLength() {
        
        let jsonPath = [
            [ JSONPathKey.String("list")],
            [ JSONPathKey.String("length")],
            [ JSONPathKey.String("name")]
            ]
        let resultJSON: JSON?
        do {
            resultJSON = try falcorClient.getJSON( jsonGraph: jsonGraph,  path: jsonPath )
        } catch {
            resultJSON = nil
        }


        XCTAssertNotNil(resultJSON)
        let resultString = String(describing: resultJSON!)

//        outputs ...
//        {
//            list: {
//                length: 3
//            }
//        }

        let correctJSON = JSON.Object([
            "list": .Object([
                "length": .Value( .Number(4))
                ])

            ])
        let correctString = String(describing: correctJSON)

        XCTAssertEqual(resultString, correctString)

    }

    func testVideoBookmark22() {
        
        let jsonPath = [
            [ JSONPathKey.String("videosById")],
            [ JSONPathKey.Number(22)],
            [ JSONPathKey.String("bookmark")]
            ]
        
        let resultJSON: JSON?
        do {
            resultJSON = try falcorClient.getJSON( jsonGraph: jsonGraph,  path: jsonPath )
        } catch {
            resultJSON = nil
        }


        XCTAssertNotNil(resultJSON)
        let resultString = String(describing: resultJSON!)

            // outputs …
//        {
//            videosById: {
//                22: {
//                    bookmark: 73973
//                }
//            }
//        }

        let correctJSON = JSON.Object([
            "videosById": .Object([
                "22": .Object([
                    "bookmark": .Value(.Number(73973))
                    ])
                ])
            ])
        let correctString = String(describing: correctJSON)

        XCTAssertEqual(resultString, correctString)

    }

    func testVideoBookmark44() {
        
        let jsonPath = [
            [ JSONPathKey.String("videosById")],
            [ JSONPathKey.Number(44)],
            [ JSONPathKey.String("bookmark")]
            ]
        
        let resultJSON: JSON?
        do {
            resultJSON = try falcorClient.getJSON( jsonGraph: jsonGraph,  path:  jsonPath )
        } catch FalcorError.InvalidJSONGraphError(let string) {
            resultJSON = nil
            print (string )
        } catch {
            resultJSON = nil
            XCTAssertTrue(false)
        }


        XCTAssertNil(resultJSON)
        // outputs …

//        "Couldn’t retrieve bookmark"


    }

    func testVideoBookmarkValues() {
        
        let jsonPath = [
            [ JSONPathKey.String("videosById")],
            [ JSONPathKey.Number(22) ],
            [ JSONPathKey.String("bookmark")],
            [ JSONPathKey.String("value")]
            ]
        
        let resultJSON: JSON?
        do {
            resultJSON = try falcorClient.getJSON( jsonGraph: jsonGraph,  path:  jsonPath )
        } catch {
            resultJSON = nil
        }


        XCTAssertNotNil(resultJSON)
        let resultString = String(describing: resultJSON!)

            // outputs …
//        {
//            videosById: {
//                22: {
//                    bookmark: 73973
//                }
//            }
//        }

        let correctJSON = JSON.Object([
            "videosById": .Object([
                "22": .Object([
                    "bookmark": .Value(.Number(73973))
                    ])
                ])
            ])

        let correctString = String(describing: correctJSON)

        XCTAssertEqual(resultString, correctString)

    }

    func testVideoReferenceRating() {
        
        let jsonPath = [
            [ JSONPathKey.String("list")],
            [ JSONPathKey.Number(-1)],
            [ JSONPathKey.String("rating") ]
            ]
        
        let resultJSON: JSON?
        do {
            resultJSON = try falcorClient.getJSON( jsonGraph: jsonGraph,  path: jsonPath )
        } catch {
            resultJSON = nil
        }


        XCTAssertNotNil(resultJSON)
        let resultString = String(describing: resultJSON!)

//        output...
//        {
//            list: {
//                -1: {
//                    rating: 5
//                }
//            }
//        }

        let correctJSON = JSON.Object([
            "list": .Object([
                "-1": .Object([
                    "rating": .Value(.Number(5))
                    ])
                ])

            ])
        let correctString = String(describing: correctJSON)

        XCTAssertEqual(resultString, correctString)

    }

    func testInvalidAttempList() {
        
        let jsonPath = [
            [ JSONPathKey.String("list")]
            ]
        
        let resultJSON: JSON?
        do {
            resultJSON = try falcorClient.getJSON( jsonGraph: jsonGraph,  path: jsonPath)

        } catch FalcorError.InvalidAttempt {
            print("Invalid attempt to retrieve non-primitive value")
            resultJSON = nil

        } catch {
            resultJSON = nil
            XCTAssertTrue(false)
        }
        XCTAssertNil(resultJSON)
    }

    func testSupportedLanguages() {
        
        let jsonPath = [
            [ JSONPathKey.String("supportedLanguages")]
            ]
        
        let resultJSON: JSON?
        do {
            resultJSON = try falcorClient.getJSON( jsonGraph: jsonGraph,  path: jsonPath )
        } catch {
            resultJSON = nil
        }


        XCTAssertNotNil(resultJSON)
        let resultString = String(describing: resultJSON!)

        //        output...
//        {
//            supportedLanguages: [“fr”,”en”]
//        }


        let correctJSON = JSON.Object([
            "supportedLanguages": .Array([
                .Value( .String("fr")),
                .Value( .String( "en" ))
                ])

            ])
        let correctString = String(describing: correctJSON)

        XCTAssertEqual(resultString, correctString)

    }
    
    // Test case, empty path to atom json, return atom
    func testEmptyPathToJsonAtom() {
        let jsonPath = [[JSONPathKey]]()
        let modelJsonGraph = JSONGraph.Sentinal(.Atom(
            JSON.Value(.Number(5))
            ))
        
        let resultJSON: JSON?
        do {
            resultJSON = try falcorClient.getJSON( jsonGraph: modelJsonGraph,  path: jsonPath )
        } catch {
            resultJSON = nil
        }
        
        XCTAssertNotNil(resultJSON)
        let resultString = String(describing: resultJSON!)
        
        let correctJSON = JSON.Value(.Number(5))
        let correctString = String(describing: correctJSON)
        
        XCTAssertEqual(resultString, correctString)
    }
    
    // Test case, empty path to ref json, return ??
    func testEmptyPathToJsonRef() {
        let jsonPath = [[JSONPathKey]]()
        let modelJsonGraph = JSONGraph.Sentinal(.Ref(
            ["videosById", "22"]
            ))
        
        let resultJSON: JSON?
        do {
            resultJSON = try falcorClient.getJSON( jsonGraph: modelJsonGraph,  path: jsonPath )
        } catch {
            resultJSON = nil
        }
        
        XCTAssertNotNil(resultJSON)
        let resultString = String(describing: resultJSON!)
        
        let correctJSON = JSON.Object([:])
        let correctString = String(describing: correctJSON)
        
        XCTAssertEqual(resultString, correctString)
    }
    
    // MARK: - Extra Tests for resolving paths
    
    func testList3Name() {
        // follow JSON Graph references when encountered
        
        let jsonPath = [
            [ JSONPathKey.String("list")],
            [ JSONPathKey.Number(3)],
            [ JSONPathKey.String("name")],
            ]
        
        let resultJSON: JSON?
        do {
            resultJSON = try falcorClient.getJSON(jsonGraph: jsonGraph,  path: jsonPath)
        } catch {
            resultJSON = nil
        }
        
        XCTAssertNotNil(resultJSON)
        let resultString = String(describing: resultJSON!)
        
        let correctJSON = JSON.Object([
            "list": .Object([
                "3": JSON.Object([:])
                ])
            
            ])
        
        let correctString = String(describing: correctJSON)
        
        XCTAssertEqual(resultString, correctString)
        
    }
    
    func testEpisodes23() {
        // follow JSON Graph references when encountered
        
        let jsonPath = [
            [ JSONPathKey.String("episodesById")],
            [ JSONPathKey.Number(23)],
            [ JSONPathKey.String("name")],
            ]
        
        let resultJSON: JSON?
        do {
            resultJSON = try falcorClient.getJSON(jsonGraph: jsonGraph,  path: jsonPath)
        } catch {
            resultJSON = nil
        }
        
        XCTAssertNotNil(resultJSON)
        let resultString = String(describing: resultJSON!)
        
        let correctJSON = JSON.Object([
            "episodesById": JSON.Value( .Number(73973) )
            
            ])
        
        let correctString = String(describing: correctJSON)
        
        XCTAssertEqual(resultString, correctString)
        
    }
    
    func testResolveRefPathEpisodesById23Name() {
        let jsonRefPath = [ "episodesById", "23", "name"]
        
        let resultJSON: JSONGraph? = falcorClient.resolveJsonPathReference(jsonGraph: jsonGraph, refPath: ArraySlice(jsonRefPath), rootJsonGraph: jsonGraph)
        
        XCTAssertNil(resultJSON)
//        let resultString = (resultJSON != nil ) ? String(describing: resultJSON!) : ""
//
//        let correctJSON = JSON.Object([:])
//
//        let correctString = String(describing: correctJSON)
//
//        XCTAssertEqual(resultString, correctString)
        
    }
    
    func testResolveRefPathEpisodesById() {
        let jsonRefPath = [ "episodesById"]
        
        let resultJSON: JSONGraph? = falcorClient.resolveJsonPathReference(jsonGraph: jsonGraph, refPath: ArraySlice(jsonRefPath), rootJsonGraph: jsonGraph)
        
        XCTAssertNotNil(resultJSON)
        let resultString = (resultJSON != nil ) ? String(describing: resultJSON!) : ""
        
        let correctJSON = JSONGraph.Sentinal( .Atom( .Value( .Number(73973))))
        
        let correctString = String(describing: correctJSON)
        
        XCTAssertEqual(resultString, correctString)
        
    }
    
    func testResolveRefPathEpisodesByIdUsingLoop() {
        let jsonRefPath = [ "episodesById"]
        
        let resultJSON: JSONGraph? = falcorClient.resolveJsonPathReferenceLoop(rootJsonGraph: jsonGraph, refPath: ArraySlice(jsonRefPath))
        
        XCTAssertNotNil(resultJSON)
        let resultString = (resultJSON != nil ) ? String(describing: resultJSON!) : ""
        
        let correctJSON = JSONGraph.Sentinal( .Atom( .Value( .Number(73973))))
        
        let correctString = String(describing: correctJSON)
        
        XCTAssertEqual(resultString, correctString)
        
    }
    
    //MARK: - Test Tail Recursion
    
//    func testSumRecursion() {
//
//        print ( falcorClient.tailSum(x: 100000) )
//    }
    
}



