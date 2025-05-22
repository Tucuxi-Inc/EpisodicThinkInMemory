import Foundation
import Combine

public final class TiMMemoryManager: ObservableObject {
    @Published public private(set) var allThoughts: [Thought] = []
    private let index: LSHIndex
    private var timerCancellable: AnyCancellable?
    private let decayInterval: TimeInterval
    private let minRelevance: Double

    public init(
        embeddingDim: Int,
        buckets: Int = 64,
        decayInterval: TimeInterval = 60,
        minRelevance: Double = 0.1
    ) {
        self.index = LSHIndex(dim: embeddingDim, buckets: buckets)
        self.decayInterval = decayInterval
        self.minRelevance = minRelevance

        timerCancellable = Timer.publish(every: decayInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] now in
                self?.applyDecay(now: now)
            }
    }

    public func insertThought(_ thought: Thought) {
        allThoughts.append(thought)
    }

    public func recall(
        queryEmbedding: [Float],
        topK: Int = 5,
        boostFactor: Double = 1.0
    ) -> [Thought] {
        let similarities = allThoughts.map { (thought: Thought) -> (Thought, Double) in
            let sim = cosine(queryEmbedding, thought.embedding)
            return (thought, sim)
        }
        let top = similarities.sorted { $0.1 > $1.1 }.prefix(topK)

        var updated = allThoughts
        for i in 0..<updated.count {
            if top.contains(where: { $0.0.id == updated[i].id }) {
                updated[i].boostRelevance(by: boostFactor)
                updated[i].accessed()
            }
        }
        allThoughts = updated
        return top.map { $0.0 }
    }

    private func applyDecay(now: Date) {
        var updated = allThoughts
        for i in 0..<updated.count {
            updated[i].applyDecay(until: now)
        }
        allThoughts = updated.filter { $0.relevance > minRelevance }
    }

    private func cosine(_ a: [Float], _ b: [Float]) -> Double {
        let dot = zip(a, b).map(*).reduce(0, +)
        let na = sqrt(a.map { $0*$0 }.reduce(0, +))
        let nb = sqrt(b.map { $0*$0 }.reduce(0, +))
        return Double(dot) / (Double(na * nb) + 1e-8)
    }
}
