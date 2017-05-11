//
//  EventEmitter+Once.swift
//  EventEmitter
//
//  Created by Gujgiczer Máté on 2017. 03. 16..
//  Copyright © 2017. gujci. All rights reserved.
//

import Foundation

public extension EventEmitter {
    
    /// Calls the callback the first time  the event is triggered
    ///
    /// - Parameters:
    ///   - event: Matching trigger events will cause this listener to fire
    ///   - action: The block of code you want executed when the event triggers
    mutating func once(_ event:Event, action:@escaping (()->())) {
        var newListener = EventListenerAction<Any>(action)
        newListener.oneTime = true
        addListener(event.rawValue, newEventListener: newListener)
    }
    
    /// Calls the callback the first time  the event is triggered
    ///
    /// - Parameters:
    ///   - event: Matching trigger events will cause this listener to fire
    ///   - action: The block of code you want executed when the event triggers
    mutating func once<T>(_ event:Event, action:@escaping ((T?)->())) {
        var newListener = EventListenerAction(action)
        newListener.oneTime = true
        addListener(event.rawValue, newEventListener: newListener)
    }
    
    /// Calls the callback one time when the 'when' condition is true
    ///
    /// - Parameters:
    ///   - event: Matching trigger events will cause this listener to fire
    ///   - action: The block of code you want executed when the event triggers
    ///   - when: condition to perform the action
    mutating func once(_ event:Event, action:@escaping (()->()), when: @escaping(()->Bool)) {
        var newListener = EventListenerAction<Any>(action)
        newListener.thisTime = when
        addListener(event.rawValue, newEventListener: newListener)
    }
    
    /// Calls the callback one time when the 'when' condition is true
    ///
    /// - Parameters:
    ///   - event: Matching trigger events will cause this listener to fire
    ///   - action: The block of code you want executed when the event triggers
    ///   - when: condition to perform the action
    mutating func once<T>(_ event:Event, action:@escaping ((T?)->()), when: @escaping(()->Bool)) {
        var newListener = EventListenerAction(action)
        newListener.thisTime = when
        addListener(event.rawValue, newEventListener: newListener)
    }
}
