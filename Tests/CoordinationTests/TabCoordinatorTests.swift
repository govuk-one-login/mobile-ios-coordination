import XCTest

@MainActor
final class TabCoordinatorTests: XCTestCase {
    var sut = MockTabCoordinator()
}

extension TabCoordinatorTests {
    @MainActor
    func testCoordinatorStart() {
        sut.start()
        XCTAssertTrue(sut.coordinatorDidStart)
    }
    
    @MainActor
    func testAddingTab() throws {
        XCTAssertEqual(sut.childCoordinators.count, 0)
        XCTAssertNil(sut.root.viewControllers)

        sut.start()
        sut.addTabs()
        
        guard let vc = sut.root.viewControllers?[0] else {
            XCTFail("no vc's set")
            return
        }
        
        sut.root.delegate?.tabBarController?(sut.root, didSelect: vc)
        
        let child = try XCTUnwrap(sut.childCoordinators.first as? MockChildTabV2Coordinator)
        XCTAssertTrue(child.did_becomeSelected)
    }
}
