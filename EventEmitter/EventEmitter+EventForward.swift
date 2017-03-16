//
//  EventEmitter+EventForward.swift
//  EventEmitter
//
//  Created by Gujgiczer Máté on 2016. 10. 27..
//  Copyright © 2016. gujci. All rights reserved.
//

import Foundation

/// Due to 'emit()'s mutating behaviour, to support 'once()' type subscriptions Emitter must be refference types.
public extension EventEmitter {
    
    mutating func forward<Emitter: AnyObject & EventEmitter>(_ event: Event, to forwardingEvent: Event, by host: inout Emitter) {
        on(event) { [weak host] in
            host?.emit(forwardingEvent)
        }
    }
    
    mutating func forward<Emitter: AnyObject & EventEmitter>(_ events: [Event], to forwardingEvent: Event, by host: inout Emitter) {
        on(events) { [weak host] in
            host?.emit(forwardingEvent)
        }
    }
    
    mutating func forward<Emitter: AnyObject & EventEmitter>(_ event: Event, to forwardingEvents: [Event], by host: inout Emitter) {
        on(event) { [weak host] in
            forwardingEvents.forEach(){ host?.emit($0) }
        }
    }
    
    mutating func forward<Emitter: AnyObject & EventEmitter>(_ events: [Event], to forwardingEvents: [Event], by host: inout Emitter) {
        on(events) { [weak host] in
            forwardingEvents.forEach(){ host?.emit($0) }
        }
    }
}
