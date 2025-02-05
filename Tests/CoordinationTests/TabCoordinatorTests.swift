import XCTest

final class TabCoordinatorTests: XCTestCase {
    var sut: MockTabCoordinator!
    
    @MainActor
    override func setUp() {
        sut = MockTabCoordinator()
    }
    
    override func tearDown() {
        sut = nil
    }
}

extension TabCoordinatorTests {
    @MainActor
    func testCoordinatorStart() {
        sut.start()
        XCTAssertTrue(sut.coordinatorDidStart)
    }
    
    @MainActor
    func testAddingTab() {
        XCTAssertEqual(sut.childCoordinators.count, 0)
        XCTAssertNil(sut.root.viewControllers)

        let child = MockChildCoordinator()
        sut.addTab(child)
        
        XCTAssertEqual(sut.childCoordinators.count, 1)
        XCTAssertEqual(sut.root.viewControllers?.count, 1)
    }
}
