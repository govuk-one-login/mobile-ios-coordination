import UIKit

/// Navigation Coordinator
///
/// A coordinator which displays one or more view controllers within a UINavigationController context
@MainActor
public protocol NavigationCoordinator: Coordinator, UINavigationControllerDelegate {
    var root: UINavigationController { get }
}

public extension NavigationCoordinator where Self: ParentCoordinator {
    /// Opens a child coordinator flow within the same UINavigationController
    /// Child coordinators must also conform to this NavigationCoordinator protocol and have the same navigation controller instance as their root.
    ///
    /// - Parameters:
    ///   - childCoordinator: The Child Coordinator that should be presented
    func openChildInline<T: NavigationCoordinator & ChildCoordinator>(_ childCoordinator: T) {
        root.delegate = childCoordinator
        openChild(childCoordinator)
        guard childCoordinator.root === root else {
            assertionFailure("Child coordinators presented inline should have the same navigation controller as their parent.")
            return
        }
    }
    
    /// When a presented child coordinator is dismissed, performs the cleanup.
    /// This ensures that the `UINavigationControllerDelegate` is correctly reset.
    func performChildCleanup(child: ChildCoordinator) {
        if let child = child as? NavigationCoordinator,
           child.root === root {
            root.delegate = self
        }
    }
}
