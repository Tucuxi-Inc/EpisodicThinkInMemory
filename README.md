ThinkInMemoryKit
EM-TiM Memory System
A unified Swift package combining Episodic Memory (EM-LLM) and Think‑in‑Memory (TiM) for robust long-context understanding on iOS and macOS.

Features
Event Segmentation: Surprise-based boundary detection (Bayesian surprise), with optional graph-theoretic refinement.
Thought Extraction: Relational triple extraction per event via LLM.
Episodic Store: Event objects linked temporally, storing raw text tokens and extracted thoughts.
Long-Term Memory (TiM):
Thought objects with embeddings, relevance decay, and consolidation.
Pluggable decay strategies: Exponential and Ebbinghaus power-law.
LSHIndex for efficient approximate-nearest-neighbor lookups.
Short-Term Memory: Rolling window context buffer.
Knowledge Bank: RAG-style document retrieval (protocol + in-memory stub).
Context Provider: Assemble RAG, STM, and LTM into a single context payload.
Post-Thinking Module: Prevent repeated reasoning by updating memory after each response.
Installation
Add to your Package.swift:

dependencies: [
    .package(url: "https://github.com/your-org/ThinkInMemoryKit.git", from: "1.0.0")
]
Then add the dependency to your target:

.target(
    name: "YourApp",
    dependencies: ["ThinkInMemoryKit"]
)
Usage
import ThinkInMemoryKit

// 1. Initialize components
let emmgr = EMTiMMemoryManager()
let stm = ShortTermMemory(capacity: 50)
let kb  = InMemoryKnowledgeBank(docs: ["Doc1...", "Doc2..."])

// 2. Process incoming text (provide token log-probs & tokens from your LLM)
emmgr.processInput(text, logProbs: tokenLogProbs, tokens: tokenList)

// 3. On user query, call retrieveContext
let ctx = emmgr.retrieveContext(for: userQuery, embedding: embed(userQuery),
                                 kThoughts: 5, kEvents: 3, kContig: 2)

// 4. Feed ctx.thoughts and ctx.events into your LLM prompt builder
Modules
SurpriseDetector: detectBoundaries(logProbs:window:gamma:)
BoundaryRefiner: refine(tokens:boundaries:) (TODO: implement graph-based refinement)
ThoughtExtractor: extract(from:) (TODO: integrate LLM call for triple extraction)
EventMemoryManager: Manage Event lifecycle and temporal graph
EMTiMMemoryManager: Combined EM + TiM operations, process input, retrieve context
TiMMemoryManager: LTM logic, think-in-memory with decay and consolidation
LSHIndex: Bucketing for fast similarity lookup
ShortTermMemory: Rolling buffer for recent interactions
KnowledgeBank: RAG retrieval protocol + in-memory example
PostThinkingManager: Post-response memory update (TODO: integrate LLM-driven forget/merge)
TODOs
Boundary Refinement: Implement graph modularity/conductance on token-attention graph.
Thought Extraction: Replace stub with real LLM extraction of (entity, relation, entity) triples.
Post-Thinking: Integrate LLM-based contradiction filtering (forget_contradictory) and merging (merge_similar).
Persistence Layer: Add disk-based storage or vector DB support (e.g. Pinecone, FAISS).
Customization: Expose parameters (window size, decay rates, thresholds) via init arguments.
Contributing
Clone the repo.
Open in Xcode or SwiftPM.
Implement or stub new features.
Add tests under Tests/ThinkInMemoryKitTests.
Submit PR.
License
MIT © 2025 Tucuxi, Inc.
