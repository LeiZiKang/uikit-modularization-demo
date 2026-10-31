import Foundation
enum ProductScene: String {
    case inStock, soldOut, outOfStock, restocking, apiError
}
struct ProductFixture: ProductLoading {
    let scene: ProductScene
    func load() throws -> Product {
        switch scene {
        case .inStock, .apiError: return Product(stock: .inStock)
        case .soldOut: return Product(stock: .soldOut)
        case .outOfStock: return Product(stock: .outOfStock)
        case .restocking: return Product(stock: .restocking(expected: "November 15"))
        }
    }
    func buy() throws {
        if scene == .apiError { throw Failure.unavailable }
    }
    private enum Failure: LocalizedError {
        case unavailable
        var errorDescription: String? { "Something went wrong. Please try again." }
    }
}
