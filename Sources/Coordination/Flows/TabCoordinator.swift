import UIKit

/// Tab Coordinator
///
/// A coordinator which displays one or more view controllers within a UITabBarController context.
@MainActor
public protocol TabCoordinator: Coordinator {
    var root: UITabBarController { get }
    var delegate: TabCoordinatorDelegate? { get }
}

public typealias TabCoordinatorV2 = TabCoordinator

public extension TabCoordinator where Self: ParentCoordinator {
    /// Opens a child coordinator flow within the root tab bar controller
    /// Child coordinators must also conform to the AnyCoordinator protocol and have the same navigation controller instance as their root.
    ///
    /// - Parameters:
    ///   - childCoordinator: The Child Coordinator that should be presented
    func addTab<T: AnyCoordinator & ChildCoordinator>(_ childCoordinator: T) {
        root.addChild(childCoordinator.root)
        root.delegate = delegate
        openChild(childCoordinator)
    }

    // MARK: Async

    /// Asynchronous variant of `addTab(_:)`.
    func addTabAsync<T: AnyCoordinator & ChildCoordinator>(_ childCoordinator: T) async {
        root.addChild(childCoordinator.root)
        root.delegate = delegate
        await openChildAsync(childCoordinator)
    }
}

public class TabCoordinatorDelegate: NSObject,
                                     UITabBarControllerDelegate {
    weak var coordinator: (any ParentCoordinator)?
    
    public init(coordinator: any ParentCoordinator) {
        self.coordinator = coordinator
    }
    
    public func tabBarController(_ tabBarController: UITabBarController,
                                 didSelect viewController: UIViewController) {
        guard let children = coordinator?.childCoordinators as? [any AnyCoordinator],
              let selectedChild = children.first(where: { $0.root === viewController })
                as? TabItemCoordinator else {
            return
        }
        selectedChild.didBecomeSelected()
    }
}

@MainActor
public protocol TabItemCoordinator: Coordinator {
    func didBecomeSelected()
}
