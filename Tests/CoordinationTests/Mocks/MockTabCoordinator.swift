import Coordination
import UIKit

final class MockTabCoordinator: NSObject,
                                AnyCoordinator,
                                TabCoordinator,
                                ParentCoordinator {
    let root = UITabBarController()
    var childCoordinators = [ChildCoordinator]()
    
    var coordinatorDidStart = false
    
    func start() {
        self.coordinatorDidStart = true
    }
}
