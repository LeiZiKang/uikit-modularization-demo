import XCTest
import UIKit
@testable import ModularDemo

@MainActor
final class ItemStateTests: XCTestCase {
    func testSuccess() async { await assertScene(.success, text: "Item · 12.99 · Available") }
    func testEmpty() async { await assertScene(.empty, text: "No items") }
    func testLoading() async { await assertScene(.loading, text: "Loading…") }
    func testUnauthorized() async { await assertScene(.unauthorized, text: "Please sign in") }
    func testServerError() async { await assertScene(.serverError, text: "Server error") }

    private func assertScene(
        _ scene: PreviewScene, text: String,
        file: StaticString = #filePath, line: UInt = #line
    ) async {
        let controller = ItemViewController(api: FixtureItemAPI(scene: scene))
        controller.loadViewIfNeeded()
        defer { controller.cancelLoading() }
        // Read the actual UILabel in the view tree, not a separate state model.
        let deadline = ContinuousClock.now.advanced(by: .seconds(3))
        while !labels(in: controller.view).contains(where: { $0.text == text }),
              ContinuousClock.now < deadline {
            await Task.yield()
        }
        XCTAssertEqual(labels(in: controller.view).map(\.text), [text], file: file, line: line)
        XCTAssertTrue(controller.view.subviews.contains { $0.accessibilityLabel == text },
                      file: file, line: line)
    }

    private func labels(in view: UIView) -> [UILabel] {
        (view as? UILabel).map { [$0] } ?? view.subviews.flatMap { labels(in: $0) }
    }
}
