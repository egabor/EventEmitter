# EventEmitter
A lightweight tool to easily implement listener pattern.

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
  var listeners = Dictionary<String, Array<Any>>?()
  
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

Installation
========
Requires Swift 2/Xcode 7

For now you have to copy the `EventEmitter.swift` file to your project. 
