//
//  EventEmitterForwardTests.swift
//  EventEmitter
//
//  Created by Gujgiczer Máté on 2016. 10. 27..
//  Copyright © 2016. gujci. All rights reserved.
//

import XCTest
@testable import EventEmitter

class EventEmitterForwardTests: XCTestCase {
    
    var testEmitter = TestEmitter()
    var testSecondEmitter = TestEmitter()
 
    func testForwarding() {
        let expectation = self.expectation(description: "singe event forward")
        
        testEmitter.on(TestEvent.other) {
            expectation.fulfill()
        }
        
        testSecondEmitter.forward(TestEvent.test, to: TestEvent.other, by: testEmitter)
        
        testSecondEmitter.emit(TestEvent.test)
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
