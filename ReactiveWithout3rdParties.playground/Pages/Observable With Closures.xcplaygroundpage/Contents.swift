//: [Previous](@previous)

import Foundation

typealias SpeedUpdateHandler = (Float) -> ()

final class Car {
  private var observers: [SpeedUpdateHandler] = [] // 2 List of registered observers
  var speed: Float = 0 {
    didSet {
      for observer in observers { // 3 Notify all observers of the change
        observer(speed)
      }
    }
  }

  func add(observer: @escaping SpeedUpdateHandler) {
    observers.append(observer)
  }

  func accelerate(amount: Float) {
    speed += amount
  }
}

let car = Car() // 4 Instantiate a car

car.add(observer: { speed in
  print("Current speed: \(speed)")
}) // 5 Register an observer

car.accelerate(amount: 10) // 6 call method that triggers updates
car.accelerate(amount: 20)
car.accelerate(amount: 30)

/*
 // 7 console should log:
 Current speed: 10.0
 Current speed: 30.0
 Current speed: 60.0
 */

//: [Next](@next)
