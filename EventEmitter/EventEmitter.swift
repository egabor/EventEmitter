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
    
    init(callback:((T?) -> ())) {
        listenerAction = callback;
    }
    
    init(callback:(() -> ())) {
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
    mutating func on(eventName:String, action:(()->()))
    
    /// Create a new event listener for multiple events, not expecting information from the trigger
    /// - Parameters:
    ///     - eventNames: Matching trigger eventNames will cause this listener to fire
    ///     - action: The block of code you want executed when the event triggers
    mutating func on(eventNames:[String], action:(()->()))
    
    /// Create a new event listener, not expecting information from the trigger, unsuscribes from the event after first trigger
    /// - Parameters:
    ///     - eventName: Matching trigger eventNames will cause this listener to fire
    ///     - action: The block of code you want executed when the event triggers
    mutating func once(eventName:String, action:(()->()))
    
    /// Create a new event listener, expecting information from the trigger
    /// - Parameters:
    ///     - eventName: Matching trigger eventNames will cause this listener to fire
    ///     - action: The block of code you want executed when the event triggers
    mutating func on<T>(eventName:String, action:((T?)->()))
    
    /// Create a new event listener for multiple events, expecting information from the trigger
    /// - Parameters:
    ///     - eventNames: Matching trigger eventNames will cause this listener to fire
    ///     - action: The block of code you want executed when the event triggers
    mutating func on<T>(eventNames:[String], action:((T?)->()))
    
    /// Create a new event listener, expecting information from the trigger, unsuscribes from the event after first trigger
    /// - Parameters:
    ///     - eventName: Matching trigger eventNames will cause this listener to fire
    ///     - action: The block of code you want executed when the event triggers
    mutating func once<T>(eventName:String, action:((T?)->()))
    
    /// Triggers an event
    /// - Parameters:
    ///     - eventName: Matching listener eventNames will fire when this is called
    ///     - information: pass values to your listeners
    func emit(eventName:String, information:Any)
    
    /// Triggers an event
    /// - Parameters:
    ///     - eventName: Matching listener eventNames will fire when this is called
    func emit(eventName:String)
    
    /// Removes all listeners by default, or specific listeners through paramters
    /// - Parameters:
    ///     - eventName: If an event name is passed, only listeners for that event will be removed
    mutating func removeListeners(eventNameToRemoveOrNil:String?)
}

public extension EventEmitter {
    mutating func on(eventName:String, action:(()->())) {
        let newListener = EventListenerAction<Any>(callback: action);
        addListener(eventName, newEventListener: newListener)
    }
    
    mutating func on(eventNames:[String], action:(()->())) {
        eventNames.forEach() { eventName in
            let newListener = EventListenerAction<Any>(callback: action)
            addListener(eventName, newEventListener: newListener)
        }
    }
    
    mutating func once(eventName:String, action:(()->())) {
        let unsuscribeAction: () -> () = {
            action()
            self.removeListeners(eventName)
        }
        let newListener = EventListenerAction<Any>(callback: unsuscribeAction);
        addListener(eventName, newEventListener: newListener)
    }
    
    mutating func on<T>(eventName:String, action:((T?)->())) {
        let newListener = EventListenerAction(callback: action);
        addListener(eventName, newEventListener: newListener)
    }
    
    mutating func on<T>(eventNames:[String], action:((T?)->())) {
        eventNames.forEach() { eventName in
            let newListener = EventListenerAction(callback: action)
            addListener(eventName, newEventListener: newListener)
        }
    }
    
    mutating func once<T>(eventName:String, action:((T?)->())) {
        let unsuscribeAction: (T?) -> () = { param in
            action(param)
            self.removeListeners(eventName)
        }
        let newListener = EventListenerAction(callback: unsuscribeAction);
        addListener(eventName, newEventListener: newListener)
    }
    
    mutating func removeListeners(eventName: String? = nil) {
        if let event = eventName {
            self.listeners?[event]?.removeAll()
        }
        else {
            self.listeners?.removeAll(keepCapacity: false);
        }
    }
    
    func emit(eventName: String) {
        if let actionObjects = self.listeners?[eventName] {
            actionObjects.forEach() {
                if let parameterizedAction = ($0 as? EventListenerAction<Any>) {
                    parameterizedAction.listenerAction(nil)
                }
            }
        }
    }
    
    func emit<T>(eventName:String, information:T) {
        if let actionObjects = self.listeners?[eventName] {
            actionObjects.forEach() {
                if let parameterizedAction = ($0 as? EventListenerAction<T>) {
                    parameterizedAction.listenerAction(information)
                }
                else if let unParameterizedAction = $0 as? EventListenerAction<Any> {
                    unParameterizedAction.listenerAction(information)
                }
                else {
                    print("could not call callback")
                }
            }
        }
    }
}

// MARK: - Utils
extension EventEmitter {
    mutating private func addListener<T>(eventName:String, newEventListener:EventListenerAction<T>) {
        if listeners == nil {
            listeners = Dictionary<String, Array<Any>>?()
        }
        if listeners?[eventName] == nil {
            listeners?[eventName] = [Any]()
        }
        listeners?[eventName]!.append(newEventListener)
    }
}
