import UIKit

/// Parent Coordinator
///
/// A `Coordinator` type which presents one or more `ChildCoordinator` types.
/// Implement conformance to `AnyCoordinator`, `NavigationCoordinator` or `TabCoordinator` depending on the required presentation context.
@MainActor
public protocol ParentCoordinator: Coordinator {
    var childCoordinators: [ChildCoordinator] { get set }

    func didRegainFocus(fromChild child: ChildCoordinator?)
    func willRegainFocus(fromChild child: ChildCoordinator?)
    func performChildCleanup(child: ChildCoordinator)
}

extension ParentCoordinator {
    /// openChild
    /// Start tracking a new child coordinator.
    /// - Parameter child: The child coordinator to be tracked
    ///
    /// This method should only be called directly if implementing a custom coordinator presentation.
    /// In other cases you should call the relevant openChild method for the relevant presentation style.
    /// For example: `openChildModally` should be used for modal presentation.
    ///
    public func openChild(_ childCoordinator: ChildCoordinator) {
        childCoordinators.append(childCoordinator)
        childCoordinator.parentCoordinator = self
        childCoordinator.start()
    }
}

public extension ParentCoordinator {
    /// Child Did Finish.
    /// Call this method from concrete implementations of `ChildCoordinator` within the `end` method.
    func childDidFinish(_ child: ChildCoordinator) {
        willRegainFocus(fromChild: child)
        for (index, coordinator) in childCoordinators.enumerated() where coordinator === child {
            childCoordinators.remove(at: index)
            break
        }
        performChildCleanup(child: child)
        didRegainFocus(fromChild: child)
    }
    
    func willRegainFocus(fromChild child: ChildCoordinator?) {
        // Default implementation is empty.
        // Override this is if response if required before a child finishes.
    }
    
    func didRegainFocus(fromChild child: ChildCoordinator?) {
        // Default implementation is empty.
        // Override this is if response if required after a child finishes.
    }
    
    func performChildCleanup(child: ChildCoordinator) {
        // Default implementation is empty. Override this is cleanup is required for this coordinator.
    }
}
