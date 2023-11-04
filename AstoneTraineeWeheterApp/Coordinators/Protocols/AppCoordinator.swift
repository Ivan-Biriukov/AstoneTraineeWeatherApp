import UIKit

class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showLaunchVC()
    }
    
    func showLaunchVC() {
        let vc = LaunchViewController()
        vc.coordinator = self
        navigationController.viewControllers.removeAll()
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showMainVC() {
        
    }
 
//    func showLogin() {
//        let vc = AuthViewController.createObject()
//        vc.coordinator = self
//        vc.viewModel = AuthViewModel()
//        vc.viewModel?.isLoggedIn = isLoggedIn
//        navigationController.pushViewController(vc, animated: true)
//    }
}
