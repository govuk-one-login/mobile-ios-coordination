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
        root.addChild(childCoordinator.root)
        openChild(childCoordinator)
    }
}


open class TabNavigationCoordinator : NSObject, TabCoordinator {
    private (set) public var root: UITabBarController
    public var childCoordinators: [any ChildCoordinator] = []
    
    public init(root: UITabBarController) {
        self.root = root
    }
    
    open func start() {
        // Empty Implementation
    }
    
    open func didRegainFocus(fromChild child: (any ChildCoordinator)?) {
        // Empty Implementation
    }
}

extension TabNavigationCoordinator : UITabBarControllerDelegate, ParentCoordinator {
    public func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {

        guard let selectedChild = (childCoordinators as? [any AnyCoordinator])?
            .first(where: { $0.root == viewController }) as? TabItemCoordinator else { return }
        selectedChild.didBecomeSelected()
    }
}

@MainActor
public protocol TabItemCoordinator: Coordinator {
    func didBecomeSelected()
}
