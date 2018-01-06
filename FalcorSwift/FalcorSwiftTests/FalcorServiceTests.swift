//
//  FalcorExTests.swift
//  FalcorExTests
//
//  Created by Raymond Kim on 11/21/17.
//  Copyright © 2017 Netflix. All rights reserved.
//

import XCTest
@testable import FalcorSwift

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
        
        measure {
            
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
    }
    
    func testListZeroAndOne() {

        measure {
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

    }

    func testListZeroName() {
        // follow JSON Graph references when encountered
        
        measure {
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
    }

    func testListZeroAndOneName() {
        // follow JSON Graph references when encountered
        measure {
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
    }

    func testListTwoZeroName() {
        // follow JSON Graph references when encountered
        measure {
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
    }
    
    func testListTwoOne() {
        measure {
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
    }

    func testListZeroAndOneNameAndRating() {

        measure {
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
    }

    func testListLength() {
        measure {
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
                    ["length": .Sentinal( .Primitive( .Value( .Number(6))))
                    ]),

                ])
            let correctString = String(describing: correctGraph)

            XCTAssertEqual(resultString, correctString)
        }
    }

    func testVideoBookmarks() {

        measure {
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
    }

    func testVideoBookmarkValues() {
        measure {
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
    }

    func testVideoReferenceBookmark() {

        measure {
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
    }

    func testInvalidAttempList() {

        measure {
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
    }
    
    //MARK: - Test empty paths

    // Test case, empty path to atom json, return atom
    func testEmptyPathToJsonAtom() {
        let jsonPath = [[JSONPathKey]]()
        let modelJsonGraph = JSONGraph.Sentinal(.Atom(
            JSON.Value(.Number(5))
            ))
        
        let resultGraph: JSONGraph?
        do {
            resultGraph = try falcorService.getJSONGraph( jsonGraph: modelJsonGraph,  path: jsonPath )
        } catch {
            resultGraph = nil
        }
        
        XCTAssertNotNil(resultGraph)
        let resultString = String(describing: resultGraph!)
        
        let correctGraph = modelJsonGraph
        let correctString = String(describing: correctGraph)
        
        XCTAssertEqual(resultString, correctString)
    }
    
    // Test case, empty path to ref json, return ??
    func testEmptyPathToJsonRef() {
        let jsonPath = [[JSONPathKey]]()
        let modelJsonGraph = JSONGraph.Sentinal(.Ref(
            ["videosById", "22"]
            ))
        
        let resultGraph: JSONGraph?
        do {
            resultGraph = try falcorService.getJSONGraph( jsonGraph: modelJsonGraph,  path: jsonPath )
        } catch {
            resultGraph = nil
        }
        
        XCTAssertNotNil(resultGraph)
        let resultString = String(describing: resultGraph!)
        
        let correctGraph = modelJsonGraph
        let correctString = String(describing: correctGraph)
        
        XCTAssertEqual(resultString, correctString)
    }
    
    //MARK: - Test Ranges
    
    func testListRangeZeroToOneName() {
        // follow JSON Graph references when encountered

        let jsonPath = [
            [ JSONPathKey.String("list")],
            [ JSONPathKey.Range(from: 0, to: 1)],
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
    
    func testListRangeZeroToFourName() {
        // follow JSON Graph references when encountered
        
        let jsonPath = [
            [ JSONPathKey.String("list")],
            [ JSONPathKey.Range(from: 0, to: 4)],
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
                 "1": .Sentinal(.Ref( ["videosById", "44" ] ) ),
                 "2": .Object([:]),
                 "3": .Sentinal(.Ref( ["videosById", "66" ] ) ),
                 "4": .Sentinal(.Ref( ["videosById", "88" ] ) ),
                ]),
            
            "videosById": .Object( [
                "22": .Object( [
                    "name": .Sentinal( .Primitive( .Value( .String("Die Hard"))))
                    ]),
                "44": .Object( [
                    "name": .Sentinal( .Primitive( .Value( .String("Get Out"))))
                    ]),
                "66": .Object( [
                    "name": .Sentinal( .Primitive( .Value( .String("Stranger Things")))),
                    ]),
                "88": .Object( [
                    "name": .Sentinal( .Primitive( .Value( .String("The Crown")))),
                    ])
                
                ])
            ])
        let correctString = String(describing: correctGraph)
        
        XCTAssertEqual(resultString, correctString)
        
    }
    
    func testListRangeZeroToTwoFourNameRating() {
        // follow JSON Graph references when encountered
        
        let jsonPath = [
            [ JSONPathKey.String("list")],
            [ JSONPathKey.Range(from: 0, to: 2), JSONPathKey.Number(4)],
            [ JSONPathKey.String("name"), JSONPathKey.String("rating")],
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
                 "1": .Sentinal(.Ref( ["videosById", "44" ] ) ),
                 "2": .Object([:]),
                 "4": .Sentinal(.Ref( ["videosById", "88" ] ) ),
                 ]),
            
            "videosById": .Object( [
                "22": .Object( [
                    "name": .Sentinal( .Primitive( .Value( .String("Die Hard")))),
                    "rating": .Sentinal( .Primitive( .Value( .Number(5)))),
                    ]),
                "44": .Object( [
                    "name": .Sentinal( .Primitive( .Value( .String("Get Out")))),
                    "rating": .Sentinal( .Primitive( .Value( .Number(5)))),
                    ]),
                "88": .Object( [
                    "name": .Sentinal( .Primitive( .Value( .String("The Crown")))),
                    "rating": .Sentinal( .Primitive( .Value( .Number(3)))),
                    ])
                
                ])
            ])
        let correctString = String(describing: correctGraph)
        
        XCTAssertEqual(resultString, correctString)
        
    }
    
    func testVideosByIdZeroToHundredNameRating() {
        // follow JSON Graph references when encountered
        
        let jsonPath = [
            [ JSONPathKey.String("videosById")],
            [ JSONPathKey.Range(from: 0, to: 100)],
            [ JSONPathKey.String("name"), JSONPathKey.String("rating")],
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
            "videosById": .Object( [
                "22": .Object( [
                    "name": .Sentinal( .Primitive( .Value( .String("Die Hard")))),
                    "rating": .Sentinal( .Primitive( .Value( .Number(5)))),
                    ]),
                "44": .Object( [
                    "name": .Sentinal( .Primitive( .Value( .String("Get Out")))),
                    "rating": .Sentinal( .Primitive( .Value( .Number(5)))),
                    ]),
                "66": .Object( [
                    "name": .Sentinal( .Primitive( .Value( .String("Stranger Things")))),
                    "rating": .Sentinal( .Primitive( .Value( .Number(1)))),
                    ]),
                "88": .Object( [
                    "name": .Sentinal( .Primitive( .Value( .String("The Crown")))),
                    "rating": .Sentinal( .Primitive( .Value( .Number(3)))),
                    ])
                
                ])
            ])
        let correctString = String(describing: correctGraph)
        
        XCTAssertEqual(resultString, correctString)
        
    }
}
