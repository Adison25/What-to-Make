//
//  ProfileViewController.swift
//  DismissTabBarDemo
//
//  Created by Diego Bustamante on 7/15/20.
//  Copyright © 2020 Diego Bustamante. All rights reserved.
//

import UIKit
import BEMCheckBox

class FolderViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
//        setupClearNavBar()
        navigationItem.title = "Folders"

        
        let myCheckBox = BEMCheckBox()
        myCheckBox.frame = CGRect(x: 50, y: 250, width: 50, height: 50)
        myCheckBox.onAnimationType = .oneStroke
        myCheckBox.offAnimationType = .bounce
        view.addSubview(myCheckBox)
    }
}
