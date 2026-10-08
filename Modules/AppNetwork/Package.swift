// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "AppNetwork",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [.library(name: "AppNetwork", targets: ["AppNetwork"])],
    dependencies: [.package(path: "../Domain")],
    targets: [.target(name: "AppNetwork", dependencies: ["Domain"])]
)
