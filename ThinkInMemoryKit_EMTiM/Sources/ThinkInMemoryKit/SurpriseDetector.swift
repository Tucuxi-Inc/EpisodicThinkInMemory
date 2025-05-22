import Foundation

public struct SurpriseDetector {
    /// Identify indices where surprise exceeds dynamic threshold
    public static func detectBoundaries(
        logProbs: [Double],
        window: Int = 20,
        gamma: Double = 1.0
    ) -> [Int] {
        guard logProbs.count > window else { return [] }
        var surprises: [Double] = []
        for t in 0..<logProbs.count {
            let p = logProbs[t]
            let surprise = -p
            surprises.append(surprise)
        }
        var boundaries: [Int] = []
        for t in window..<surprises.count {
            let slice = surprises[(t-window)..<t]
            let μ = slice.reduce(0, +) / Double(window)
            let σ = sqrt(slice.map { pow($0-μ, 2) }.reduce(0, +) / Double(window))
            let threshold = μ + gamma * σ
            if surprises[t] > threshold {
                boundaries.append(t)
            }
        }
        return boundaries
    }
}
