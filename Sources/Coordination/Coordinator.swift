import UIKit

/// A basic coordinator, used to encapsulate a flow within the application
@MainActor
public protocol Coordinator: AnyObject {
    /// Pass control of the application to this coordinator
    func start()
    func startAsync() async
}

extension Coordinator {
    public func startAsync() async {
        start()
    }
}
