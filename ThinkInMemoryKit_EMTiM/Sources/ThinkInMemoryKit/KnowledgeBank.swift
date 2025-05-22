import Foundation

public protocol KnowledgeBank {
    func retrieve(query: String, topK: Int) -> [String]
}

public class InMemoryKnowledgeBank: KnowledgeBank {
    private var documents: [String]
    public init(docs: [String]) { self.documents = docs }
    public func retrieve(query: String, topK: Int) -> [String] {
        return documents.filter { $0.contains(query) }.prefix(topK).map { $0 }
    }
}
