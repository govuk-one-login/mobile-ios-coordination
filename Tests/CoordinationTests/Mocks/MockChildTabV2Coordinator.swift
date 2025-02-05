import Coordination
import UIKit

final class MockChildTabV2Coordinator: NSObject,
                                       AnyCoordinator,
                                       ChildCoordinator,
                                       NavigationCoordinator,
                                       TabItemCoordinator {
    let root = UINavigationController()
    weak var parentCoordinator: ParentCoordinator?
    
    var isTabChild: Bool
    
    var coordinatorDidStart = false
    var did_becomeSelected = false
        
    init(isTabChild: Bool = true,
         parentCoordinator: ParentCoordinator) {
        self.isTabChild = isTabChild
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
