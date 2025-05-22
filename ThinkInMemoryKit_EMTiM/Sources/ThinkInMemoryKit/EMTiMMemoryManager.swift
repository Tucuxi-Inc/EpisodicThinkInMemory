import Foundation
import Combine

/// Combined Episodic-TiM memory manager
public final class EMTiMMemoryManager: ObservableObject {
    @Published public private(set) var events: [Event] = []
    private let lsh = LSHIndex(dim: 768)
    private let decayMgr = TiMMemoryManager(embeddingDim: 768)
    private var cancelBag = Set<AnyCancellable>()

    public init() {}

    public func processInput(_ text: String,
                              logProbs: [Double],
                              tokens: [String]) {
        let rawBounds = SurpriseDetector.detectBoundaries(logProbs: logProbs)
        let bounds = BoundaryRefiner.refine(tokens: tokens, boundaries: rawBounds)
        var start = 0
        for end in bounds + [tokens.count] {
            let segment = tokens[start..<end].joined(separator: " ")
            let thoughts = ThoughtExtractor.extract(from: segment)
            var ev = Event(content: segment, thoughts: thoughts, timestamp: Date())
            insert(event: &ev)
            start = end
        }
    }

    private func insert(event: inout Event) {
        events.append(event)
        for var th in event.thoughts {
            decayMgr.insertThought(th)
        }
    }

    public func retrieveContext(for query: String,
                                embedding: [Float],
                                kThoughts: Int = 5,
                                kEvents: Int = 3,
                                kContig: Int = 2) -> (thoughts: [Thought], events: [Event]) {
        let topThoughts = decayMgr.recall(queryEmbedding: embedding, topK: kThoughts)
        let evIds = Set(topThoughts.compactMap { th in
            events.first(where: { $0.thoughts.contains(where: { $0.id == th.id }) })?.id
        })
        var relevant = events.filter { evIds.contains($0.id) }
        for ev in relevant {
            let neighbors = getContiguous(eventId: ev.id, k: kContig)
            relevant.append(contentsOf: neighbors)
        }
        let unique = Array(Set(relevant))
        return (topThoughts, unique)
    }

    private func getContiguous(eventId: UUID, k: Int) -> [Event] {
        let neighborIds = (events.first { $0.id == eventId }?.neighbors ?? []).prefix(k)
        return events.filter { neighborIds.contains($0.id) }
    }
}
