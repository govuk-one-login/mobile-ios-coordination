import Coordination
import Foundation
import UIKit

/// A `TabCoordinator` parent used to exercise `addTabAsync`.
final class MockAsyncTabCoordinator: NSObject,
                                     AnyCoordinator,
                                     TabCoordinator,
                                     ParentCoordinator {
    lazy var delegate: TabCoordinatorDelegate? = {
        TabCoordinatorDelegate(coordinator: self)
    }()

    let root = UITabBarController()
    var childCoordinators = [ChildCoordinator]()

    var coordinatorDidStart = false

    func start() {
        coordinatorDidStart = true
    }
}
