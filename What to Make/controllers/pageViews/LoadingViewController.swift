//
//  LoadingViewController.swift
//  What to Make
//
//  Created by Adison Emerick on 8/23/21.
//

import UIKit

class LoadingViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //make it look like its loading
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
