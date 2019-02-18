//: [Previous](@previous)

import Foundation

typealias UpdateHandler<T> = (T) -> ()

class ObserverToken {
  let unsubscribe: () -> ()

  init(unsubscribe: @escaping () -> ()) {
    self.unsubscribe = unsubscribe
  }

  deinit {
    unsubscribe()
  }
}

class UpdateHandlerWrapper<T> {
  let identity: String = UUID().uuidString
  let observer: UpdateHandler<T>

  init(wrapping wrapped: @escaping UpdateHandler<T>) {
    self.observer = wrapped
  }
}

final class ObservableEvent<T> {
  private var observers: [UpdateHandlerWrapper<T>] = [] // 2 List of registered observers
  func post(update: T) {
    for wrapper in observers { // 3 Notify all observers of the change
      wrapper.observer(update)
    }
  }


  func add(observer: @escaping UpdateHandler<T>) -> ObserverToken {
    let wrapper = UpdateHandlerWrapper(wrapping: observer)
    observers.append(wrapper)
    return ObserverToken(unsubscribe: {
      self.removeObserver(token: wrapper.identity)
    })
  }

  private func removeObserver(token: String) {
    observers.removeAll { $0.identity == token }
  }
}

final class Car {
  var speedUpdates: ObservableEvent<Float> = .init()
  var speed: Float = 0 {
    didSet {
      speedUpdates.post(update: speed)
    }
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
    self.observerToken = car.speedUpdates.add { [weak self] speed in
      self?.show(speed: speed)
    }
  }

  // REMOVE DEINIT FROM HERE
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
