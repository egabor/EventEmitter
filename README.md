# EventEmitter
A lightweight tool to easily implement listener pattern.

Example
========

Subscribe to events w parameters:

    appSessionHadler.on("login") { (token: String?) in
      //handle login with the token...
    }

Or w/o parameters:

    appSessionHadler.on("logout") {
      //handle logout...
    }

Emit an event with an EventEmitter class

    class SessionHandler: EventEmitter {
      var listeners = Dictionary<String, Array<Any>>?()
      
      //...
      public func logIn(withToken token: String?) {
        //...
        emit("login", information: token)
      }
      
      public func logOut() {
        //...
        emit("logout")
      }
    }

Installation
========
Requires Swift 2/Xcode 7

For now you have to copy the `EventEmitter.swift` file to your project. 
