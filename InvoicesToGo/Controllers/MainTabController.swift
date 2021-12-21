//
//  MainTabController.swift
//  InvoicesToGo
//
//  Created by Derrick Mateja on 12/20/21.
//

import UIKit

class MainTabController: UITabBarController {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
    }

    // MARK: - Helpers

    func configureViewControllers() {
        view.backgroundColor = .white
        tabBar.tintColor = .link

        let invoices = templateNavigationController(unselectedImage: UIImage(named: "invoices_outline")!, selectedImage: UIImage(named: "invoices_fill")!, rootViewController: InvoicesController())

        viewControllers = [invoices]

        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemGray6
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        }
    }

    func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        return nav
    }
}
