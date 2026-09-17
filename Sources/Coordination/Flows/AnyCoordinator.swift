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

    // MARK: Async

    /// Asynchronous variant of `openChildModally(_:animated:)`.
    ///
    /// Presents the child modally, awaiting the child's asynchronous start
    /// before returning.
    public func openChildModallyAsync<T: AnyCoordinator & ChildCoordinator>(_ childCoordinator: T,
                                                                            animated: Bool = true) async {
        root.present(childCoordinator.root, animated: animated)
        await openChildAsync(childCoordinator)
    }
}
