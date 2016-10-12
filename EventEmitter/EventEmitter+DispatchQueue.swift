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
    func emit<T: Any>(onMain event: Event, information: T) {
        DispatchQueue.main.async {
            //FIXME: - make this call work !!!
//            self.emit(event, information: information as T)
            if let actionObjects = self.listeners?[event.rawValue] {
                actionObjects.forEach() {
                    if let parameterizedAction = ($0 as? EventListenerAction<T>) {
                        parameterizedAction.listenerAction(information)
                    }
                    else if let unParameterizedAction = $0 as? EventListenerAction<Any> {
                        unParameterizedAction.listenerAction(information)
                    }
                    else {
                        print("could not call callback on \(event) \nwith information \"\(information)\" which is a \(Mirror(reflecting: information).subjectType)")
                    }
                }
            }
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
