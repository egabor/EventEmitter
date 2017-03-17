//
//  EventEmitter+DefaultImplementation.swift
//  EventEmitter
//
//  Created by Gujgiczer Máté on 2016. 10. 06..
//  Copyright © 2016. gujci. All rights reserved.
//

import Foundation

internal struct EventListenerAction <T> {
    var listenerAction : ((T?) -> ())
    var oneTime: Bool = false
    
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
        let newListener = EventListenerAction<Any>(action)
        addListener(event.rawValue, newEventListener: newListener)
    }
    
    mutating func on(_ events:[Event], action:@escaping (()->())) {
        events.forEach() { event  in
            let newListener = EventListenerAction<Any>(action)
            addListener(event.rawValue, newEventListener: newListener)
        }
    }
    
    mutating func on<T>(_ event:Event, action:@escaping ((T?)->())) {
        let newListener = EventListenerAction(action)
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
    
    mutating func emit(_ event: Event) {
        _emit(event)
    }
    
    mutating func emit<T: Any>(_ event:Event, information:T) {
        _emit(event, information: information)
    }
}

// MARK: - Non mutating functions (for reference types)
public extension EventEmitter where Self: AnyObject {
    
    /// Unmutable emit
    ///
    /// - Parameter event: event to emit
    func emit(_ event: Event) {
        var referenceCopy = self
        referenceCopy._emit(event)
    }
    
    /// Unmutable emit
    ///
    /// - Parameters:
    ///   - event: event to emit
    ///   - information: generic information
    func emit<T: Any>(_ event:Event, information:T) {
        var referenceCopy = self
        referenceCopy._emit(event, information: information)
    }
}

// MARK: - Utils
internal extension EventEmitter {
    
    mutating func addListener<T>(_ event:String, newEventListener:EventListenerAction<T>) {
        if listeners == nil {
            listeners = [:]
        }
        if listeners?[event] == nil {
            listeners?[event] = [Any]()
        }
        listeners?[event]!.append(newEventListener)
    }
    
    mutating func _emit(_ event: Event) {
        guard var actionObjects = listeners?[event.rawValue]  else {
            print("no acctions for event \(event.rawValue)")
            return
        }
        for (index, action) in actionObjects.enumerated() {
            guard let parameterizedAction = (action as? EventListenerAction<Any>) else { continue }
            parameterizedAction.listenerAction(nil)
            if parameterizedAction.oneTime {
                actionObjects.remove(at: index)
            }
        }
        listeners?[event.rawValue] = actionObjects
    }
    
    mutating func _emit<T: Any>(_ event:Event, information:T) {
        guard var actionObjects = listeners?[event.rawValue]  else {
            print("no acctions for event \(event.rawValue)")
            return
        }
        for (index, action) in actionObjects.enumerated() {
            if let parameterizedAction = (action as? EventListenerAction<T>) {
                parameterizedAction.listenerAction(information)
                if parameterizedAction.oneTime {
                    actionObjects.remove(at: index)
                }
            }
            else if let unParameterizedAction = action as? EventListenerAction<Any> {
                unParameterizedAction.listenerAction(information)
                if unParameterizedAction.oneTime {
                    actionObjects.remove(at: index)
                }
            }
            else {
                print("could not call callback on \(event) \nwith information \"\(information)\" which is a \(Mirror(reflecting: information).subjectType)")
            }
        }
        listeners?[event.rawValue] = actionObjects
    }
}
