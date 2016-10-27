//
//  EventEmitter+EventForward.swift
//  EventEmitter
//
//  Created by Gujgiczer Máté on 2016. 10. 27..
//  Copyright © 2016. gujci. All rights reserved.
//

import Foundation

public extension EventEmitter {
    
    mutating func forward(_ event: Event, to forwardingEvent: Event, by host: EventEmitter) {
        on(event) {
            host.emit(forwardingEvent)
        }
    }
    
    mutating func forward(_ events: [Event], to forwardingEvent: Event, by host: EventEmitter) {
        on(events) {
            host.emit(forwardingEvent)
        }
    }
    
    mutating func forward(_ event: Event, to forwardingEvents: [Event], by host: EventEmitter) {
        on(event) {
            forwardingEvents.forEach(){ host.emit($0) }
        }
    }
    
    mutating func forward(_ events: [Event], to forwardingEvents: [Event], by host: EventEmitter) {
        on(events) {
            forwardingEvents.forEach(){ host.emit($0) }
        }
    }
}
