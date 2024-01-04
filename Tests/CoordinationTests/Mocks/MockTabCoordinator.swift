import Coordination
import UIKit

final class MockTabCoordinator: NSObject,
                                AnyCoordinator,
                                TabCoordinator,
                                ParentCoordinator {
    
    var root: UITabBarController = UITabBarController()
    var childCoordinators: [ChildCoordinator] = []
    
    var coordinatorDidStart = false
    
    func start() {
        self.coordinatorDidStart = true
    }
}
