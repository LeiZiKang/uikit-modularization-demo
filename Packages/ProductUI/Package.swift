// swift-tools-version: 5.9
import PackageDescription
let package = Package(
    name: "ProductUI",
    platforms: [.iOS(.v17)],
    products: [.library(name: "ProductUI", targets: ["ProductUI"])],
    targets: [.target(name: "ProductUI")],
    swiftLanguageVersions: [.v5]
)
