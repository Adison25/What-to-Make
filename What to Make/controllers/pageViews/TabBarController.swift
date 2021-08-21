//
//  ViewController.swift
//  DismissTabBarDemo
//
//  Created by Diego Bustamante on 7/15/20.
//  Copyright © 2020 Diego Bustamante. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupMenuBar()
        setUpControllers()
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(_:)), name: tabBarNotificationKey, object: nil)
        selectedIndex = 3
    }
    
    @objc func notificationReceived(_ notification: Notification) {
        guard let isHidden = notification.userInfo?["isHidden"] as? Bool else { return }
        self.setTabBar(hidden: isHidden)
    }
    
    
    deinit {
       NotificationCenter.default.removeObserver(self)
    }
}

// MARK: Tabbar UI Functions
extension TabBarController {
    fileprivate func setupMenuBar() {
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.tintColor = dynamicColorText //UIColor.white
        tabBar.backgroundColor = dynamicColorBackground//UIColor.black //background of the nav bar
    }
    
    fileprivate func setUpControllers() {
        let viewFeed = FeedViewController()
        let ViewFolders = FolderViewController()
        let viewFilters = FilterViewController()
        let viewSetting = SettingsViewController()
        
         let viewOne = templateNavController(unselectedImage: UIImage.init(systemName: "folder.fill"), selectedImage: UIImage.init(systemName: "folder.fill"), rootViewController: ViewFolders)
        let viewTwo = templateNavController(unselectedImage: UIImage.init(systemName: "house.fill"), selectedImage: UIImage.init(systemName: "house.fill"), rootViewController: viewFeed)
         let viewThree = templateNavController(unselectedImage: UIImage.init(systemName: "line.horizontal.3.decrease.circle.fill"), selectedImage: UIImage.init(systemName: "line.horizontal.3.decrease.circle.fill"), rootViewController: viewFilters)
        let viewFour = templateNavController(unselectedImage: UIImage.init(systemName: "gearshape.fill"), selectedImage: UIImage.init(systemName: "gearshape.fill"), rootViewController: viewSetting)
         viewControllers = [viewOne,viewTwo ,viewThree, viewFour] //normal format
     }
    
    fileprivate func templateNavController(unselectedImage: UIImage?, selectedImage: UIImage?, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let viewNavController = UINavigationController(rootViewController: viewController)
        viewNavController.tabBarItem.image = unselectedImage
        viewNavController.tabBarItem.selectedImage = selectedImage
//        viewNavController.navigationBar.isHidden = true this makes it so the filter, recipes, etc are hidden
        return viewNavController
    }
}
