//
//  EventEmitter+DispatchQueue.swift
//  EventEmitter
//
//  Created by Gujgiczer Máté on 2016. 10. 05..
//  Copyright © 2016. gujci. All rights reserved.
//

import Foundation

public extension EventEmitter where Self: AnyObject {
    
    /// Triggers an event in the main thread
    /// - Parameters:
    ///     - eventName: Matching listener eventNames will fire when this is called
    ///     - information: pass values to your listeners
    func emit<T: Any>(onMain event: Event, information: T) {
        DispatchQueue.main.async { [weak self] in
            self?._emit(event, information: information)
        }
    }
    
    /// Triggers an event on the main thread
    /// - Parameters:
    ///     - eventName: Matching listener eventNames will fire when this is called
    func emit(onMain event: Event) {
        DispatchQueue.main.async { [weak self] in
            self?._emit(event)
        }
    }
}
