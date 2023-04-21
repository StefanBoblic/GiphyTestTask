//
//  TabBarController.swift
//  GiphyAppTestTask
//
//  Created by Stefan Boblic on 22.04.2023.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        viewControllers = TabBar.allCases.map { $0.viewController }
        self.delegate = self
        self.selectedIndex = 0

        setupUI()
    }

    private func setupUI() {
        let image = UIImage.gradientImageWithBounds(
            bounds: CGRect(x: 0, y: 0, width: UIScreen.main.scale, height: 80),
            colors: [
                UIColor.clear.cgColor,
                UIColor(named: "backgroundColor")?.withAlphaComponent(1).cgColor
            ]
        )

        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()

        appearance.backgroundImage = UIImage()
        appearance.shadowImage = image
        appearance.backgroundColor = UIColor(named: "backgroundColor")

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

enum TabBar: String, CaseIterable {

    case home
    case search
    case profile

    var viewController: UINavigationController {
        var viewController = UINavigationController()
        switch self {
        case .home:
            viewController = UINavigationController(rootViewController: HomeViewController(viewModel: HomeViewModel(networkService: NetworkWorker())))
        case .search:
            viewController = UINavigationController(rootViewController: UIViewController())
        case .profile:
            viewController = UINavigationController(rootViewController: UIViewController())
        }

        viewController.tabBarItem = tabBarItem
        viewController.tabBarItem.imageInsets.top = 5
        return viewController
    }

    var tabBarItem: UITabBarItem {
        switch self {
        case .home:
            return .init(title: nil, image: UIImage(systemName: "house"), selectedImage: UIImage(named: TabBar.home.rawValue))
        case .search:
            return .init(title: nil, image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(named: TabBar.home.rawValue))
        case .profile:
            return .init(title: nil, image: UIImage(systemName: "person"), selectedImage: UIImage(named: TabBar.home.rawValue))
        }
    }
}

