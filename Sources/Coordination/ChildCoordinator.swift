import UIKit

/// Child Coordinator
///
/// A `Coordinator` type which is presented by a parent context.
@MainActor
public protocol ChildCoordinator: Coordinator {
    /// The parent context
    ///
    /// N.B. When implementing a concrete type, this should be stored as a weak reference.
    var parentCoordinator: ParentCoordinator? { get set }
    
    /// Perform any work required for returning the context to the parent coordinator.
    /// This method should ensure `childDidFinish` is called on the parent.
    func finish()
}

public extension ChildCoordinator {
    /// End this child context and return control to the parent coordinator.
    func finish() {
        parentCoordinator?.childDidFinish(self)
    }
}
