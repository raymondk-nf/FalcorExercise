//
//  FalcorObjCClientTests.m
//  FalcorObjCTests
//
//  Created by Raymond Kim on 1/4/18.
//  Copyright © 2018 Netflix. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FalcorObjCClient.h"
#import "FalcorObjCModel.h"

@interface FalcorObjCClientTests : XCTestCase

@property (nonatomic) FalcorObjCClient *falcorClient;
@property (nonatomic) NSDictionary *jsonGraph;


@end

@implementation FalcorObjCClientTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.falcorClient = [FalcorObjCClient new];
    
    FalcorObjCModel *model = [FalcorObjCModel new];
    self.jsonGraph = model.jsonGraph;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testListZeroName {
    NSArray *jsonPath = @[@[@"list"], @[@0], @[@"name"]];
    
    NSDictionary *resultGraph;
    @try {
        resultGraph = [self.falcorClient getJSON:self.jsonGraph pathSet:jsonPath];
    } @catch (NSException *exception) {
        resultGraph = nil;
    }
    
    XCTAssertNotNil(resultGraph);
    
    NSDictionary *correctGraph = @{ @"list": @{
                                            @0: @{ @"name": @"Die Hard" }
                                            }};
    XCTAssertTrue([correctGraph isEqual:resultGraph]);
}

- (void)testListZeroAndOneName {
    NSArray *jsonPath = @[@[@"list"], @[@0, @1], @[@"name"]];
    
    NSDictionary *resultGraph;
    @try {
        resultGraph = [self.falcorClient getJSON:self.jsonGraph pathSet:jsonPath];
    } @catch (NSException *exception) {
        resultGraph = nil;
    }
    
    XCTAssertNotNil(resultGraph);
    
    NSDictionary *correctGraph = @{ @"list": @{
                                            @0: @{ @"name": @"Die Hard" },
                                            @1: @{ @"name": @"Get Out" }
                                            }};
    XCTAssertTrue([correctGraph isEqual:resultGraph]);
}

- (void)testListZeroAndOneNameAndRating {
    NSArray *jsonPath = @[@[@"list"], @[@0, @1], @[@"name", @"rating"]];
    
    NSDictionary *resultGraph;
    @try {
        resultGraph = [self.falcorClient getJSON:self.jsonGraph pathSet:jsonPath];
    } @catch (NSException *exception) {
        resultGraph = nil;
    }
    
    XCTAssertNotNil(resultGraph);
    
    NSDictionary *correctGraph = @{ @"list": @{
                                            @0: @{
                                                    @"name": @"Die Hard",
                                                    @"rating": @5
                                                    },
                                            @1: @{
                                                    @"name": @"Get Out",
                                                    @"rating": @5
                                                    }
                                            }};
    XCTAssertTrue([correctGraph isEqual:resultGraph]);
}

- (void)testListZero {
    NSArray *jsonPath = @[@[@"list"], @[@0]];
    
    NSDictionary *resultGraph;
    @try {
        resultGraph = [self.falcorClient getJSON:self.jsonGraph pathSet:jsonPath];
    } @catch (NSException *exception) {
        resultGraph = nil;
    }
    
    XCTAssertNotNil(resultGraph);
    
    NSDictionary *correctGraph = @{ @"list": @{} };
    XCTAssertTrue([correctGraph isEqual:resultGraph]);
}

- (void)testListZeroAndOne {
    NSArray *jsonPath = @[@[@"list"], @[@0, @1] ];
    
    NSDictionary *resultGraph;
    @try {
        resultGraph = [self.falcorClient getJSON:self.jsonGraph pathSet:jsonPath];
    } @catch (NSException *exception) {
        resultGraph = nil;
    }
    
    XCTAssertNotNil(resultGraph);
    
    NSDictionary *correctGraph = @{ @"list": @{} };
    XCTAssertTrue([correctGraph isEqual:resultGraph]);
}

- (void)testListLength {
    NSArray *jsonPath = @[@[@"list"], @[ @"length"], @[ @"name" ] ];
    
    NSDictionary *resultGraph;
    @try {
        resultGraph = [self.falcorClient getJSON:self.jsonGraph pathSet:jsonPath];
    } @catch (NSException *exception) {
        resultGraph = nil;
    }
    
    XCTAssertNotNil(resultGraph);
    
    NSDictionary *correctGraph = @{ @"list": @{ @"length": @6} };
    XCTAssertTrue([correctGraph isEqual:resultGraph]);
}

- (void)testVideoBookmark22 {
    NSArray *jsonPath = @[@[@"videosById"], @[ @22 ], @[ @"bookmark" ] ];
    
    NSDictionary *resultGraph;
    @try {
        resultGraph = [self.falcorClient getJSON:self.jsonGraph pathSet:jsonPath];
    } @catch (NSException *exception) {
        resultGraph = nil;
    }
    
    XCTAssertNotNil(resultGraph);
    
    NSDictionary *correctGraph = @{ @"videosById": @{
                                            @22: @{ @"bookmark": @73973}
                                            }
                                    };
    XCTAssertTrue([correctGraph isEqual:resultGraph]);
}

- (void)testVideoBookmark44 {
    NSArray *jsonPath = @[@[@"videosById"], @[ @44 ], @[ @"bookmark" ] ];
    
    NSDictionary *resultGraph;
    NSString *exceptionString;
    @try {
        resultGraph = [self.falcorClient getJSON:self.jsonGraph pathSet:jsonPath];
    } @catch (NSException *exception) {
        resultGraph = nil;
        exceptionString = exception.reason;
        
    }
    
    XCTAssertNil(resultGraph);
    XCTAssertNotNil(exceptionString);
    XCTAssertTrue([exceptionString isEqualToString: @"Couldn’t retrieve bookmark"]);
}

- (void)testVideoBookmarkValues {
    NSArray *jsonPath = @[@[@"videosById"], @[ @22 ], @[ @"bookmark" ], @[ @"value" ] ];
    
    NSDictionary *resultGraph;
    @try {
        resultGraph = [self.falcorClient getJSON:self.jsonGraph pathSet:jsonPath];
    } @catch (NSException *exception) {
        resultGraph = nil;
    }
    
    XCTAssertNotNil(resultGraph);
    
    NSDictionary *correctGraph = @{ @"videosById": @{
                                            @22: @{ @"bookmark": @73973}
                                            }
                                    };
    XCTAssertTrue([correctGraph isEqual:resultGraph]);
}

- (void)testVideoReferenceRating {
    NSArray *jsonPath = @[@[@"list"], @[@-1], @[ @"rating"]];
    
    NSDictionary *resultGraph;
    @try {
        resultGraph = [self.falcorClient getJSON:self.jsonGraph pathSet:jsonPath];
    } @catch (NSException *exception) {
        resultGraph = nil;
    }
    
    XCTAssertNotNil(resultGraph);
    
    NSDictionary *correctGraph = @{ @"list": @{
                                            @-1: @{
                                                    @"rating": @5
                                                    }
                                            }};
    XCTAssertTrue([correctGraph isEqual:resultGraph]);
}

- (void)testInvalidAttempList {
    NSArray *jsonPath = @[@[@"list"] ];
    
    NSDictionary *resultGraph;
    NSString *exceptionString;
    
    @try {
        resultGraph = [self.falcorClient getJSON:self.jsonGraph pathSet:jsonPath];
    } @catch (NSException *exception) {
        resultGraph = nil;
        exceptionString = exception.reason;

    }
    
    XCTAssertNil(resultGraph);
    XCTAssertNotNil(exceptionString);
    XCTAssertTrue([exceptionString isEqualToString: @"Invalid attempt to retrieve non-primitive value"]);
}

- (void)testSupportedLanguages {
    NSArray *jsonPath = @[@[@"supportedLanguages"]];
    
    NSDictionary *resultGraph;
    @try {
        resultGraph = [self.falcorClient getJSON:self.jsonGraph pathSet:jsonPath];
    } @catch (NSException *exception) {
        resultGraph = nil;
    }
    
    XCTAssertNotNil(resultGraph);
    
    NSDictionary *correctGraph = @{ @"supportedLanguages":
                                        @[@"fr",@"en"]
                                        };
    XCTAssertTrue([correctGraph isEqual:resultGraph]);
}

- (void)testEmptyPathToJsonAtom {
    NSArray *jsonPath = @[ ];
    NSDictionary *modelJsonGraph = @{ @"$type": @"atom", @"value": @5 };
    NSDictionary *resultGraph;
    @try {
        resultGraph = [self.falcorClient getJSON:modelJsonGraph pathSet:jsonPath];
    } @catch (NSException *exception) {
        resultGraph = nil;
    }
    
    XCTAssertNotNil(resultGraph);
    
    id correctGraph = @5;
    XCTAssertTrue([correctGraph isEqual:resultGraph]);
}

// Test case, empty path to atom json, return atom
//func testEmptyPathToJsonAtom() {
//    let jsonPath = [[JSONPathKey]]()
//    let modelJsonGraph = JSONGraph.Sentinal(.Atom(
//                                                  JSON.Value(.Number(5))
//                                                  ))
//    
//    let resultJSON: JSON?
//    do {
//        resultJSON = try falcorClient.getJSON( jsonGraph: modelJsonGraph,  pathSet: jsonPath )
//    } catch {
//        resultJSON = nil
//    }
//    
//    XCTAssertNotNil(resultJSON)
//    let resultString = String(describing: resultJSON!)
//    
//    let correctJSON = JSON.Value(.Number(5))
//    let correctString = String(describing: correctJSON)
//    
//    XCTAssertEqual(resultString, correctString)
//}

// Test case, empty path to ref json, return ??
- (void)testEmptyPathToJsonRef {
    NSArray *jsonPath = @[ ];
    NSDictionary *modelJsonGraph = @{ @"$type": @"ref", @"value": @[@"videosById", @22 ] };
    NSDictionary *resultGraph;
    @try {
        resultGraph = [self.falcorClient getJSON:modelJsonGraph pathSet:jsonPath];
    } @catch (NSException *exception) {
        resultGraph = nil;
    }
    
    XCTAssertNotNil(resultGraph);
    
    NSDictionary *correctGraph = @{};
    XCTAssertTrue([correctGraph isEqual:resultGraph]);
}

// MARK: - Extra Tests for resolving paths

//func testList5Name() {
//    // follow JSON Graph references when encountered
//
//    let jsonPath = [
//                    [ JSONPathKey.String("list")],
//                    [ JSONPathKey.Number(5)],
//                    [ JSONPathKey.String("name")],
//                    ]
//
//    let resultJSON: JSON?
//    do {
//        resultJSON = try falcorClient.getJSON(jsonGraph: jsonGraph,  pathSet: jsonPath)
//    } catch {
//        resultJSON = nil
//    }
//
//    XCTAssertNotNil(resultJSON)
//    let resultString = String(describing: resultJSON!)
//
//    let correctJSON = JSON.Object([
//                                   "list": .Object([
//                                                    "5": JSON.Object([:])
//                                                    ])
//
//                                   ])
//
//    let correctString = String(describing: correctJSON)
//
//    XCTAssertEqual(resultString, correctString)
//
//}
//
//func testEpisodes23() {
//    // follow JSON Graph references when encountered
//
//    let jsonPath = [
//                    [ JSONPathKey.String("episodesById")],
//                    [ JSONPathKey.Number(23)],
//                    [ JSONPathKey.String("name")],
//                    ]
//
//    let resultJSON: JSON?
//    do {
//        resultJSON = try falcorClient.getJSON(jsonGraph: jsonGraph,  pathSet: jsonPath)
//    } catch {
//        resultJSON = nil
//    }
//
//    XCTAssertNotNil(resultJSON)
//    let resultString = String(describing: resultJSON!)
//
//    let correctJSON = JSON.Object([
//                                   "episodesById": JSON.Value( .Number(73973) )
//
//                                   ])
//
//    let correctString = String(describing: correctJSON)
//
//    XCTAssertEqual(resultString, correctString)
//
//}
//
//func testResolveRefPathEpisodesById23Name() {
//    let jsonRefPath = [ "episodesById", "23", "name"]
//
//    let resultJSON: JSONGraph? = falcorClient.resolveJsonPathReference(jsonGraph: jsonGraph, refPath: ArraySlice(jsonRefPath), rootJsonGraph: jsonGraph)
//
//    XCTAssertNil(resultJSON)
//    //        let resultString = (resultJSON != nil ) ? String(describing: resultJSON!) : ""
//    //
//    //        let correctJSON = JSON.Object([:])
//    //
//    //        let correctString = String(describing: correctJSON)
//    //
//    //        XCTAssertEqual(resultString, correctString)
//
//}
//
//func testResolveRefPathEpisodesById() {
//    let jsonRefPath = [ "episodesById"]
//
//    let resultJSON: JSONGraph? = falcorClient.resolveJsonPathReference(jsonGraph: jsonGraph, refPath: ArraySlice(jsonRefPath), rootJsonGraph: jsonGraph)
//
//    XCTAssertNotNil(resultJSON)
//    let resultString = (resultJSON != nil ) ? String(describing: resultJSON!) : ""
//
//    let correctJSON = JSONGraph.Sentinal( .Atom( .Value( .Number(73973))))
//
//    let correctString = String(describing: correctJSON)
//
//    XCTAssertEqual(resultString, correctString)
//
//}
//
//func testResolveRefPathEpisodesByIdUsingLoop() {
//    let jsonRefPath = [ "episodesById"]
//
//    let resultJSON: JSONGraph? = falcorClient.resolveJsonPathReferenceLoop(rootJsonGraph: jsonGraph, refPath: ArraySlice(jsonRefPath))
//
//    XCTAssertNotNil(resultJSON)
//    let resultString = (resultJSON != nil ) ? String(describing: resultJSON!) : ""
//
//    let correctJSON = JSONGraph.Sentinal( .Atom( .Value( .Number(73973))))
//
//    let correctString = String(describing: correctJSON)
//
//    XCTAssertEqual(resultString, correctString)
//
//}

//MARK: - Test Tail Recursion

//    func testSumRecursion() {
//
//        print ( falcorClient.tailSum(x: 100000) )
//    }

//MARK: - Test Ranges

//func testListRangeZeroToOneName() {
//    // follow JSON Graph references when encountered
//
//    let jsonPath = [
//                    [ JSONPathKey.String("list")],
//                    [ JSONPathKey.Range(from: 0, to: 1)],
//                    [ JSONPathKey.String("name")],
//                    ]
//
//    let resultJson: JSON?
//    do {
//        resultJson = try falcorClient.getJSON( jsonGraph: jsonGraph,  path: jsonPath)
//    } catch {
//        resultJson = nil
//    }
//
//    XCTAssertNotNil(resultJson)
//    let resultString = String(describing: resultJson!)
//
//    let correctJSON = JSON.Object([
//                                   "list": .Object([
//                                                    "0": .Object([
//                                                                  "name": .Value(.String("Die Hard"))
//                                                                  ]),
//                                                    "1": .Object([
//                                                                  "name": .Value(.String("Get Out"))
//                                                                  ])
//                                                    ])
//
//                                   ])
//
//    let correctString = String(describing: correctJSON)
//
//    XCTAssertEqual(resultString, correctString)
//
//}
//
//func testListRangeZeroToFourName() {
//    // follow JSON Graph references when encountered
//
//    let jsonPath = [
//                    [ JSONPathKey.String("list")],
//                    [ JSONPathKey.Range(from: 0, to: 4)],
//                    [ JSONPathKey.String("name")],
//                    ]
//
//    let resultJson: JSON?
//    do {
//        resultJson = try falcorClient.getJSON( jsonGraph: jsonGraph,  path: jsonPath)
//    } catch {
//        resultJson = nil
//    }
//
//    XCTAssertNotNil(resultJson)
//    let resultString = String(describing: resultJson!)
//
//    let correctJSON = JSON.Object([
//                                   "list": .Object([
//                                                    "0": .Object([
//                                                                  "name": .Value(.String("Die Hard"))
//                                                                  ]),
//                                                    "1": .Object([
//                                                                  "name": .Value(.String("Get Out"))
//                                                                  ]),
//                                                    "2": .Object([:]),
//                                                    "3": .Object([
//                                                                  "name": .Value( .String("Stranger Things"))
//                                                                  ]),
//                                                    "4": .Object([
//                                                                  "name": .Value( .String("The Crown"))
//                                                                  ]),
//
//                                                    ])
//
//                                   ])
//
//    let correctString = String(describing: correctJSON)
//
//    XCTAssertEqual(resultString, correctString)
//
//}
//
//func testListRangeZeroToTwoFourNameRating() {
//    // follow JSON Graph references when encountered
//
//    let jsonPath = [
//                    [ JSONPathKey.String("list")],
//                    [ JSONPathKey.Range(from: 0, to: 2), JSONPathKey.Number(4)],
//                    [ JSONPathKey.String("name"), JSONPathKey.String("rating")],
//                    ]
//
//    let resultJSON: JSON?
//    do {
//        resultJSON = try falcorClient.getJSON( jsonGraph: jsonGraph,  path: jsonPath)
//    } catch {
//        resultJSON = nil
//    }
//
//    XCTAssertNotNil(resultJSON)
//    let resultString = String(describing: resultJSON!)
//
//    let correctJSON = JSON.Object([
//                                   "list": .Object([
//                                                    "0": .Object([
//                                                                  "name": .Value(.String("Die Hard")),
//                                                                  "rating": .Value( .Number(5)),
//                                                                  ]),
//                                                    "1": .Object([
//                                                                  "name": .Value(.String("Get Out")),
//                                                                  "rating": .Value( .Number(5)),
//                                                                  ]),
//                                                    "2": .Object([:]),
//                                                    "4": .Object([
//                                                                  "name": .Value( .String("The Crown")),
//                                                                  "rating": .Value( .Number(3)),
//                                                                  ])
//                                                    ])
//
//                                   ])
//
//    let correctString = String(describing: correctJSON)
//
//    XCTAssertEqual(resultString, correctString)
//
//}
//
//func testListRangeNegOneTo10AndLengthNameRating() {
//    // follow JSON Graph references when encountered
//
//    let jsonPath = [
//                    [ JSONPathKey.String("list")],
//                    [ JSONPathKey.Range(from: -1, to: 10), JSONPathKey.String("length")],
//                    [ JSONPathKey.String("name"), JSONPathKey.String("rating")],
//                    ]
//
//    let resultJSON: JSON?
//    do {
//        resultJSON = try falcorClient.getJSON( jsonGraph: jsonGraph,  path: jsonPath)
//    } catch {
//        resultJSON = nil
//    }
//
//    XCTAssertNotNil(resultJSON)
//    let resultString = String(describing: resultJSON!)
//
//    let correctJSON = JSON.Object([
//                                   "list": .Object([
//                                                    "0": .Object([
//                                                                  "name": .Value(.String("Die Hard")),
//                                                                  "rating": .Value( .Number(5)),
//                                                                  ]),
//                                                    "1": .Object([
//                                                                  "name": .Value(.String("Get Out")),
//                                                                  "rating": .Value( .Number(5)),
//                                                                  ]),
//                                                    "2": .Object([:]),
//                                                    "3": .Object([
//                                                                  "name": .Value( .String("Stranger Things")),
//                                                                  "rating": .Value( .Number(1)),
//                                                                  ]),
//                                                    "4": .Object([
//                                                                  "name": .Value( .String("The Crown")),
//                                                                  "rating": .Value( .Number(3)),
//                                                                  ]),
//                                                    "5": .Object([:]),
//                                                    "-1": .Object([
//                                                                   "name": .Value(.String("Get Out")),
//                                                                   "rating": .Value( .Number(5)),
//                                                                   ]),
//                                                    "length": .Value(.Number(6))
//                                                    ])
//
//                                   ])
//
//    let correctString = String(describing: correctJSON)
//
//    XCTAssertEqual(resultString, correctString)
//
//}
//
//func testVideosByIdZeroToHundredNameRating() {
//    // follow JSON Graph references when encountered
//
//    let jsonPath = [
//                    [ JSONPathKey.String("videosById")],
//                    [ JSONPathKey.Range(from: 0, to: 100)],
//                    [ JSONPathKey.String("name"), JSONPathKey.String("rating")],
//                    ]
//
//    let resultJSON: JSON?
//    do {
//        resultJSON = try falcorClient.getJSON( jsonGraph: jsonGraph,  path: jsonPath)
//    } catch {
//        resultJSON = nil
//    }
//
//    XCTAssertNotNil(resultJSON)
//    let resultString = String(describing: resultJSON!)
//
//    let correctJSON = JSON.Object([
//                                   "videosById": .Object([
//                                                          "22": .Object([
//                                                                         "name": .Value(.String("Die Hard")),
//                                                                         "rating": .Value( .Number(5)),
//                                                                         ]),
//                                                          "44": .Object([
//                                                                         "name": .Value(.String("Get Out")),
//                                                                         "rating": .Value( .Number(5)),
//                                                                         ]),
//                                                          "66": .Object([
//                                                                         "name": .Value( .String("Stranger Things")),
//                                                                         "rating": .Value( .Number(1)),
//                                                                         ]),
//                                                          "88": .Object([
//                                                                         "name": .Value( .String("The Crown")),
//                                                                         "rating": .Value( .Number(3)),
//                                                                         ])
//                                                          ])
//
//                                   ])
//
//    let correctString = String(describing: correctJSON)
//
//    XCTAssertEqual(resultString, correctString)
//
//}

@end
