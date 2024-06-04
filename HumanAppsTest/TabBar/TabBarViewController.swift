import UIKit

final class TabBarViewController: UITabBarController {
    
    // MARK: Lyfecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().backgroundColor = .lightGray
        setupTabBar()
    }
}

// MARK: - Private methods
private extension TabBarViewController {
    
    func setupTabBar() {
        let setupMain = createNav(
            with: "Main",
            image: UIImage(systemName: "circle.lefthalf.filled.righthalf.striped.horizontal.inverse"),
            vc: MainViewController()
        )
        let setupSettings = createNav(
            with: "Settings",
            image: UIImage(systemName: "gearshape.fill"),
            vc: SettingsViewController()
        )
        
        self.setViewControllers([setupMain, setupSettings], animated: true)
    }
    
    func createNav(with title: String, image: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        return nav
    }
}
