import Coordination
import UIKit

final class MockChildCoordinator: NSObject,
                                  AnyCoordinator,
                                  ChildCoordinator,
                                  NavigationCoordinator {
    var parentCoordinator: ParentCoordinator?
    let root: UINavigationController = UINavigationController()
    var isTabChild: Bool
    
    var coordinatorDidStart = false
    
    init(isTabChild: Bool = true) {
        self.isTabChild = isTabChild
    }
    
    func start() {
        if isTabChild {
            root.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        }
        self.coordinatorDidStart = true
    }
}
