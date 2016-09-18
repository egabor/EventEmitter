//
//  EventEmitter.swift
//  Mooovy
//
//  Created by Gujgiczer Máté on 08/02/16.
//  Ispired by Balázs Schwarzkopf
//

import Foundation

struct EventListenerAction <T> {
    var listenerAction : ((T?) -> ())
    
    init(_ callback:@escaping ((T?) -> ())) {
        listenerAction = callback;
    }
    
    init(_ callback:@escaping (() -> ())) {
        listenerAction = {(data :T?) -> () in
            callback()
        }
    }
}

public protocol EventEmitter {
    var listeners : Dictionary<String, Array<Any>>? {get set}
    
    /// Create a new event listener, not expecting information from the trigger
    /// - Parameters:
    ///     - eventName: Matching trigger eventNames will cause this listener to fire
    ///     - action: The block of code you want executed when the event triggers
    mutating func on(_ eventName:String, action:@escaping (()->()))
    
    /// Create a new event listener for multiple events, not expecting information from the trigger
    /// - Parameters:
    ///     - eventNames: Matching trigger eventNames will cause this listener to fire
    ///     - action: The block of code you want executed when the event triggers
    mutating func on(_ eventNames:[String], action:@escaping (()->()))
    
    /// Create a new event listener, expecting information from the trigger
    /// - Parameters:
    ///     - eventName: Matching trigger eventNames will cause this listener to fire
    ///     - action: The block of code you want executed when the event triggers
    mutating func on<T>(_ eventName:String, action:@escaping ((T?)->()))
    
    /// Create a new event listener for multiple events, expecting information from the trigger
    /// - Parameters:
    ///     - eventNames: Matching trigger eventNames will cause this listener to fire
    ///     - action: The block of code you want executed when the event triggers
    mutating func on<T>(_ eventNames:[String], action:@escaping ((T?)->()))
    
    /// Triggers an event
    /// - Parameters:
    ///     - eventName: Matching listener eventNames will fire when this is called
    ///     - information: pass values to your listeners
    func emit(_ eventName:String, information:Any)
    
    /// Triggers an event
    /// - Parameters:
    ///     - eventName: Matching listener eventNames will fire when this is called
    func emit(_ eventName:String)
    
    /// Removes all listeners by default, or specific listeners through paramters
    /// - Parameters:
    ///     - eventName: If an event name is passed, only listeners for that event will be removed
    mutating func removeListeners(_ eventNameToRemoveOrNil:String?)
}

public extension EventEmitter {
    mutating func on(_ eventName:String, action:@escaping (()->())) {
        let newListener = EventListenerAction<Any>(action);
        addListener(eventName, newEventListener: newListener)
    }
    
    mutating func on(_ eventNames:[String], action:@escaping (()->())) {
        eventNames.forEach() { eventName in
            let newListener = EventListenerAction<Any>(action)
            addListener(eventName, newEventListener: newListener)
        }
    }
    
    mutating func on<T>(_ eventName:String, action:@escaping ((T?)->())) {
        let newListener = EventListenerAction(action);
        addListener(eventName, newEventListener: newListener)
    }
    
    mutating func on<T>(_ eventNames:[String], action:@escaping ((T?)->())) {
        eventNames.forEach() { eventName in
            let newListener = EventListenerAction(action)
            addListener(eventName, newEventListener: newListener)
        }
    }
    
    mutating func removeListeners(_ eventName: String? = nil) {
        if let event = eventName {
            self.listeners?[event]?.removeAll()
        }
        else {
            self.listeners?.removeAll(keepingCapacity: false);
        }
    }
    
    func emit(_ eventName: String) {
        if let actionObjects = self.listeners?[eventName] {
            actionObjects.forEach() {
                if let parameterizedAction = ($0 as? EventListenerAction<Any>) {
                    parameterizedAction.listenerAction(nil)
                }
            }
        }
    }
    
    func emit<T>(_ eventName:String, information:T) {
        if let actionObjects = self.listeners?[eventName] {
            actionObjects.forEach() {
                if let parameterizedAction = ($0 as? EventListenerAction<T>) {
                    parameterizedAction.listenerAction(information)
                }
                else if let unParameterizedAction = $0 as? EventListenerAction<Any> {
                    unParameterizedAction.listenerAction(information)
                }
                else {
                    print("could not call callback with \nname: \(eventName) \nand information: \(information)")
                }
            }
        }
    }
}

// MARK: - Utils
extension EventEmitter {
    mutating fileprivate func addListener<T>(_ eventName:String, newEventListener:EventListenerAction<T>) {
        if listeners == nil {
            listeners = [:]
        }
        if listeners?[eventName] == nil {
            listeners?[eventName] = [Any]()
        }
        listeners?[eventName]!.append(newEventListener)
    }
}
