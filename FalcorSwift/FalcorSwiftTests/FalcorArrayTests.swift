//
//  FalcorArrayTests.swift
//  FalcorExTests
//
//  Created by Raymond Kim on 12/15/17.
//  Copyright © 2017 Netflix. All rights reserved.
//

import XCTest
@testable import FalcorSwift

class FalcorArrayTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSimplePath() {
        let pathKeySet = [
            JSONPathKey.String("list"),
            JSONPathKey.Number(0)
        ]
        
        let resultString = String(describing: pathKeySet.toStringArray )
        
        let correctPathKeySet = ["list", "0"]
        let correctString = String(describing: correctPathKeySet)
        
        XCTAssertEqual(resultString, correctString)
    }
    
    func testSimpleRange() {
        let pathKeySet = [
            JSONPathKey.Range(from: 0, to: 2)
        ]

        let resultString = String(describing: pathKeySet.toStringArray )
        
        let correctPathKeySet = ["0", "1", "2"]
        let correctString = String(describing: correctPathKeySet)
        
        XCTAssertEqual(resultString, correctString)
    }
    
    func testRangeAndString() {
        let pathKeySet = [
            JSONPathKey.Range(from: 0, to: 2),
            JSONPathKey.String("name")
        ]
        
        let resultString = String(describing: pathKeySet.toStringArray )
        
        let correctPathKeySet = ["0", "1", "2", "name"]
        let correctString = String(describing: correctPathKeySet)
        
        XCTAssertEqual(resultString, correctString)
    }
    
    func testRangeAndNumber() {
        let pathKeySet = [
            JSONPathKey.Range(from: 0, to: 2),
            JSONPathKey.Number(5)
        ]
        
        let resultString = String(describing: pathKeySet.toStringArray )
        
        let correctPathKeySet = ["0", "1", "2", "5"]
        let correctString = String(describing: correctPathKeySet)
        
        XCTAssertEqual(resultString, correctString)
    }
    
    func testNumberRangeString() {
        let pathKeySet = [
            JSONPathKey.Number(-1),
            JSONPathKey.Range(from: 0, to: 2),
            JSONPathKey.String("length")
        ]
        
        let resultString = String(describing: pathKeySet.toStringArray )
        
        let correctPathKeySet = ["-1", "0", "1", "2", "length"]
        let correctString = String(describing: correctPathKeySet)
        
        XCTAssertEqual(resultString, correctString)
    }
    
    func testRangeRangeRange() {
        let pathKeySet = [
            JSONPathKey.Range(from: 0, to: 2),
            JSONPathKey.Range(from: 5, to: 10),
            JSONPathKey.Range(from: 20, to: 22)
        ]
        
        let resultString = String(describing: pathKeySet.toStringArray )
        
        let correctPathKeySet = ["0", "1", "2", "5", "6", "7", "8", "9", "10", "20", "21", "22"]
        let correctString = String(describing: correctPathKeySet)
        
        XCTAssertEqual(resultString, correctString)
    }
    
    func testRangeNumberRange() {
        let pathKeySet = [
            JSONPathKey.Range(from: 0, to: 2),
            JSONPathKey.Number(4),
            JSONPathKey.Range(from: 5, to: 10)
        ]
        
        let resultString = String(describing: pathKeySet.toStringArray )
        
        let correctPathKeySet = ["0", "1", "2", "4", "5", "6", "7", "8", "9", "10"]
        let correctString = String(describing: correctPathKeySet)
        
        XCTAssertEqual(resultString, correctString)
    }
    
    // MARK: - Sequence Tests
    
    func testSimplePathSequence() {
        let pathKeySet = [
            JSONPathKey.String("list"),
            JSONPathKey.Number(0)
        ]
        
        let sequence = AnySequence {  JSONPathKeyIterator(currentSlice: ArraySlice(pathKeySet)) }

        let resultString = String(describing: Array(sequence) )
        
        let correctPathKeySet = ["list", "0"]
        let correctString = String(describing: correctPathKeySet)
        
        XCTAssertEqual(resultString, correctString)
    }
    
    func testSimpleRangeSequence() {
        let pathKeySet = [
            JSONPathKey.Range(from: 0, to: 2)
        ]
        
        let sequence = AnySequence {  JSONPathKeyIterator(currentSlice: ArraySlice(pathKeySet)) }
        
        let resultString = String(describing: Array(sequence) )

        let correctPathKeySet = ["0", "1", "2"]
        let correctString = String(describing: correctPathKeySet)
        
        XCTAssertEqual(resultString, correctString)
    }
    
    func testRangeAndStringSequence() {
        let pathKeySet = [
            JSONPathKey.Range(from: 0, to: 2),
            JSONPathKey.String("name")
        ]
        
        let sequence = AnySequence {  JSONPathKeyIterator(currentSlice: ArraySlice(pathKeySet)) }
        
        let resultString = String(describing: Array(sequence) )

        
        let correctPathKeySet = ["0", "1", "2", "name"]
        let correctString = String(describing: correctPathKeySet)
        
        XCTAssertEqual(resultString, correctString)
    }
    
    func testRangeAndNumberSequence() {
        let pathKeySet = [
            JSONPathKey.Range(from: 0, to: 2),
            JSONPathKey.Number(5)
        ]
        
        let sequence = AnySequence {  JSONPathKeyIterator(currentSlice: ArraySlice(pathKeySet)) }
        
        let resultString = String(describing: Array(sequence) )

        
        let correctPathKeySet = ["0", "1", "2", "5"]
        let correctString = String(describing: correctPathKeySet)
        
        XCTAssertEqual(resultString, correctString)
    }
    
    func testNumberRangeStringSequence() {
        let pathKeySet = [
            JSONPathKey.Number(-1),
            JSONPathKey.Range(from: 0, to: 2),
            JSONPathKey.String("length")
        ]
        
        let sequence = AnySequence {  JSONPathKeyIterator(currentSlice: ArraySlice(pathKeySet)) }
        
        let resultString = String(describing: Array(sequence) )

        
        let correctPathKeySet = ["-1", "0", "1", "2", "length"]
        let correctString = String(describing: correctPathKeySet)
        
        XCTAssertEqual(resultString, correctString)
    }
    
    func testRangeRangeRangeSequence() {
        let pathKeySet = [
            JSONPathKey.Range(from: 0, to: 2),
            JSONPathKey.Range(from: 5, to: 10),
            JSONPathKey.Range(from: 20, to: 22)
        ]
        
        let sequence = AnySequence {  JSONPathKeyIterator(currentSlice: ArraySlice(pathKeySet)) }
        
        let resultString = String(describing: Array(sequence) )

        
        let correctPathKeySet = ["0", "1", "2", "5", "6", "7", "8", "9", "10", "20", "21", "22"]
        let correctString = String(describing: correctPathKeySet)
        
        XCTAssertEqual(resultString, correctString)
    }
    
    func testRangeNumberRangeSequence() {
        let pathKeySet = [
            JSONPathKey.Range(from: 0, to: 2),
            JSONPathKey.Number(4),
            JSONPathKey.Range(from: 5, to: 10)
        ]
        
        let sequence = AnySequence {  JSONPathKeyIterator(currentSlice: ArraySlice(pathKeySet)) }
        
        let resultString = String(describing: Array(sequence) )
        
        let correctPathKeySet = ["0", "1", "2", "4", "5", "6", "7", "8", "9", "10"]
        let correctString = String(describing: correctPathKeySet)
        
        XCTAssertEqual(resultString, correctString)
    }
}
