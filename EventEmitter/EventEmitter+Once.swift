//
//  EventEmitter+Once.swift
//  EventEmitter
//
//  Created by Gujgiczer Máté on 2017. 03. 16..
//  Copyright © 2017. gujci. All rights reserved.
//

import Foundation

public extension EventEmitter {
    
    /// Calls the callbanc the first time  the event is triggered
    ///
    /// - Parameters:
    ///   - event: Matching trigger events will cause this listener to fire
    ///   - action: The block of code you want executed when the event triggers
    mutating func once(_ event:Event, action:@escaping (()->())) {
        var newListener = EventListenerAction<Any>(action)
        newListener.oneTime = true
        addListener(event.rawValue, newEventListener: newListener)
    }
    
    /// Calls the callbanc the first time  the event is triggered
    ///
    /// - Parameters:
    ///   - event: Matching trigger events will cause this listener to fire
    ///   - action: The block of code you want executed when the event triggers
    mutating func once<T>(_ event:Event, action:@escaping ((T?)->())) {
        var newListener = EventListenerAction(action)
        newListener.oneTime = true
        addListener(event.rawValue, newEventListener: newListener)
    }
}
