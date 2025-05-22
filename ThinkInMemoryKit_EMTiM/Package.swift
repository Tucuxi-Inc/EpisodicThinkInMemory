// Swift Package: ThinkInMemoryKit
import PackageDescription

let package = Package(
    name: "ThinkInMemoryKit",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(name: "ThinkInMemoryKit", targets: ["ThinkInMemoryKit"])
    ],
    dependencies: [],
    targets: [
        .target(name: "ThinkInMemoryKit", dependencies: []),
        .testTarget(name: "ThinkInMemoryKitTests", dependencies: ["ThinkInMemoryKit"])
    ]
)
