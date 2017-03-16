//
//  EventEmitter.swift
//  Mooovy
//
//  Created by Gujgiczer Máté on 08/02/16.
//  Ispired by Balázs Schwarzkopf
//

import Foundation

/// Protcol for all event types
public protocol Event {
    /// distinkt value for event type
    var rawValue: String {get}
}

public protocol EventEmitter {
    var listeners: [String: [Any]]? {get set}
    
    /// Create a new event listener, not expecting information from the trigger
    ///
    /// - parameter event:  Matching trigger events will cause this listener to fire
    /// - parameter action: The block of code you want executed when the event triggers
    ///
    /// - returns: Nothing
    mutating func on(_ event:Event, action:@escaping (()->()))
    
    /// Create a new event listener for multiple events, not expecting information from the trigger
    ///
    /// - parameter events: Matching trigger events will cause this listener to fire
    /// - parameter action: The block of code you want executed when the event triggers
    ///
    /// - returns: Nothing
    mutating func on(_ events:[Event], action:@escaping (()->()))
    
    /// Create a new event listener, expecting information from the trigger
    ///
    /// - parameter event:  Matching trigger events will cause this listener to fire
    /// - parameter action: The block of code you want executed when the event triggers
    ///
    /// - returns: Nothing
    mutating func on<T>(_ event:Event, action:@escaping ((T?)->()))
    
    /// Create a new event listener for multiple events, expecting information from the trigger
    ///
    /// - parameter events: Matching trigger events will cause this listener to fire
    /// - parameter action: The block of code you want executed when the event triggers
    mutating func on<T>(_ events:[Event], action:@escaping ((T?)->()))
    
    /// Triggers an event
    ///
    /// - parameter event:       Matching listener events will fire when this is called
    /// - parameter information: pass values to your listeners
    mutating func emit(_ event:Event, information:Any)
    
    /// Triggers an event
    ///
    /// - parameter event: Matching listener events will fire when this is called
    mutating func emit(_ event:Event)
    
    /// Removes all listeners by default, or specific listeners through paramters
    ///
    /// - parameter event: If an event  is passed, only listeners for that event will be removed
    mutating func removeListeners(_ event: Event?)
}
