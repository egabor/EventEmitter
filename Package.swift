// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "EventEmitter",
    platforms: [
        .macOS(.v10_10), .iOS(.v8), .tvOS(.v9), .watchOS(.v3)
    ],
    products: [
        .library(name: "EventEmitter", targets: ["EventEmitter"])
    ],
    targets: [
        .target(name: "EventEmitter", path: "EventEmitter"),
        .testTarget(name: "EventEmitterTests", dependencies: ["EventEmitter"], path: "EventEmitterTests")
    ]
)
