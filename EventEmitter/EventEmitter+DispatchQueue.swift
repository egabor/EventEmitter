//
//  EventEmitter+DispatchQueue.swift
//  EventEmitter
//
//  Created by Gujgiczer Máté on 2016. 10. 05..
//  Copyright © 2016. gujci. All rights reserved.
//

import Foundation

public extension EventEmitter {
    
    /// Triggers an event in the main thread
    /// - Parameters:
    ///     - eventName: Matching listener eventNames will fire when this is called
    ///     - information: pass values to your listeners
    func emit(onMain event: Event, information: Any) {
        DispatchQueue.main.async {
            self.emit(event, information: information)
        }
    }
    
    /// Triggers an event on the main thread
    /// - Parameters:
    ///     - eventName: Matching listener eventNames will fire when this is called
    func emit(onMain event: Event) {
        DispatchQueue.main.async {
            self.emit(event)
        }
    }
}
