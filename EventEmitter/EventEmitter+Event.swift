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
    
    mutating func on(event: Event, action:(()->())) {
        self.on(event.rawValue, action: action)
    }
    
    mutating func on(events: [Event], action:(()->())) {
        self.on(events.map() { $0.rawValue }, action: action)
    }
    
    mutating func once(event: Event, action:(()->())) {
        self.once(event.rawValue, action: action)
    }
    
    mutating func on<T>(event: Event, action:((T?)->())) {
        self.on(event.rawValue, action: action)
    }
    
    mutating func on<T>(events:[Event], action:((T?)->())) {
        self.on(events.map() { $0.rawValue }, action: action)
    }
    
    mutating func once<T>(event:Event, action:((T?)->())) {
        self.once(event.rawValue, action: action)
    }
    
    mutating func removeListeners(event: Event? = nil) {
        self.removeListeners(event?.rawValue)
    }
    
    func emit(event: Event) {
        self.emit(event.rawValue)
    }
    
    func emit<T>(event: Event, information:T) {
        self.emit(event.rawValue, information: information)
    }
}