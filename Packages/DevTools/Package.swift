// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DevTools",
    platforms: [.iOS(.v17)],
    products: [.library(name: "DevTools", targets: ["DevTools"])],
    targets: [.target(name: "DevTools")]
)
