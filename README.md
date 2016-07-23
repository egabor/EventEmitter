# EventEmitter
A lightweight tool to easily implement listener pattern.

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Example
========

Subscribe to events w parameters:
```swift
eventEmitterInstance.on("eventWithParameter") { (weak parameter: Any?) in
    //...
}
```
Or w/o parameters:
```swift
eventEmitterInstance.on("eventWithoutParameter") {
    //...
}
```
Emit an event with an EventEmitter class
```swift
class EventEmitterClass: EventEmitter {
  var listeners: Dictionary<String, Array<Any>>? = Dictionary<String, Array<Any>>()
  
  //...
  public func foo(parameter: Any?) {
    //...
    emit("eventWithParameter", information: parameter)
  }
  
  public func bar() {
    //...
    emit("eventWithoutParameter")
  }
}
```
Note: This is a protocoll so you can use it with `struct`s as well.

#Documentation
### Functions to be called from an EventEmitter instance
```swift
emit(eventName:String, information:Any)
```
```swift
emit(eventName:String)
```
### Functions to call on an EventEmitter instance
#### subscribe
```swift
on(eventName:String, action:(()->()))
```
```swift
on<T>(eventName:String, action:((T?)->()))
```
```swift
on(eventNames:[String], action:(()->()))
```
```swift
on<T>(eventNames:[String], action:((T?)->()))
```
```swift
once(eventName:String, action:(()->()))
```
```swift
once<T>(eventName:String, action:((T?)->()))
```
#### unsubscribe
```swift
removeListeners(eventNameToRemoveOrNil:String?)
```

#Installation
## Carthage 

Put this line into your cartfile
```
github "Gujci/EventEmitter"
```
