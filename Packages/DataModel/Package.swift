// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DataModel",
    platforms: [.iOS(.v17)],
    products: [.library(name: "DataModel", targets: ["DataModel"])],
    targets: [.target(name: "DataModel")]
)
