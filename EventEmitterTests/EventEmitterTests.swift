//
//  EventEmitterTests.swift
//  EventEmitterTests
//
//  Created by Gujgiczer Máté on 10/08/16.
//  Copyright © 2016 gujci. All rights reserved.
//

import XCTest

enum TestEvent: String, Event {
    case Test = "test"
}

class Test: EventEmitter {
    var listeners : Dictionary<String, Array<Any>>? = [:]
    
    func testWithInfo() {
        emit(TestEvent.Test, information: 10)
    }
}

class EventEmitterTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let expectation = expectationWithDescription("callback")
        
        var test = Test()
        test.on(TestEvent.Test) { (info: Int?) in
            expectation.fulfill()
        }
        
        test.testWithInfo()
        
        waitForExpectationsWithTimeout(10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
