//
//  FalcorObjCServiceTests.m
//  FalcorObjCTests
//
//  Created by Raymond Kim on 12/21/17.
//  Copyright © 2017 Netflix. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FalcorObjCService.h"
#import "FalcorObjCModel.h"

@interface FalcorObjCServiceTests : XCTestCase

@property (nonatomic) FalcorObjCService *falcorService;
@property (nonatomic) NSDictionary *jsonGraph;
@end

@implementation FalcorObjCServiceTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.

    self.falcorService = [FalcorObjCService new];
    
    FalcorObjCModel *model = [FalcorObjCModel new];
    self.jsonGraph = model.jsonGraph;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testListZero {
    [self measureBlock:^{
        NSArray *jsonPath = @[@[@"list"], @[@0]];
        
        NSDictionary *resultGraph;
        @try {
            resultGraph = [self.falcorService getJSONGraph:self.jsonGraph path:jsonPath];
        } @catch (NSException *exception) {
            resultGraph = nil;
        }
        
        XCTAssertNotNil(resultGraph);
        
        NSDictionary *correctGraph = @{ @"list": @{
                                                @0: @{ @"$type": @"ref", @"value": @[@"videosById", @22 ] }
                                                }};
        XCTAssertTrue([correctGraph isEqual:resultGraph]);
    }];
}

- (void)testListZeroAndOne {
    [self measureBlock:^{
        NSArray *jsonPath = @[@[@"list"], @[@0, @1]];
        
        NSDictionary *resultGraph;
        @try {
            resultGraph = [self.falcorService getJSONGraph:self.jsonGraph path:jsonPath];
        } @catch (NSException *exception) {
            resultGraph = nil;
        }
        
        XCTAssertNotNil(resultGraph);
        
        NSDictionary *correctGraph = @{ @"list": @{
                                                @0: @{ @"$type": @"ref", @"value": @[@"videosById", @22 ] },
                                                @1: @{ @"$type": @"ref", @"value": @[@"videosById", @44 ] },
                                                }};
        XCTAssertTrue([correctGraph isEqual:resultGraph]);
    }];
}

- (void)testListZeroName {
    [self measureBlock:^{
        NSArray *jsonPath = @[@[@"list"], @[@0], @[@"name"]];
        
        NSDictionary *resultGraph;
        @try {
            resultGraph = [self.falcorService getJSONGraph:self.jsonGraph path:jsonPath];
        } @catch (NSException *exception) {
            resultGraph = nil;
        }
        
        XCTAssertNotNil(resultGraph);
        
        NSDictionary *correctGraph = @{ @"list": @{
                                                @0: @{ @"$type": @"ref", @"value": @[@"videosById", @22 ] },
                                                },
                                        @"videosById": @{
                                                @22: @{
                                                        @"name": @"Die Hard"
                                                        }
                                                }
                                        };
        XCTAssertTrue([correctGraph isEqual:resultGraph]);
    }];
}

- (void)testListZeroAndOneName {
    [self measureBlock:^{
        NSArray *jsonPath = @[@[@"list"], @[@0, @1], @[@"name"]];
        
        NSDictionary *resultGraph;
        @try {
            resultGraph = [self.falcorService getJSONGraph:self.jsonGraph path:jsonPath];
        } @catch (NSException *exception) {
            resultGraph = nil;
        }
        
        XCTAssertNotNil(resultGraph);
        
        NSDictionary *correctGraph = @{ @"list": @{
                                                @0: @{ @"$type": @"ref", @"value": @[@"videosById", @22 ] },
                                                @1: @{ @"$type": @"ref", @"value": @[@"videosById", @44 ] },
                                                },
                                        @"videosById": @{
                                                @22: @{
                                                        @"name": @"Die Hard"
                                                        },
                                                @44: @{
                                                        @"name": @"Get Out",
                                                        },

                                                }
                                        };
        XCTAssertTrue([correctGraph isEqual:resultGraph]);
    }];
}

- (void)testListTwoZeroName {
    [self measureBlock:^{
        NSArray *jsonPath = @[@[@"list"], @[@2], @[@0], @[@"name"]];
        
        NSDictionary *resultGraph;
        @try {
            resultGraph = [self.falcorService getJSONGraph:self.jsonGraph path:jsonPath];
        } @catch (NSException *exception) {
            resultGraph = nil;
        }
        
        XCTAssertNotNil(resultGraph);
        
        NSDictionary *correctGraph = @{ @"list": @{
                                                @2: @{
                                                        @0: @{ @"$type": @"ref", @"value": @[@"videosById", @44 ] }
                                                        },

                                                },
                                        @"videosById": @{
                                                @44: @{
                                                        @"name": @"Get Out",
                                                        },
                                                
                                                }
                                        };
        XCTAssertTrue([correctGraph isEqual:resultGraph]);
    }];
}

- (void)testListTwoOne {
    [self measureBlock:^{
        NSArray *jsonPath = @[@[@"list"], @[@2], @[@1]];
        
        NSDictionary *resultGraph;
        @try {
            resultGraph = [self.falcorService getJSONGraph:self.jsonGraph path:jsonPath];
        } @catch (NSException *exception) {
            resultGraph = nil;
        }
        
        XCTAssertNotNil(resultGraph);
        
        NSDictionary *correctGraph = @{ @"list": @{
                                                @2: @{},
                                                },
                                        };
        XCTAssertTrue([correctGraph isEqual:resultGraph]);
    }];
}

- (void)testListZeroAndOneNameAndRating {
    
    [self measureBlock:^{
        NSArray *jsonPath = @[@[@"list"], @[@0, @1], @[@"name", @"rating"]];
        
        NSDictionary *resultGraph;
        @try {
            resultGraph = [self.falcorService getJSONGraph:self.jsonGraph path:jsonPath];
        } @catch (NSException *exception) {
            resultGraph = nil;
        }
        
        XCTAssertNotNil(resultGraph);
        
        NSDictionary *correctGraph = @{ @"list": @{
                                                @0: @{ @"$type": @"ref", @"value": @[@"videosById", @22 ] },
                                                @1: @{ @"$type": @"ref", @"value": @[@"videosById", @44 ] },
                                                },
                                        @"videosById": @{
                                                @22: @{
                                                        @"name": @"Die Hard",
                                                        @"rating": @5,
                                                        },
                                                @44: @{
                                                        @"name": @"Get Out",
                                                        @"rating": @5,
                                                        },
                                                
                                                }
                                        };
        XCTAssertTrue([correctGraph isEqual:resultGraph]);
    }];

}

- (void)testListLength {
    [self measureBlock:^{
        NSArray *jsonPath = @[@[@"list"], @[@"length"], @[@"name"]];
        
        NSDictionary *resultGraph;
        @try {
            resultGraph = [self.falcorService getJSONGraph:self.jsonGraph path:jsonPath];
        } @catch (NSException *exception) {
            resultGraph = nil;
        }
        
        XCTAssertNotNil(resultGraph);
        
        NSDictionary *correctGraph = @{ @"list": @{
                                                @"length": @6
                                                }
                                        };
        XCTAssertTrue([correctGraph isEqual:resultGraph]);
    }];
}

- (void)testVideoBookmarks {
    [self measureBlock:^{
        NSArray *jsonPath = @[@[@"videosById"], @[@22, @44], @[@"bookmark"]];
        
        NSDictionary *resultGraph;
        @try {
            resultGraph = [self.falcorService getJSONGraph:self.jsonGraph path:jsonPath];
        } @catch (NSException *exception) {
            resultGraph = nil;
        }
        
        XCTAssertNotNil(resultGraph);
        
        NSDictionary *correctGraph = @{    @"videosById": @{
                                                   @22: @{
                                                           @"bookmark": @{ @"$type": @"atom", @"value": @73973 }
                                                           },
                                                   @44: @{
                                                           @"bookmark": @{ @"$type": @"error", @"value": @"Couldn’t retrieve bookmark" }
                                                           },
                                                   }
                                        };
        


        XCTAssertTrue([correctGraph isEqual:resultGraph]);
    }];
}

- (void)testVideoBookmarkValues {
    [self measureBlock:^{
        NSArray *jsonPath = @[@[@"videosById"], @[@22, @44], @[@"bookmark"], @[@"value"]];
        
        NSDictionary *resultGraph;
        @try {
            resultGraph = [self.falcorService getJSONGraph:self.jsonGraph path:jsonPath];
        } @catch (NSException *exception) {
            resultGraph = nil;
        }
        
        XCTAssertNotNil(resultGraph);
        
        NSDictionary *correctGraph = @{    @"videosById": @{
                                                   @22: @{
                                                           @"bookmark": @{ @"$type": @"atom", @"value": @73973 }
                                                           },
                                                   @44: @{
                                                           @"bookmark": @{ @"$type": @"error", @"value": @"Couldn’t retrieve bookmark" }
                                                           },
                                                   }
                                           };
        
        
        
        XCTAssertTrue([correctGraph isEqual:resultGraph]);
    }];
}

- (void)testVideoReferenceBookmark {
    [self measureBlock:^{
        NSArray *jsonPath = @[@[@"list"], @[@-1], @[@"bookmark"]];
        
        NSDictionary *resultGraph;
        @try {
            resultGraph = [self.falcorService getJSONGraph:self.jsonGraph path:jsonPath];
        } @catch (NSException *exception) {
            resultGraph = nil;
        }
        
        XCTAssertNotNil(resultGraph);
        NSDictionary *correctGraph = @{@"list" : @{
                                               @1: @{ @"$type": @"ref", @"value": @[@"videosById", @44 ] },
                                               @-1: @{ @"$type": @"ref", @"value": @[@"list", @1 ] },
                                               },
                                       @"videosById": @{
                                                   @44: @{
                                                           @"bookmark": @{ @"$type": @"error", @"value": @"Couldn’t retrieve bookmark" }
                                                           },
                                                   }
                                           };
        
        XCTAssertTrue([correctGraph isEqual:resultGraph]);
    }];
}

- (void)testInvalidAttempList {
    [self measureBlock:^{
        NSArray *jsonPath = @[@[@"list"]];
        
        NSDictionary *resultGraph;
        @try {
            resultGraph = [self.falcorService getJSONGraph:self.jsonGraph path:jsonPath];
        } @catch (NSException *exception) {
            resultGraph = nil;
            NSLog(@"Invalid attempt to retrieve non-primitive value");
        }
        
        XCTAssertNil(resultGraph);
    }];
}


//MARK: - Test empty paths


/**
 Test case, empty path to atom json, return atom
 */
- (void)testEmptyPathToJsonAtom {
    NSArray *jsonPath = @[ @[] ];
    NSDictionary *modelJsonGraph = @{ @"$type": @"atom", @"value": @5 };
    
    NSDictionary *resultGraph;
    @try {
        resultGraph = [self.falcorService getJSONGraph:modelJsonGraph path:jsonPath];
    } @catch (NSException *exception) {
        resultGraph = nil;
    }
    
    XCTAssertNotNil(resultGraph);
    
    NSDictionary *correctGraph = modelJsonGraph;
    XCTAssertTrue([correctGraph isEqual:resultGraph]);
}

// Test case, empty path to ref json, return ??
- (void)testEmptyPathToJsonRef {
    NSArray *jsonPath = @[ ];
    NSDictionary *modelJsonGraph = @{ @"$type": @"ref", @"value": @[@"videosByid", @22] };
    
    NSDictionary *resultGraph;
    @try {
        resultGraph = [self.falcorService getJSONGraph:modelJsonGraph path:jsonPath];
    } @catch (NSException *exception) {
        resultGraph = nil;
    }
    
    XCTAssertNotNil(resultGraph);
    
    NSDictionary *correctGraph = modelJsonGraph;
    XCTAssertTrue([correctGraph isEqual:resultGraph]);
}

    //MARK: - Test Ranges

//    func testListRangeZeroToOneName() {
//        // follow JSON Graph references when encountered
//
//        let jsonPath = [
//            [ JSONPathKey.String("list")],
//            [ JSONPathKey.Range(from: 0, to: 1)],
//            [ JSONPathKey.String("name")],
//            ]
//
//        let resultGraph: JSONGraph?
//        do {
//            resultGraph = try falcorService.getJSONGraph( jsonGraph: jsonGraph,  path: jsonPath)
//        } catch {
//            resultGraph = nil
//        }
//
//        XCTAssertNotNil(resultGraph)
//        let resultString = String(describing: resultGraph!)
//
//        let correctGraph = JSONGraph.Object( [
//            "list": .Object(
//                ["0": .Sentinal( .Ref( ["videosById", "22" ] ) ),
//                 "1": .Sentinal(.Ref( ["videosById", "44" ] ) )
//                ]),
//
//            "videosById": .Object( [
//                "22": .Object( [
//                    "name": .Sentinal( .Primitive( .Value( .String("Die Hard"))))
//                    ]),
//                "44": .Object( [
//                    "name": .Sentinal( .Primitive( .Value( .String("Get Out"))))
//                    ])
//
//                ])
//            ])
//        let correctString = String(describing: correctGraph)
//
//        XCTAssertEqual(resultString, correctString)
//
//    }
//
//    func testListRangeZeroToFourName() {
//        // follow JSON Graph references when encountered
//
//        let jsonPath = [
//            [ JSONPathKey.String("list")],
//            [ JSONPathKey.Range(from: 0, to: 4)],
//            [ JSONPathKey.String("name")],
//            ]
//
//        let resultGraph: JSONGraph?
//        do {
//            resultGraph = try falcorService.getJSONGraph( jsonGraph: jsonGraph,  path: jsonPath)
//        } catch {
//            resultGraph = nil
//        }
//
//        XCTAssertNotNil(resultGraph)
//        let resultString = String(describing: resultGraph!)
//
//        let correctGraph = JSONGraph.Object( [
//            "list": .Object(
//                ["0": .Sentinal( .Ref( ["videosById", "22" ] ) ),
//                 "1": .Sentinal(.Ref( ["videosById", "44" ] ) ),
//                 "2": .Object([:]),
//                 "3": .Sentinal(.Ref( ["videosById", "66" ] ) ),
//                 "4": .Sentinal(.Ref( ["videosById", "88" ] ) ),
//                ]),
//
//            "videosById": .Object( [
//                "22": .Object( [
//                    "name": .Sentinal( .Primitive( .Value( .String("Die Hard"))))
//                    ]),
//                "44": .Object( [
//                    "name": .Sentinal( .Primitive( .Value( .String("Get Out"))))
//                    ]),
//                "66": .Object( [
//                    "name": .Sentinal( .Primitive( .Value( .String("Stranger Things")))),
//                    ]),
//                "88": .Object( [
//                    "name": .Sentinal( .Primitive( .Value( .String("The Crown")))),
//                    ])
//
//                ])
//            ])
//        let correctString = String(describing: correctGraph)
//
//        XCTAssertEqual(resultString, correctString)
//
//    }
//
//    func testListRangeZeroToTwoFourNameRating() {
//        // follow JSON Graph references when encountered
//
//        let jsonPath = [
//            [ JSONPathKey.String("list")],
//            [ JSONPathKey.Range(from: 0, to: 2), JSONPathKey.Number(4)],
//            [ JSONPathKey.String("name"), JSONPathKey.String("rating")],
//            ]
//
//        let resultGraph: JSONGraph?
//        do {
//            resultGraph = try falcorService.getJSONGraph( jsonGraph: jsonGraph,  path: jsonPath)
//        } catch {
//            resultGraph = nil
//        }
//
//        XCTAssertNotNil(resultGraph)
//        let resultString = String(describing: resultGraph!)
//
//        let correctGraph = JSONGraph.Object( [
//            "list": .Object(
//                ["0": .Sentinal( .Ref( ["videosById", "22" ] ) ),
//                 "1": .Sentinal(.Ref( ["videosById", "44" ] ) ),
//                 "2": .Object([:]),
//                 "4": .Sentinal(.Ref( ["videosById", "88" ] ) ),
//                 ]),
//
//            "videosById": .Object( [
//                "22": .Object( [
//                    "name": .Sentinal( .Primitive( .Value( .String("Die Hard")))),
//                    "rating": .Sentinal( .Primitive( .Value( .Number(5)))),
//                    ]),
//                "44": .Object( [
//                    "name": .Sentinal( .Primitive( .Value( .String("Get Out")))),
//                    "rating": .Sentinal( .Primitive( .Value( .Number(5)))),
//                    ]),
//                "88": .Object( [
//                    "name": .Sentinal( .Primitive( .Value( .String("The Crown")))),
//                    "rating": .Sentinal( .Primitive( .Value( .Number(3)))),
//                    ])
//
//                ])
//            ])
//        let correctString = String(describing: correctGraph)
//
//        XCTAssertEqual(resultString, correctString)
//
//    }
//
//    func testVideosByIdZeroToHundredNameRating() {
//        // follow JSON Graph references when encountered
//
//        let jsonPath = [
//            [ JSONPathKey.String("videosById")],
//            [ JSONPathKey.Range(from: 0, to: 100)],
//            [ JSONPathKey.String("name"), JSONPathKey.String("rating")],
//            ]
//
//        let resultGraph: JSONGraph?
//        do {
//            resultGraph = try falcorService.getJSONGraph( jsonGraph: jsonGraph,  path: jsonPath)
//        } catch {
//            resultGraph = nil
//        }
//
//        XCTAssertNotNil(resultGraph)
//        let resultString = String(describing: resultGraph!)
//
//        let correctGraph = JSONGraph.Object( [
//            "videosById": .Object( [
//                "22": .Object( [
//                    "name": .Sentinal( .Primitive( .Value( .String("Die Hard")))),
//                    "rating": .Sentinal( .Primitive( .Value( .Number(5)))),
//                    ]),
//                "44": .Object( [
//                    "name": .Sentinal( .Primitive( .Value( .String("Get Out")))),
//                    "rating": .Sentinal( .Primitive( .Value( .Number(5)))),
//                    ]),
//                "66": .Object( [
//                    "name": .Sentinal( .Primitive( .Value( .String("Stranger Things")))),
//                    "rating": .Sentinal( .Primitive( .Value( .Number(1)))),
//                    ]),
//                "88": .Object( [
//                    "name": .Sentinal( .Primitive( .Value( .String("The Crown")))),
//                    "rating": .Sentinal( .Primitive( .Value( .Number(3)))),
//                    ])
//
//                ])
//            ])
//        let correctString = String(describing: correctGraph)
//
//        XCTAssertEqual(resultString, correctString)
//
//    }
@end
