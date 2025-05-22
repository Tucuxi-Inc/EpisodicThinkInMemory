import Foundation
import Combine

public final class EventMemoryManager: ObservableObject {
    @Published public private(set) var events: [Event] = []
    private var temporalGraph: [UUID: [UUID]] = [:]
    private var cancelBag = Set<AnyCancellable>()

    public init() {}

    public func insertEvent(_ event: Event) {
        events.append(event)
        if events.count > 1 {
            let prev = events[events.count - 2]
            temporalGraph[prev.id, default: []].append(event.id)
            temporalGraph[event.id, default: []].append(prev.id)
        }
    }

    public func retrieveNeighbors(of id: UUID, k: Int) -> [Event] {
        let neighbors = temporalGraph[id]?.prefix(k) ?? []
        return events.filter { neighbors.contains($0.id) }
    }

    public func incrementAccess(_ id: UUID) {
        if let idx = events.firstIndex(where: { $0.id == id }) {
            events[idx].accessCount += 1
        }
    }
}
