import UIKit

/// Tab Coordinator
///
/// A coordinator which displays one or more view controllers within a UITabBarController context.
@MainActor
public protocol TabCoordinator: Coordinator {
    var root: UITabBarController { get }
}

class TabSomething: NSObject, TabCoordinator {
    private (set) var root: UITabBarController
    var childCoordinators: [any ChildCoordinator] = []
    
    init(root: UITabBarController) {
        self.root = root
    }
    
    public func start() {
        // Empty Implementation
    }
}

extension TabSomething: UITabBarControllerDelegate, ParentCoordinator {
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {

        guard let selectedChild = (childCoordinators as? [any AnyCoordinator])?
            .first(where: { $0.root == viewController }) as? TabItemCoordinator else { return }
        selectedChild.didBecomeSelected()
    }
}

//public extension TabCoordinator where Self: ParentCoordinator {
//    func tabBarController(_ tabBarController: UITabBarController,
//                          didSelect viewController: UIViewController) {
//
//        guard let selectedChild = (childCoordinators as? [any AnyCoordinator])?
//            .first(where: { $0.root == viewController }) as? TabItemCoordinator else { return }
//        selectedChild.didBecomeSelected()
//    }
//}

public protocol TabItemCoordinator: Coordinator {
    func didBecomeSelected()
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

//public protocol TabItemCoordinator: Coordinator {
//    func didBecomeSelected()
//}
//
//public extension TabCoordinator where Self: ParentCoordinator {
//    @MainActor
//    func tabBarController(_ tabBarController: UITabBarController,
//                          didSelect viewController: UIViewController) {
//        
//        if let children = childCoordinators as? [any AnyCoordinator] {
//            let this = children.first(where: {$0.root == viewController})
//            
//            if this != nil {
//                didBecomeSelected()
//            }
//        }
//    }
//}
