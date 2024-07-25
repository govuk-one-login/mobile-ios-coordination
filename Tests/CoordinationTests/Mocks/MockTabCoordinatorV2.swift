import Coordination
import Foundation
import UIKit

final class MockTabCoordinatorV2: NSObject,
                                  AnyCoordinator,
                                  TabCoordinatorV2,
                                  ParentCoordinator {
    lazy var delegate: TabCoordinatorDelegate? = {
        TabCoordinatorDelegate(coordinator: self)
    }()
    
    var root: UITabBarController = UITabBarController()
    var childCoordinators: [ChildCoordinator] = []
    
    var coordinatorDidStart = false
    
    func start() {
        self.coordinatorDidStart = true
    }
    
    func addTabs() {
        let child = MockChildTabV2Coordinator(parentCoordinator: self)
        addTab(child)
        
        let secondChild = MockChildTabV2Coordinator(parentCoordinator: self)
        addTab(secondChild)
    }
}
