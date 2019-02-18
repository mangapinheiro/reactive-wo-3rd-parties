import Foundation

protocol CarObserver { // 1 Observable protocol declaration
  func car(_ car: Car, didUpdateSpeedTo speed: Float)
}

final class Car {
  private var observers: [CarObserver] = [] // 2 List of registered observers
  var speed: Float = 0 {
    didSet {
      for observer in observers { // 3 Notify all observers of the change
        observer.car(self, didUpdateSpeedTo: speed)
      }
    }
  }

  func add(observer: CarObserver) {
    observers.append(observer)
  }

  func accelerate(amount: Float) {
    speed += amount
  }
}

final class Speedometer: CarObserver {
  func car(_ car: Car, didUpdateSpeedTo speed: Float) {
    print("Current speed: \(speed)")
  }
}

let car = Car() // 4 Instantiate a car

let speedometer = Speedometer()

car.add(observer: speedometer) // 5 Register an observer

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
