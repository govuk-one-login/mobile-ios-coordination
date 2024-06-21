import Coordination
import UIKit

final class MockNavigationCoordinator: NSObject,
                                       AnyCoordinator,
                                       NavigationCoordinator,
                                       ParentCoordinator {
    
    var root: UINavigationController = UINavigationController()
    
    var childCoordinators: [ChildCoordinator] = []
    
    var coordinatorDidStart = false
    
    func start() {
        self.coordinatorDidStart = true
    }
}
