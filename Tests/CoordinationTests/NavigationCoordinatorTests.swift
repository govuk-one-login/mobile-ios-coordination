import XCTest

@MainActor
final class NavigationCoordinatorTests: XCTestCase {

    var sut = MockNavigationCoordinator()
}

extension NavigationCoordinatorTests {
    @MainActor
    func testCoordinatorStart() {
        sut.start()
        XCTAssertTrue(sut.coordinatorDidStart)
    }
    
    @MainActor
    func testOpenChildInline() {
        XCTAssertEqual(sut.childCoordinators.count, 0)
        let childCoordinator = MockChildCoordinator(root: sut.root)
        sut.openChildInline(childCoordinator)
        XCTAssertTrue(sut.root.delegate === childCoordinator)
        XCTAssertEqual(sut.childCoordinators.count, 1)
        XCTAssertTrue(childCoordinator.parentCoordinator === sut)
        XCTAssertTrue(childCoordinator.coordinatorDidStart)
    }
    
    @MainActor
    func testChildDidFinish() {
        let childCoordinator = MockChildCoordinator(root: sut.root)
        sut.openChildInline(childCoordinator)
        childCoordinator.finish()
        XCTAssertEqual(sut.childCoordinators.count, 0)
        XCTAssertTrue(sut.root.delegate === sut)
    }
}
