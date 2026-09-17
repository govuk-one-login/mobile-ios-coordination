import Coordination
import UIKit

/// A parent coordinator that overrides the asynchronous coordination hooks with
/// genuinely *time-consuming* async work, so tests can prove the orchestration
/// (`childDidFinishAsync`) awaits each hook to completion and in order.
///
/// Deliberately conforms only to `AnyCoordinator` (not `NavigationCoordinator`)
/// so that its explicit `performChildCleanupAsync` override is the only default
/// in scope. Navigation-specific cleanup is covered separately by
/// `MockAsyncNavigationCoordinator`.
///
/// Each hook exposes a `...DidComplete` flag set only after a real delay, plus
/// a `...CompletionOrder` captured from a shared monotonic counter. If the
/// orchestration failed to `await` a hook, its `...DidComplete` would still be
/// `false` when control returned, and/or the completion order would be wrong.
final class MockAsyncParentCoordinator: NSObject,
                                        AnyCoordinator,
                                        ParentCoordinator {
    let root = UIViewController()
    var childCoordinators = [ChildCoordinator]()

    private let workDuration: Duration

    /// Monotonic counter used to record the order in which hooks *complete*.
    private var completionTicket = 0
    private func nextCompletionTicket() -> Int {
        completionTicket += 1
        return completionTicket
    }

    var coordinatorDidStart = false

    var startAsyncDidComplete = false

    var performChildCleanupAsyncDidComplete = false
    var performChildCleanupAsyncChild: ChildCoordinator?
    var performChildCleanupCompletionOrder: Int?

    var didRegainFocusAsyncDidComplete = false
    var didRegainFocusAsyncChild: ChildCoordinator?
    var didRegainFocusCompletionOrder: Int?

    init(workDuration: Duration = .milliseconds(20)) {
        self.workDuration = workDuration
    }

    func start() {
        coordinatorDidStart = true
    }

    func startAsync() async {
        try? await Task.sleep(for: workDuration)
        startAsyncDidComplete = true
    }

    func performChildCleanupAsync(child: ChildCoordinator) async {
        performChildCleanupAsyncChild = child
        try? await Task.sleep(for: workDuration)
        performChildCleanupAsyncDidComplete = true
        performChildCleanupCompletionOrder = nextCompletionTicket()
    }

    func didRegainFocusAsync(fromChild child: ChildCoordinator?) async {
        didRegainFocusAsyncChild = child
        try? await Task.sleep(for: workDuration)
        didRegainFocusAsyncDidComplete = true
        didRegainFocusCompletionOrder = nextCompletionTicket()
    }
}
