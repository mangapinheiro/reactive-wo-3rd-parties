//: [Previous](@previous)

import Foundation

typealias SpeedUpdateHandler = (Float) -> ()

typealias ObserverToken = String

class SpeedUpdateHandlerWrapper {
  let identity: ObserverToken = UUID().uuidString
  let observer: SpeedUpdateHandler

  init(wrapping wrapped: @escaping SpeedUpdateHandler) {
    self.observer = wrapped
  }
}

final class Car {
  private var observers: [SpeedUpdateHandlerWrapper] = [] // 2 List of registered observers
  var speed: Float = 0 {
    didSet {
      for wrapper in observers { // 3 Notify all observers of the change
        wrapper.observer(speed)
      }
    }
  }

  func add(observer: @escaping SpeedUpdateHandler) -> ObserverToken {
    let wrapper = SpeedUpdateHandlerWrapper(wrapping: observer)
    observers.append(wrapper)
    return wrapper.identity
  }

  func removeObserver(token: ObserverToken) {
    observers.removeAll { $0.identity == token }
  }

  func accelerate(amount: Float) {
    speed += amount
  }
}

let car = Car() // 4 Instantiate a car

car.add(observer: { speed in
  print("1) speed: \(speed)")
}) // 5 Register an observer

let token = car.add(observer: { speed in
  print("2) speed: \(speed)")
}) // 5 Register an observer

car.accelerate(amount: 10) // 6 call method that triggers updates
car.accelerate(amount: 20)

car.removeObserver(token: token)

car.accelerate(amount: 30)

/*
 // 7 console should log:
 1) speed: 10.0
 2) speed: 10.0
 1) speed: 30.0
 2) speed: 30.0
 1) speed: 60.0
 */

//: [Next](@next)
