//
//  EventEmitterOnceTests.swift
//  EventEmitter
//
//  Created by Gujgiczer Máté on 2017. 03. 16..
//  Copyright © 2017. gujci. All rights reserved.
//

import XCTest
@testable import EventEmitter

class EventEmitterOnceTests: XCTestCase {

    var testEmitter = TestEmitter()
    
    func testOnce() {
        let expectation = self.expectation(description: "singe event")
        
        testEmitter.once(TestEvent.test) {
            expectation.fulfill()
        }
        
        testEmitter.emit(TestEvent.test)
        testEmitter.emit(TestEvent.test)
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testParameterizedOnce() {
        let expectation = self.expectation(description: "singe event")
            
        testEmitter.once(TestEvent.test) { (info: Int?) in
            XCTAssertEqual(info, 10)
            expectation.fulfill()
        }
            
        testEmitter.emit(TestEvent.test, information: 10)
        testEmitter.emit(TestEvent.test, information: 10)
            
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
