// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWSimpleAI_Claude",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "WWSimpleAI_Claude", targets: ["WWSimpleAI_Claude"]),
    ],
    dependencies: [
        .package(url: "https://github.com/William-Weng/WWSimpleAI_Ollama", from: "1.1.6")
    ],
    targets: [
        .target(name: "WWSimpleAI_Claude", dependencies: ["WWSimpleAI_Ollama"]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
