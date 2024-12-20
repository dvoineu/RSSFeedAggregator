//
//  BaseTabBarController.swift
//  RSSFeedAggregator
//
//  Created by dvoineu on 3.12.24.
//

import UIKit
import SwiftUI

final class BaseTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newsVC = NewsVC()
        let settingsVC = SettingsVC()
        settingsVC.delegate = newsVC
        
        self.delegate = self
        
        viewControllers = [
            createNavController(viewcontroller: newsVC, title: "Главная", imageName: Assets.home.rawValue),
            createNavController(viewcontroller: settingsVC, title: "Настройки", imageName: Assets.settings.rawValue),
        ]
    }
    
    fileprivate func createNavController(viewcontroller: UIViewController, title: String, imageName: String) -> UIViewController {
        
        let navController = UINavigationController(rootViewController: viewcontroller)
        viewcontroller.navigationItem.title = title
        viewcontroller.view.backgroundColor = .systemBackground
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(systemName: imageName)
        navController.navigationBar.prefersLargeTitles = false
        return navController
        
    }
}

extension BaseTabBarController: UITabBarControllerDelegate {}

struct BaseTabBarController_Previews: PreviewProvider {
    
    static var previews: some View {
        Container()
    }
    
    struct Container: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> BaseTabBarController {
            BaseTabBarController()
        }
        
        func updateUIViewController(_ uiViewController: BaseTabBarController, context: Context) {
            
        }
        
        typealias UIViewControllerType = BaseTabBarController
    }
}
