import Foundation

/// Represents a segmented event in episodic memory
public struct Event: Identifiable {
    public let id: UUID = UUID()
    public let content: String              // Raw text tokens
    public var thoughts: [Thought]          // Extracted inductive thoughts
    public let timestamp: Date              // Creation time
    public var accessCount: Int = 0         // Number of retrievals
    public var neighbors: [UUID] = []       // Temporal connections
}
