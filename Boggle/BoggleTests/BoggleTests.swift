//
//  BoggleTests.swift
//  BoggleTests
//
//  Created by Raymond Kim on 12/21/17.
//  Copyright © 2017 Netflix. All rights reserved.
//

import XCTest
@testable import Boggle

class BoggleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
//    func testResourceLoad() {
//        if let bundle = Bundle(for: type(of: self)),
//            let path = Bundle.main.path(forResource: "dictionary-algs4", ofType: "txt"),
//            let data = FileManager.default.contents(atPath: path),
//            let contentsAsString = String(data: data, encoding: .utf8) {
//
//            let dictionary = contentsAsString.components(separatedBy: "\n")
//            print (dictionary.count)
//
//            XCTAssertTrue(dictionary.count > 0)
//        }
//
//        XCTAssert(false)
//
//    }
    
}
