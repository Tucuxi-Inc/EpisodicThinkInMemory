import Foundation

public struct Thought: Identifiable {
    public let id: UUID = UUID()
    public let content: String
    public let embedding: [Float]
    public private(set) var relevance: Double
    public private(set) var consolidated: Bool
    public let createdAt: Date
    public private(set) var lastAccessed: Date
    public let baseDecayRate: Double
    public var decayFunction: DecayFunction

    public init(
        content: String,
        embedding: [Float],
        relevance: Double = 1.0,
        baseDecayRate: Double = 0.05,
        decayFunction: DecayFunction = ExponentialDecay(consolidationThreshold: 5.0)
    ) {
        self.content = content
        self.embedding = embedding
        self.relevance = relevance
        self.baseDecayRate = baseDecayRate
        self.decayFunction = decayFunction
        self.createdAt = Date()
        self.lastAccessed = Date()
        self.consolidated = false
    }

    public mutating func boostRelevance(by amount: Double) {
        relevance += amount
        if relevance >= decayFunction.consolidationThreshold {
            consolidated = true
        }
    }

    public mutating func accessed() {
        lastAccessed = Date()
    }

    public mutating func applyDecay(until now: Date) {
        guard !consolidated else { return }
        let elapsed = now.timeIntervalSince(lastAccessed)
        relevance = decayFunction.decay(from: relevance, elapsed: elapsed, rate: baseDecayRate)
    }
}
