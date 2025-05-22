import Foundation

public struct PostThinkingManager {
    /// After response, extract and merge new thoughts
    public static func process(response: String,
                               query: String,
                               mem: EMTiMMemoryManager) {
        let newThoughts = ThoughtExtractor.extract(from: response)
        // TODO: call LLM to filter contradictory and merge similar
        let newEvent = Event(content: "Q: \(query) A: \(response)", thoughts: newThoughts, timestamp: Date())
        mem.insert(event: &newEvent)
    }
}
