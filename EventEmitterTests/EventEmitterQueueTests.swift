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
    
    func testMainParameteredEvent() {
        let expectation = self.expectation(description: "main event w/ parameter")
        
        testEmitter.on(TestEvent.test) { (info: String?) in
            XCTAssert(info == "asd")
            XCTAssertTrue(Thread.isMainThread)
            expectation.fulfill()
        }
        
        DispatchQueue.global().async {
            self.testEmitter.emit(onMain: TestEvent.test, information: "asd")
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
    
    func testMainParameteredEventPerformace() {
        let expectation = self.expectation(description: "main event w/ parameter")
        let testQueue1 = DispatchQueue(label: "testQueue1")
        let testQueue2 = DispatchQueue(label: "testQueue2")
        
        var successCount = 0
        
        testEmitter.on(TestEvent.test) { (info: String?) in
            XCTAssert(info == "asd")
            successCount += 1
            guard successCount == 20 else { return }
            expectation.fulfill()
        }
        
        measure {
            DispatchQueue.global().async {
                self.testEmitter.emit(onMain: TestEvent.test, information: "asd")
                self.testEmitter.once(TestEvent.test) { (_: String?) in }
                self.testEmitter.emit(onMain: TestEvent.test, information: "asd")
                self.testEmitter.emit(TestEvent.test, information: "asd")
                self.testEmitter.emit(onMain: TestEvent.test, information: "asd")
                self.testEmitter.on(TestEvent.test) { (_: String?) in }
                self.testEmitter.emit(TestEvent.test, information: "asd")
                self.testEmitter.once(TestEvent.test) { (_: String?) in }
                self.testEmitter.emit(TestEvent.test, information: "asd")
                self.testEmitter.emit(onMain: TestEvent.test, information: "asd")
                self.testEmitter.on(TestEvent.test) { (_: String?) in }
            }
            
            testQueue1.async {
                self.testEmitter.emit(TestEvent.test, information: "asd")
                self.testEmitter.once(TestEvent.test) { (_: String?) in }
                self.testEmitter.emit(onMain: TestEvent.test, information: "asd")
                self.testEmitter.emit(TestEvent.test, information: "asd")
                self.testEmitter.on(TestEvent.test) { (_: String?) in }
                self.testEmitter.emit(onMain: TestEvent.test, information: "asd")
                self.testEmitter.emit(TestEvent.test, information: "asd")
                self.testEmitter.once(TestEvent.test) { (_: String?) in }
                self.testEmitter.emit(TestEvent.test, information: "asd")
                self.testEmitter.emit(onMain: TestEvent.test, information: "asd")
                self.testEmitter.on(TestEvent.test) { (_: String?) in }
            }
            
            testQueue2.async {
                self.testEmitter.emit(onMain: TestEvent.test, information: "asd")
                self.testEmitter.once(TestEvent.test) { (_: String?) in }
                self.testEmitter.emit(TestEvent.test, information: "asd")
                self.testEmitter.emit(TestEvent.test, information: "asd")
                self.testEmitter.emit(onMain: TestEvent.test, information: "asd")
                self.testEmitter.emit(TestEvent.test, information: "asd")
                self.testEmitter.emit(TestEvent.test, information: "asd")
                self.testEmitter.once(TestEvent.test) { (_: String?) in }
                self.testEmitter.emit(onMain: TestEvent.test, information: "asd")
            }
        }
        
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
}
