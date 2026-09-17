import Coordination
import UIKit

/// A child coordinator that performs genuinely asynchronous, *time-consuming*
/// work in `startAsync()`, so tests can prove callers actually suspend and
/// await completion rather than merely triggering the work.
///
/// Each async operation exposes two observable states:
/// - `...DidBegin`  — set synchronously at entry, before the suspension point.
/// - `...DidComplete` — set only *after* a real delay has elapsed.
///
/// A caller that forgets to `await` would return while the work is still
/// suspended, leaving `...DidComplete == false` and failing the test.
final class MockAsyncChildCoordinator: NSObject,
                                       AnyCoordinator,
                                       ChildCoordinator,
                                       NavigationCoordinator {
    let root: UINavigationController
    weak var parentCoordinator: ParentCoordinator?

    /// Duration of the simulated async work. Kept small to stay fast while
    /// still forcing a real suspension across a non-trivial interval.
    private let workDuration: Duration

    var coordinatorDidStart = false

    var startAsyncDidBegin = false
    var startAsyncDidComplete = false

    init(root: UINavigationController = UINavigationController(),
         workDuration: Duration = .milliseconds(20)) {
        self.root = root
        self.workDuration = workDuration
    }

    func start() {
        coordinatorDidStart = true
    }

    /// Overrides the async default with real, time-consuming async work.
    ///
    /// `startAsyncDidComplete` is only set *after* the delay, so a test that
    /// observes it as `true` immediately after an awaited call has proven the
    /// caller waited for completion.
    func startAsync() async {
        startAsyncDidBegin = true
        try? await Task.sleep(for: workDuration)
        startAsyncDidComplete = true
    }
}
