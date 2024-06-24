@testable import Coordination
import XCTest

@MainActor
final class TabCoordinatorTests: XCTestCase {
    var sut: MockTabCoordinator!
    
    override func setUp() {
        sut = MockTabCoordinator()
    }
    
    override func tearDown() {
        sut = nil
    }
}

extension TabCoordinatorTests {
    func testCoordinatorStart() {
        sut.start()
        XCTAssertTrue(sut.coordinatorDidStart)
    }
    
    func testAddingTab() {
        XCTAssertEqual(sut.childCoordinators.count, 0)
        XCTAssertNil(sut.root.tabBar.items)
        
        sut.start()
        let child = MockChildCoordinator()
        sut.addTab(child)
        
        waitForTruth(self.sut.childCoordinators.count == 1, timeout: 20)
        XCTAssertEqual(sut.root.tabBar.items?.count, 1)
    }
}
