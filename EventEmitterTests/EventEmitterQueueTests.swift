//
//  EventEmitterQueueTests.swift
//  EventEmitter
//
//  Created by Gujgiczer Máté on 2016. 10. 06..
//  Copyright © 2016. gujci. All rights reserved.
//

import XCTest
@testable import EventEmitter

class EventEmitterQueueTests: XCTestCase {
    
    var testEmitter = TestEmitter()
    
    func testMainEvent() {
        let expectation = self.expectation(description: "main event")
        
        testEmitter.on(TestEvent.test) {
            XCTAssertTrue(Thread.isMainThread)
            expectation.fulfill()
        }
        
        DispatchQueue.global().async {
            self.testEmitter.emit(onMain: TestEvent.test)
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testMainEventNegative() {
        let expectation = self.expectation(description: "main event negative")
        
        testEmitter.on(TestEvent.test) {
            XCTAssertFalse(Thread.isMainThread)
            expectation.fulfill()
        }
        
        DispatchQueue.global().async {
            self.testEmitter.emit(TestEvent.test)
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
}
