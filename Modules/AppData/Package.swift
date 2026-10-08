// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "AppData",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [.library(name: "AppData", targets: ["AppData"])],
    dependencies: [.package(path: "../Domain"), .package(path: "../AppNetwork")],
    targets: [
        .target(name: "AppData", dependencies: ["Domain", "AppNetwork"]),
        .testTarget(name: "AppDataTests", dependencies: ["AppData", "AppNetwork", "Domain"])
    ]
)
