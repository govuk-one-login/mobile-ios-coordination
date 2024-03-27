import UIKit

/// Presentable Coordinator
///
/// A child coordinator whose child view controllers can be presented modally on a parent coordinator.
@MainActor
public protocol AnyCoordinator: Coordinator {
    associatedtype Root: UIViewController
    var root: Root { get }
}

extension AnyCoordinator where Self: ParentCoordinator {
    /// Opens a child coordinator flow modally
    ///
    /// - Parameters:
    ///   - childCoordinator: The Child Coordinator that should be presented
    public func openChildModally<T: AnyCoordinator & ChildCoordinator>(_ childCoordinator: T,
                                                                       animated: Bool = true) {
        root.present(childCoordinator.root, animated: animated)
        openChild(childCoordinator)
    }
}
