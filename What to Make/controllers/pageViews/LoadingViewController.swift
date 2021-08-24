//
//  LoadingViewController.swift
//  What to Make
//
//  Created by Adison Emerick on 8/23/21.
//

import UIKit
import SkeletonView

class LoadingViewController: UIViewController {
    
    lazy var myView : UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(myView)
        NSLayoutConstraint.activate([
            myView.topAnchor.constraint(equalTo: view.topAnchor),
            myView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            myView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        myView.isSkeletonable = true
        myView.showAnimatedSkeleton(usingColor: .systemGray6, animation: nil, transition: .crossDissolve(0.25))
        
        fetchData { data in
            defaults.set(true, forKey: "LoggedIn")
            DispatchQueue.main.async {
                let vc = (UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: Constants.Storyboard.tabBarVC) as! TabBarController)
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
            
        }
        // Do any additional setup after loading the view.
    }
    
}
