//
//  MainTabController.swift
//  InvoicesToGo
//
//  Created by Derrick Mateja on 12/20/21.
//

import Firebase
import UIKit

class MainTabController: UITabBarController {
    // MARK: - Lifecycle
    
    var user: User? {
        didSet {
            guard let user = user else {
                return
            }
            configureViewControllers()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
    }
    
    //MARK: - API
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let controller = LoginController()
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }
    }

    // MARK: - Helpers

    func configureViewControllers() {
        view.backgroundColor = .white
        tabBar.tintColor = .link

        let invoicesController = InvoicesController()
        let invoicesViewModel = InvoicesViewModel()
        invoicesController.viewModel = invoicesViewModel
        let invoices = templateNavigationController(unselectedImage: UIImage(named: "invoices_outline")!, selectedImage: UIImage(named: "invoices_fill")!, rootViewController: invoicesController)

        viewControllers = [invoices]

        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemGray6
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        }

        tabBar.isHidden = true
    }

    func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        return nav
    }
}
