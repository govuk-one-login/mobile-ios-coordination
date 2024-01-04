import UIKit

/// Tab Coordinator
///
/// A coordinator which displays one or more view controllers within a UITabBarController context.
@MainActor
public protocol TabCoordinator: Coordinator {
    var root: UITabBarController { get }
}

public extension TabCoordinator where Self: ParentCoordinator {
    /// Opens a child coordinator flow within the root tab bar controller
    /// Child coordinators must also conform to the AnyCoordinator protocol and have the same navigation controller instance as their root.
    ///
    /// - Parameters:
    ///   - childCoordinator: The Child Coordinator that should be presented
    func addTab<T: AnyCoordinator & ChildCoordinator>(_ childCoordinator: T) {
//        root.viewControllers?.append(childCoordinator.root)
        root.addChild(childCoordinator.root)
        openChild(childCoordinator)
    }
}
