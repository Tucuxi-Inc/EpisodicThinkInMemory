import Foundation

public struct ThoughtExtractor {
    /// Extract inductive relational triples from an event
    public static func extract(from text: String) -> [Thought] {
        // TODO: call LLM to extract (entity, relation, entity)
        let sentences = text.split(separator: ".").map { String($0) }
        return sentences.map { sentence in
            Thought(content: sentence.trimmingCharacters(in: .whitespacesAndNewlines),
                    embedding: [], relevance: 1.0)
        }
    }
}
