//
//  EventEmitter+DefaultImplementation.swift
//  EventEmitter
//
//  Created by Gujgiczer Máté on 2016. 10. 06..
//  Copyright © 2016. gujci. All rights reserved.
//

import Foundation

/// Model to store actions
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

// MARK: - Event
extension String: Event {
    /// value that identifyes the event
    public var rawValue: String { return self }
}

// MARK: - Default implementation
public extension EventEmitter {
    mutating func on(_ event:Event, action:@escaping (()->())) {
        let newListener = EventListenerAction<Any>(action);
        addListener(event.rawValue, newEventListener: newListener)
    }
    
    mutating func on(_ events:[Event], action:@escaping (()->())) {
        events.forEach() { event  in
            let newListener = EventListenerAction<Any>(action)
            addListener(event.rawValue, newEventListener: newListener)
        }
    }
    
    mutating func on<T>(_ event:Event, action:@escaping ((T?)->())) {
        let newListener = EventListenerAction(action);
        addListener(event.rawValue, newEventListener: newListener)
    }
    
    mutating func on<T>(_ events:[Event], action:@escaping ((T?)->())) {
        events.forEach() { event in
            let newListener = EventListenerAction(action)
            addListener(event.rawValue, newEventListener: newListener)
        }
    }
    
    mutating func removeListeners(_ event: Event? = nil) {
        if let event = event?.rawValue {
            self.listeners?[event]?.removeAll()
        }
        else {
            self.listeners?.removeAll(keepingCapacity: false);
        }
    }
    
    func emit(_ event: Event) {
        if let actionObjects = self.listeners?[event.rawValue] {
            actionObjects.forEach() {
                if let parameterizedAction = ($0 as? EventListenerAction<Any>) {
                    parameterizedAction.listenerAction(nil)
                }
            }
        }
    }
    
    func emit<T>(_ event:Event, information:T) {
        if let actionObjects = self.listeners?[event.rawValue] {
            actionObjects.forEach() {
                if let parameterizedAction = ($0 as? EventListenerAction<T>) {
                    parameterizedAction.listenerAction(information)
                }
                else if let unParameterizedAction = $0 as? EventListenerAction<Any> {
                    unParameterizedAction.listenerAction(information)
                }
                else {
                    print("could not call callback with \n: \(event) \nand information: \(information)")
                }
            }
        }
    }
}

// MARK: - Utils
extension EventEmitter {
    mutating fileprivate func addListener<T>(_ event:String, newEventListener:EventListenerAction<T>) {
        if listeners == nil {
            listeners = [:]
        }
        if listeners?[event] == nil {
            listeners?[event] = [Any]()
        }
        listeners?[event]!.append(newEventListener)
    }
}
