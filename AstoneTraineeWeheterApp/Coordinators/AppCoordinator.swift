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
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showMainVC() {
        let vc = MainViewController()
        vc.coordinator = self
        vc.viewModel = MainViewModel()
        navigationController.viewControllers.removeAll()
        navigationController.pushViewController(vc, animated: true)
    }
 
    func showResultVC() {
        let vc = ResultViewController()
        vc.coordinator = self
        vc.viewModel = ResultViewModel()
        navigationController.modalPresentationStyle = .formSheet
        navigationController.pushViewController(vc, animated: true)
    }
}
