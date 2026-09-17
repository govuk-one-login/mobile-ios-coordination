import XCTest

@MainActor
final class ParentCoordinatorTests: XCTestCase {

    var sut = MockParentCoordinator()
}

extension ParentCoordinatorTests {
    @MainActor
    func testCoordinatorStart() {
        sut.start()
        XCTAssertTrue(sut.coordinatorDidStart)
    }
    
    @MainActor
    func testOpenChildModally() {
        XCTAssertEqual(sut.childCoordinators.count, 0)
        let childCoordinator = MockChildCoordinator()
        sut.openChildModally(childCoordinator)
        XCTAssertEqual(sut.childCoordinators.count, 1)
        XCTAssertTrue(childCoordinator.parentCoordinator === sut)
        XCTAssertTrue(childCoordinator.coordinatorDidStart)
    }
    
    @MainActor
    func testChildDidFinish() {
        let childCoordinator = MockChildCoordinator()
        sut.openChildModally(childCoordinator)
        childCoordinator.finish()
        XCTAssertEqual(sut.childCoordinators.count, 0)
    }
}
