import Foundation

public struct MemoryContext {
    public let knowledge: [String]
    public let shortTerm: [String]
    public let longTerm: [Thought]
}

public class MemoryContextProvider {
    private let knowledgeBank: KnowledgeBank
    private let shortTermMemory: ShortTermMemory
    private let longTermMemory: TiMMemoryManager
    private let embeddingFn: (String) -> [Float]

    public init(
        knowledgeBank: KnowledgeBank,
        shortTermMemory: ShortTermMemory,
        longTermMemory: TiMMemoryManager,
        embedder: @escaping (String) -> [Float]
    ) {
        self.knowledgeBank = knowledgeBank
        self.shortTermMemory = shortTermMemory
        self.longTermMemory = longTermMemory
        self.embeddingFn = embedder
    }

    public func context(for query: String,
                        ragK: Int = 5,
                        stmK: Int = 5,
                        ltmK: Int = 5,
                        boostFactor: Double = 1.0) -> MemoryContext {
        let knowledge = knowledgeBank.retrieve(query: query, topK: ragK)
        let shortTerm = shortTermMemory.recentContext(topK: stmK)
        let embed = embeddingFn(query)
        let longTerm = longTermMemory.recall(
            queryEmbedding: embed,
            topK: ltmK,
            boostFactor: boostFactor
        )
        return MemoryContext(knowledge: Array(knowledge),
                             shortTerm: shortTerm,
                             longTerm: longTerm)
    }
}
