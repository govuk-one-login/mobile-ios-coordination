import Testing
import UIKit
@testable import Coordination

@MainActor
@Suite("Async ParentCoordinator")
struct AsyncParentCoordinatorTests {

    @Test("startAsync default calls the synchronous start()")
    func startAsyncDefaultCallsSyncStart() async {
        let sut = MockParentCoordinator()
        await sut.startAsync()
        #expect(sut.coordinatorDidStart)
    }

    @Test("startAsync override awaits its time-consuming work to completion")
    func startAsyncOverrideAwaitsCompletion() async {
        let sut = MockAsyncParentCoordinator()
        await sut.startAsync()
        // Completion flag is set only after the delay; observing it true here
        // proves the caller suspended and waited rather than falling back to sync.
        #expect(sut.startAsyncDidComplete)
        #expect(!sut.coordinatorDidStart)
    }

    @Test("openChildAsync awaits the child's time-consuming startAsync to completion")
    func openChildAsyncAwaitsChildStart() async {
        let sut = MockAsyncParentCoordinator()
        let child = MockAsyncChildCoordinator()

        #expect(sut.childCoordinators.isEmpty)
        await sut.openChildAsync(child)

        #expect(sut.childCoordinators.count == 1)
        #expect(child.parentCoordinator === sut)
        // Proves openChildAsync awaited startAsync to *completion*, not merely
        // kicking it off. A missing await would leave this false.
        #expect(child.startAsyncDidComplete)
        #expect(!child.coordinatorDidStart)
    }

    @Test("childDidFinishAsync removes the child and awaits cleanup then regain focus, in order")
    func childDidFinishAsyncAwaitsHooksInOrder() async {
        let sut = MockAsyncParentCoordinator()
        let child = MockAsyncChildCoordinator()
        await sut.openChildAsync(child)

        await sut.childDidFinishAsync(child)

        #expect(sut.childCoordinators.isEmpty)

        // Both hooks must have run to *completion* (each set only after a delay).
        #expect(sut.performChildCleanupAsyncDidComplete)
        #expect(sut.performChildCleanupAsyncChild === child)
        #expect(sut.didRegainFocusAsyncDidComplete)
        #expect(sut.didRegainFocusAsyncChild === child)

        // And they must have completed in sequence: cleanup before regain focus.
        // This is only guaranteed if childDidFinishAsync awaited the first hook
        // before starting the second.
        let cleanupOrder = sut.performChildCleanupCompletionOrder
        let regainOrder = sut.didRegainFocusCompletionOrder
        #expect(cleanupOrder != nil)
        #expect(regainOrder != nil)
        if let cleanupOrder, let regainOrder {
            #expect(cleanupOrder < regainOrder)
        }
    }

    @Test("finishAsync routes through the parent's async childDidFinish and awaits its hooks")
    func finishAsyncRoutesThroughParent() async {
        let sut = MockAsyncParentCoordinator()
        let child = MockAsyncChildCoordinator()
        await sut.openChildAsync(child)

        await child.finishAsync()

        #expect(sut.childCoordinators.isEmpty)
        #expect(sut.performChildCleanupAsyncDidComplete)
        #expect(sut.didRegainFocusAsyncDidComplete)
    }

    @Test("childCoordinators still holds the concrete type after openChildAsync")
    func childRemainsConcretelyTyped() async {
        let sut = MockAsyncParentCoordinator()
        let child = MockAsyncChildCoordinator()
        await sut.openChildAsync(child)

        // No type erasure: the real concrete type must be recoverable.
        let recovered = sut.childCoordinators.first as? MockAsyncChildCoordinator
        #expect(recovered === child)
    }
}
