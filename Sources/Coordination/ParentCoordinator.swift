import UIKit

/// Parent Coordinator
///
/// A `Coordinator` type which presents one or more `ChildCoordinator` types.
/// Implement conformance to `AnyCoordinator`, `NavigationCoordinator` or `TabCoordinator` depending on the required presentation context.
@MainActor
public protocol ParentCoordinator: Coordinator {
    var childCoordinators: [ChildCoordinator] { get set }

    func didRegainFocus(fromChild child: ChildCoordinator?)
    func performChildCleanup(child: ChildCoordinator)
}

extension ParentCoordinator {
    func openChild(_ childCoordinator: ChildCoordinator) {
        childCoordinators.append(childCoordinator)
        childCoordinator.start()
        childCoordinator.parentCoordinator = self
    }
}

public extension ParentCoordinator {
    /// Child Did Finish.
    /// Call this method from concrete implementations of `ChildCoordinator` within the `end` method.
    func childDidFinish(_ child: ChildCoordinator) {
        for (index, coordinator) in childCoordinators.enumerated() where coordinator === child {
            childCoordinators.remove(at: index)
            break
        }
        performChildCleanup(child: child)
        didRegainFocus(fromChild: child)
    }
    
    func didRegainFocus(fromChild child: ChildCoordinator?) {
        // Default implementation is empty.
        // Override this is if response if required after a child finishes.
    }
    
    func performChildCleanup(child: ChildCoordinator) {
        // Default implementation is empty. Override this is cleanup is required for this coordinator.
    }
}
