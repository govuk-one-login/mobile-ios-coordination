import Coordination
import UIKit

final class MockParentCoordinator: NSObject,
                                   AnyCoordinator,
                                   ParentCoordinator {
    let root = UIViewController()
    var childCoordinators = [ChildCoordinator]()
    
    var coordinatorDidStart = false
    
    func start() {
        coordinatorDidStart = true
    }
}
