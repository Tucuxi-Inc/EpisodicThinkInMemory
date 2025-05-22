import Foundation

public protocol DecayFunction {
    var consolidationThreshold: Double { get }
    func decay(from current: Double, elapsed: TimeInterval, rate: Double) -> Double
}

public struct ExponentialDecay: DecayFunction {
    public let consolidationThreshold: Double
    public func decay(from current: Double, elapsed: TimeInterval, rate: Double) -> Double {
        current * exp(-rate * elapsed)
    }
}

public struct EbbinghausDecay: DecayFunction {
    public let consolidationThreshold: Double
    public func decay(from current: Double, elapsed: TimeInterval, rate: Double) -> Double {
        let t = elapsed / 60.0
        return current / (1 + rate * log(1 + t))
    }
}
