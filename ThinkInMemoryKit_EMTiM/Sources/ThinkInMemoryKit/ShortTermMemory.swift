import Foundation

public class ShortTermMemory {
    private var buffer: [String] = []
    private let capacity: Int

    public init(capacity: Int = 20) {
        self.capacity = capacity
    }

    public func remember(_ text: String) {
        buffer.append(text)
        if buffer.count > capacity { buffer.removeFirst() }
    }

    public func recentContext(topK: Int) -> [String] {
        return Array(buffer.suffix(topK))
    }
}
