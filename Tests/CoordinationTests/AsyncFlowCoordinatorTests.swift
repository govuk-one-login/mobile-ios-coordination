import Testing
import UIKit
@testable import Coordination

@MainActor
@Suite("Async NavigationCoordinator")
struct AsyncNavigationCoordinatorTests {

    @Test("openChildInlineAsync opens the child inline and awaits its async start to completion")
    func openChildInlineAsyncStartsChild() async {
        let sut = MockAsyncNavigationCoordinator()
        // Share the parent's navigation controller so the inline invariant holds.
        let child = MockAsyncChildCoordinator(root: sut.root)

        await sut.openChildInlineAsync(child)

        #expect(sut.childCoordinators.count == 1)
        #expect(child.parentCoordinator === sut)
        #expect(child.startAsyncDidComplete)
        #expect(!child.coordinatorDidStart)
        #expect(sut.root.delegate === child)
    }

    @Test("default performChildCleanupAsync resets the navigation delegate to the parent")
    func cleanupResetsDelegate() async {
        let sut = MockAsyncNavigationCoordinator()
        let child = MockAsyncChildCoordinator(root: sut.root)
        await sut.openChildInlineAsync(child)
        #expect(sut.root.delegate === child)

        await sut.childDidFinishAsync(child)

        #expect(sut.childCoordinators.isEmpty)
        #expect(sut.root.delegate === sut)
    }
}

@MainActor
@Suite("Async AnyCoordinator (modal)")
struct AsyncAnyCoordinatorTests {

    @Test("openChildModallyAsync tracks the child and awaits its async start to completion")
    func openChildModallyAsyncStartsChild() async {
        let sut = MockAsyncParentCoordinator()
        let child = MockAsyncChildCoordinator()

        await sut.openChildModallyAsync(child, animated: false)

        #expect(sut.childCoordinators.count == 1)
        #expect(child.parentCoordinator === sut)
        #expect(child.startAsyncDidComplete)
        #expect(!child.coordinatorDidStart)
    }
}

@MainActor
@Suite("Async TabCoordinator")
struct AsyncTabCoordinatorTests {

    @Test("addTabAsync adds the child to the tab bar and awaits its async start to completion")
    func addTabAsyncStartsChild() async {
        let sut = MockAsyncTabCoordinator()
        let child = MockAsyncChildCoordinator()

        await sut.addTabAsync(child)

        #expect(sut.childCoordinators.count == 1)
        #expect(child.parentCoordinator === sut)
        #expect(child.startAsyncDidComplete)
        #expect(!child.coordinatorDidStart)
        #expect(sut.root.viewControllers?.contains(child.root) == true)
        #expect(sut.root.delegate === sut.delegate)
    }
}
