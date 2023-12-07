// MARK: - Imports
import UIKit

// MARK: - AppCoordinator
final class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    var navigationController: UINavigationController
    
    // MARK: - init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.view.backgroundColor = UIColor(patternImage: UIImage.Common.background!)
    }
    
    // MARK: - Methods
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
 
    func showResultVC(with location: String) {
        let vc = ResultViewController(locationName: location)
        vc.coordinator = self
        vc.viewModel = ResultViewModel()
        navigationController.modalPresentationStyle = .formSheet
        navigationController.pushViewController(vc, animated: true)
    }
}
