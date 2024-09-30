import Coordination
import UIKit

final class MockNavigationCoordinator: NSObject,
                                       AnyCoordinator,
                                       NavigationCoordinator,
                                       ParentCoordinator {
    let root = UINavigationController()
    var childCoordinators = [ChildCoordinator]()
    
    var coordinatorDidStart = false
    
    func start() {
        self.coordinatorDidStart = true
    }
}
