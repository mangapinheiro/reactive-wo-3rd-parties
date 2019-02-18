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

// MARK - Usage

class Speedometer {
  func show(speed: Float) {
    print("New speed \(speed)")
  }

  var car: Car
  var observerToken: ObserverToken!

  init(car: Car) {
    self.car = car
    self.observerToken = car.add { [weak self] speed in
      self?.show(speed: speed)
    }
  }

  deinit {
    car.removeObserver(token: observerToken)
  }
}

let car = Car() // 4 Instantiate a car

var speedometer: Speedometer? = Speedometer(car: car)

car.accelerate(amount: 10) // 6 call method that triggers updates
car.accelerate(amount: 20)
speedometer = nil // 7 dealloc speedometer remove observer
car.accelerate(amount: 30) // 8 new updates do NOT get printed

/*
 // CONSOLE OUTPUT:
 New speed 10.0
 New speed 30.0
 */


//: [Next](@next)
