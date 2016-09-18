//
//  EventEmitter+Event.swift
//  EventEmitter
//
//  Created by Gujgiczer Máté on 03/08/16.
//  Copyright © 2016 gujci. All rights reserved.
//

import Foundation

public protocol Event {
    var rawValue: String {get}
}

public extension EventEmitter {
    
    mutating func on(_ event: Event, action:@escaping (()->())) {
        self.on(event.rawValue, action: action)
    }
    
    mutating func on(_ events: [Event], action:@escaping (()->())) {
        self.on(events.map() { $0.rawValue }, action: action)
    }
    
    mutating func on<T>(_ event: Event, action:@escaping ((T?)->())) {
        self.on(event.rawValue, action: action)
    }
    
    mutating func on<T>(_ events:[Event], action:@escaping ((T?)->())) {
        self.on(events.map() { $0.rawValue }, action: action)
    }
    
    mutating func removeListeners(_ event: Event? = nil) {
        self.removeListeners(event?.rawValue)
    }
    
    func emit(_ event: Event) {
        self.emit(event.rawValue as! Event)
    }
    
    func emit<T>(_ event: Event, information: T) {
        //FIXME
        if let actionObjects = self.listeners?[event.rawValue] {
            actionObjects.forEach() {
                if let parameterizedAction = ($0 as? EventListenerAction<T>) {
                    parameterizedAction.listenerAction(information)
                }
                else if let unParameterizedAction = $0 as? EventListenerAction<Any> {
                    unParameterizedAction.listenerAction(information)
                }
                else {
                    print("could not call callback with \nname: \(event.rawValue) \nand information: \(information)")
                }
            }
        }
//        self.emit(event.rawValue, information: information)
    }
}
