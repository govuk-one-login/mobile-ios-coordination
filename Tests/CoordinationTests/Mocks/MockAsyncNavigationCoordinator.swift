import Coordination
import UIKit

/// A `NavigationCoordinator` parent that does NOT override the async cleanup
/// hook, so tests can verify the framework's default
/// `performChildCleanupAsync` (which resets the navigation delegate) runs.
final class MockAsyncNavigationCoordinator: NSObject,
                                            NavigationCoordinator,
                                            ParentCoordinator {
    let root = UINavigationController()
    var childCoordinators = [ChildCoordinator]()

    var coordinatorDidStart = false

    func start() {
        coordinatorDidStart = true
    }
}
