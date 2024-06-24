import Coordination
import UIKit

final class MockChildCoordinator: NSObject,
                                  AnyCoordinator,
                                  ChildCoordinator,
                                  NavigationCoordinator {
    var parentCoordinator: ParentCoordinator?
    let root: UINavigationController
    var isTabChild: Bool
    
    var coordinatorDidStart = false
    
    init(isTabChild: Bool = true,
         root: UINavigationController = UINavigationController()) {
        self.isTabChild = isTabChild
        self.root = root
    }
    
    func start() {
        if isTabChild {
            root.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        }
        self.coordinatorDidStart = true
    }
}
