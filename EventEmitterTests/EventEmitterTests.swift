//
//  EventEmitterTests.swift
//  EventEmitterTests
//
//  Created by Gujgiczer Máté on 10/08/16.
//  Copyright © 2016 gujci. All rights reserved.
//

import XCTest
@testable import EventEmitter

enum TestEvent: String, Event {
    case test
    case other
}

class TestEmitter: EventEmitter {
    var listeners : Dictionary<String, Array<Any>>? = [:]
}

class EventEmitterTests: XCTestCase {
    
    var testEmitter = TestEmitter()
    
    func testSingleEvent() {
        let expectation = self.expectation(description: "singe event")
        
        testEmitter.on(TestEvent.test) { (info: Int?) in
            XCTAssertEqual(info, 10)
            expectation.fulfill()
        }
        
        testEmitter.emit(TestEvent.test, information: 10)
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testSingleString() {
        let expectation = self.expectation(description: "singe string")
        
        testEmitter.on("testString") { (info: Int?) in
            XCTAssertEqual(info, 10)
            expectation.fulfill()
        }
        
        testEmitter.emit("testString", information: 10)
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testMultipleEvents() {
        let expectation = self.expectation(description: "multiple events")
        
        testEmitter.on([TestEvent.test, TestEvent.other]) { (info: Int?) in
            XCTAssertEqual(info, 10)
            expectation.fulfill()
        }
        
        testEmitter.emit(TestEvent.test, information: 10)
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
