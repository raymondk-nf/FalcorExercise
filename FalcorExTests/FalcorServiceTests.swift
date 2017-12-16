//
//  FalcorExTests.swift
//  FalcorExTests
//
//  Created by Raymond Kim on 11/21/17.
//  Copyright © 2017 Netflix. All rights reserved.
//

import XCTest
@testable import FalcorEx

class FalcorServiceTests: XCTestCase {
    
    let falcorService = FalcorService()
    
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
    
    func testListZero() {
        
        let jsonPath = [
            [ JSONPathKey.String("list") ],
            [ JSONPathKey.Number(0)]
        ]
        
        let resultGraph: JSONGraph?
        do {
            resultGraph = try falcorService.getJSONGraph( jsonGraph: jsonGraph,  path: jsonPath )
        } catch {
            resultGraph = nil
        }
        
        
        XCTAssertNotNil(resultGraph)
        let resultString = String(describing: resultGraph!)
        
        let correctGraph = JSONGraph.Object( [
            "list": .Object(
                ["0": .Sentinal( .Ref( ["videosById", "22" ]  ) )
                ])
            ] )
        let correctString = String(describing: correctGraph)
        
        XCTAssertEqual(resultString, correctString)
        
    }
    
    func testListZeroAndOne() {

        let jsonPath = [
            [ JSONPathKey.String("list") ],
            [ JSONPathKey.Number(0), JSONPathKey.Number(1)]
            ]

        let resultGraph: JSONGraph?
        do {
             resultGraph = try falcorService.getJSONGraph( jsonGraph: jsonGraph,  path: jsonPath )
        } catch {
            resultGraph = nil
        }


        XCTAssertNotNil(resultGraph)
        let resultString = String(describing: resultGraph!)

        let correctGraph = JSONGraph.Object( [
            "list": .Object(
                ["0": .Sentinal( .Ref( ["videosById", "22" ]  ) ),
                 "1": .Sentinal(.Ref( ["videosById", "44" ]  ) )
                ])
        ] )
        let correctString = String(describing: correctGraph)

        XCTAssertEqual(resultString, correctString)

    }

    func testListZeroName() {
        // follow JSON Graph references when encountered
        
        let jsonPath = [
            [ JSONPathKey.String("list")],
            [ JSONPathKey.Number(0)],
            [ JSONPathKey.String("name")]
            ]
        
        let resultGraph: JSONGraph?
        do {
            resultGraph = try falcorService.getJSONGraph( jsonGraph: jsonGraph,  path: jsonPath)
        } catch {
            resultGraph = nil
        }
        
        XCTAssertNotNil(resultGraph)
        let resultString = String(describing: resultGraph!)
        
        let correctGraph = JSONGraph.Object( [
            "list": .Object(
                ["0": .Sentinal( .Ref( ["videosById", "22" ] ) )
                ]),
            
            "videosById": .Object( [
                "22": .Object( [
                    "name": .Sentinal( .Primitive( .Value( .String("Die Hard"))))
                    ]),
                ])
            ])
        let correctString = String(describing: correctGraph)
        
        XCTAssertEqual(resultString, correctString)
        
    }

    func testListZeroAndOneName() {
        // follow JSON Graph references when encountered

        let jsonPath = [
            [ JSONPathKey.String("list")],
            [ JSONPathKey.Number(0), JSONPathKey.Number(1)],
            [ JSONPathKey.String("name")],
            ]

        let resultGraph: JSONGraph?
        do {
            resultGraph = try falcorService.getJSONGraph( jsonGraph: jsonGraph,  path: jsonPath)
        } catch {
            resultGraph = nil
        }

        XCTAssertNotNil(resultGraph)
        let resultString = String(describing: resultGraph!)

        let correctGraph = JSONGraph.Object( [
            "list": .Object(
                ["0": .Sentinal( .Ref( ["videosById", "22" ] ) ),
                 "1": .Sentinal(.Ref( ["videosById", "44" ] ) )
                ]),

            "videosById": .Object( [
                "22": .Object( [
                    "name": .Sentinal( .Primitive( .Value( .String("Die Hard"))))
                    ]),
                "44": .Object( [
                    "name": .Sentinal( .Primitive( .Value( .String("Get Out"))))
                    ])

                ])
            ])
        let correctString = String(describing: correctGraph)

        XCTAssertEqual(resultString, correctString)

    }

    func testListTwoZeroName() {
        // follow JSON Graph references when encountered

        let jsonPath = [
            [ JSONPathKey.String("list")],
            [ JSONPathKey.Number(2) ],
            [ JSONPathKey.Number(0) ],
            [ JSONPathKey.String("name")],
            ]

        let resultGraph: JSONGraph?
        do {
            resultGraph = try falcorService.getJSONGraph( jsonGraph: jsonGraph,  path: jsonPath)
        } catch {
            resultGraph = nil
        }

        XCTAssertNotNil(resultGraph)
        let resultString = String(describing: resultGraph!)

        let correctGraph = JSONGraph.Object( [
            "list": .Object(
                ["2": .Object([
                    "0": .Sentinal(.Ref( ["videosById", "44" ] ) )
                    ])
                ]),

            "videosById": .Object( [
                "44": .Object( [
                    "name": .Sentinal( .Primitive( .Value( .String("Get Out"))))
                    ])

                ])
            ])
        let correctString = String(describing: correctGraph)

        XCTAssertEqual(resultString, correctString)

    }
    
    func testListTwoOne() {
        
        let jsonPath = [
            [ JSONPathKey.String("list")],
            [ JSONPathKey.Number(2) ],
            [ JSONPathKey.Number(1) ]
            ]
        
        let resultGraph: JSONGraph?
        do {
            resultGraph = try falcorService.getJSONGraph( jsonGraph: jsonGraph,  path: jsonPath)
        } catch {
            resultGraph = nil
        }
        
        XCTAssertNotNil(resultGraph)
        let resultString = String(describing: resultGraph!)
        
        let correctGraph = JSONGraph.Object( [
            "list": .Object(
                ["2": .Object([:])
                ])
            ])
        let correctString = String(describing: correctGraph)
        
        XCTAssertEqual(resultString, correctString)
        
    }

    func testListZeroAndOneNameAndRating() {

        
        let jsonPath = [
            [ JSONPathKey.String("list")],
            [ JSONPathKey.Number(0), JSONPathKey.Number(1) ],
            [ JSONPathKey.String("name"), JSONPathKey.String("rating")],
            ]


        let resultGraph: JSONGraph?
        do {
            resultGraph = try falcorService.getJSONGraph( jsonGraph: jsonGraph,  path: jsonPath )
        } catch {
            resultGraph = nil
        }

        XCTAssertNotNil(resultGraph)
        let resultString = String(describing: resultGraph!)

        let correctGraph = JSONGraph.Object( [
            "list": .Object(
                ["0": .Sentinal( .Ref( ["videosById", "22" ] ) ),
                 "1": .Sentinal(.Ref( ["videosById", "44" ] ) )
                ]),

            "videosById": .Object( [
                "22": .Object( [
                    "name": .Sentinal( .Primitive( .Value( .String("Die Hard")))),
                    "rating": .Sentinal( .Primitive( .Value( .Number(5)))),
                    ]),
                "44": .Object( [
                    "name": .Sentinal( .Primitive( .Value( .String("Get Out")))),
                    "rating": .Sentinal( .Primitive( .Value( .Number(5)))),
                    ])

                ])
            ])
        let correctString = String(describing: correctGraph)

        XCTAssertEqual(resultString, correctString)

    }

    func testListLength() {

        let jsonPath = [
            [ JSONPathKey.String("list")],
            [ JSONPathKey.String("length")],
            [ JSONPathKey.String("name")],
            ]

        let resultGraph: JSONGraph?
        do {
            resultGraph = try falcorService.getJSONGraph( jsonGraph: jsonGraph,  path: jsonPath)
        } catch {
            resultGraph = nil
        }


        XCTAssertNotNil(resultGraph)
        let resultString = String(describing: resultGraph!)

        let correctGraph = JSONGraph.Object( [
            "list": .Object(
                ["length": .Sentinal( .Primitive( .Value( .Number(4))))
                ]),

            ])
        let correctString = String(describing: correctGraph)

        XCTAssertEqual(resultString, correctString)

    }

    func testVideoBookmarks() {

        
        let jsonPath = [
            [ JSONPathKey.String("videosById")],
            [ JSONPathKey.Number(22), JSONPathKey.Number(44)],
            [ JSONPathKey.String("bookmark")],
            ]

        let resultGraph: JSONGraph?
        do {
            resultGraph = try falcorService.getJSONGraph( jsonGraph: jsonGraph,  path: jsonPath )
        } catch {
            resultGraph = nil
        }


        XCTAssertNotNil(resultGraph)
        let resultString = String(describing: resultGraph!)

        let correctGraph = JSONGraph.Object( [
            "videosById": .Object( [
                "22": .Object( [
                    "bookmark": .Sentinal( .Atom( .Value( .Number(73973))))
                    ]),
                "44": .Object( [
                    "bookmark": .Sentinal( .Error( .Value( .String("Couldn't retrieve bookmark"))))
                    ])

                ])
            ])
        let correctString = String(describing: correctGraph)

        XCTAssertEqual(resultString, correctString)

    }

    func testVideoBookmarkValues() {
        let jsonPath = [
            [ JSONPathKey.String("videosById")],
            [ JSONPathKey.Number(22), JSONPathKey.Number(44)],
            [ JSONPathKey.String("bookmark")],
            [ JSONPathKey.String("value")],
            ]


        let resultGraph: JSONGraph?
        do {
            resultGraph = try falcorService.getJSONGraph( jsonGraph: jsonGraph,  path: jsonPath )
        } catch {
            resultGraph = nil
        }


        XCTAssertNotNil(resultGraph)
        let resultString = String(describing: resultGraph!)

        let correctGraph = JSONGraph.Object( [
            "videosById": .Object( [
                "22": .Object( [
                    "bookmark": .Sentinal( .Atom( .Value( .Number(73973))))
                    ]),
                "44": .Object( [
                    "bookmark": .Sentinal( .Error( .Value( .String("Couldn't retrieve bookmark"))))
                    ])

                ])
            ])
        let correctString = String(describing: correctGraph)

        XCTAssertEqual(resultString, correctString)

    }

    func testVideoReferenceBookmark() {

        let jsonPath = [
            [ JSONPathKey.String("list")],
            [ JSONPathKey.Number(-1)],
            [ JSONPathKey.String("bookmark")]
            ]

        let resultGraph: JSONGraph?
        do {
            resultGraph = try falcorService.getJSONGraph( jsonGraph: jsonGraph,  path: jsonPath )
        } catch {
            resultGraph = nil
        }


        XCTAssertNotNil(resultGraph)
        let resultString = String(describing: resultGraph!)

        let correctGraph = JSONGraph.Object( [
            "list": .Object(
                ["1": .Sentinal(.Ref( ["videosById", "44" ] ) ),
                 "-1": .Sentinal(.Ref(  ["list", "1" ] ) )
                ]),

            "videosById": .Object( [
                "44": .Object( [
                    "bookmark": .Sentinal( .Error( .Value( .String("Couldn't retrieve bookmark"))))
                    ])

                ])
            ])
        let correctString = String(describing: correctGraph)

        XCTAssertEqual(resultString, correctString)

    }

    func testInvalidAttempList() {

        let jsonPath = [
            [ JSONPathKey.String("list")]
            ]

        let resultGraph: JSONGraph?
        do {
            resultGraph = try falcorService.getJSONGraph( jsonGraph: jsonGraph,  path:  jsonPath)

        } catch FalcorError.InvalidAttempt {
            print("Invalid attempt to retrieve non-primitive value")
            resultGraph = nil

        } catch {
            resultGraph = nil

        }
        XCTAssertNil(resultGraph)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
