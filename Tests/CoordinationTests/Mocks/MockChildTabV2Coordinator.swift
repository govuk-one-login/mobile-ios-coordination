import Coordination
import UIKit

final class MockChildTabV2Coordinator: NSObject,
                                       AnyCoordinator,
                                       ChildCoordinator,
                                       NavigationCoordinator,
                                       TabItemCoordinator {
    var parentCoordinator: ParentCoordinator?
    
    var coordinatorDidStart = false
    var did_becomeSelected = false
    
    let root: UINavigationController
    
    var isTabChild: Bool
    
    init(isTabChild: Bool = true,
         root: UINavigationController = UINavigationController(),
         parentCoordinator: ParentCoordinator) {
        self.isTabChild = isTabChild
        self.root = root
        self.parentCoordinator = parentCoordinator
    }
    
    func didBecomeSelected() {
        self.did_becomeSelected = true
    }
    
    func start() {
        self.coordinatorDidStart = true
        if isTabChild {
            root.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        }
    }
}
