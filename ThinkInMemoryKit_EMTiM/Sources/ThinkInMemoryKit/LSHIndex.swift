import Foundation

public class LSHIndex {
    let buckets: Int, dim: Int
    let projections: [[Float]]

    public init(dim: Int, buckets: Int = 64) {
        self.dim = dim; self.buckets = buckets
        self.projections = (0..<buckets).map { _ in
            (0..<dim).map { _ in Float.random(in: -1...1) }
        }
    }

    public func hash(_ v: [Float]) -> Int {
        let scores = projections.map { proj in zip(v, proj).map(*).reduce(0, +) }
        return scores.enumerated().max(by: { $0.element < $1.element })!.offset
    }
}
