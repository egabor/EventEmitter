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
    mutating func emit<T: Any>(onMain event: Event, information: T) {
        DispatchQueue.main.async { [weak self] in
            //FIXME: - make this call work !!!
//            self?.emit(event, information: information as T)
            guard var actionObjects = self?.listeners?[event.rawValue]  else {
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
            self?.listeners?[event.rawValue] = actionObjects
        }
    }
    
    /// Triggers an event on the main thread
    /// - Parameters:
    ///     - eventName: Matching listener eventNames will fire when this is called
    mutating func emit(onMain event: Event) {
        DispatchQueue.main.async { [weak self] in
            self?.emit(event)
        }
    }
}
