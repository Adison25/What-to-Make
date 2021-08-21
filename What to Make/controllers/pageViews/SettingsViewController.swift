//
//  SettingsViewController.swift
//  What to Make
//
//  Created by Adison Emerick on 8/20/21.
//

import UIKit

struct Section {
    let title: String
    let options: [SettingsOption]
}

struct SettingsOption {
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    let handler: (() -> Void)
}

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        //        table.backgroundColor = .systemBackground
        table.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
        return table
    }()
    
    var models = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupClearNavBar()
        navigationItem.title = "Settings"
        configure()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
    }
    
    func configure() {
        models.append(Section(title: "Profile", options: [
            SettingsOption(title: "Sign Out", icon: UIImage(systemName: "person.crop.circle.fill"), iconBackgroundColor: .systemRed, handler: {
                
                //alert
                let alert = UIAlertController(title: "Logging Out", message: "Are you sure? Rember your login info", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { action in
                    defaults.set(false, forKey: "LoggedIn")
                    
                    let vc = (UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: Constants.Storyboard.intialVC) as! IntialViewController)
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)

//                    let vc = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.intialVC) as? IntialViewController
//                    let appDelegate = UIApplication.shared.delegate
//                    appDelegate?.window??.rootViewController = vc
//                    self.view.window?.rootViewController = vc
//                    self.view.window?.makeKeyAndVisible()
                }))
                self.present(alert, animated: true)
                
            }),
            SettingsOption(title: "Add Acount", icon: UIImage(systemName: "person.fill.badge.plus"), iconBackgroundColor: .systemGreen, handler: {
                
                //action sheet
                
            })
        ]))
        models.append(Section(title: "Advertising", options: [
            SettingsOption(title: "Remove Ads $2.99", icon: UIImage(systemName: "megaphone.fill"), iconBackgroundColor: .systemBlue, handler: {
                
            }),
            SettingsOption(title: "Watch an Ad", icon: UIImage(systemName: "play.circle.fill"), iconBackgroundColor: .systemYellow, handler: {
                
            })
            
        ]))
        models.append(Section(title: "Information", options: [
            SettingsOption(title: "About", icon: UIImage(systemName: "info.circle.fill"), iconBackgroundColor: .systemGray, handler: {
                
            }),
            SettingsOption(title: "Privacy Policy", icon: UIImage(systemName: "hand.raised.fill"), iconBackgroundColor: .systemTeal, handler: {
                
            })
        ]))        
    }
    
    func showAlert() {
        
    }
    
    func showActionSheet() {
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = models[section]
        return section.title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section].options[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as? SettingsTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = models[indexPath.section].options[indexPath.row]
        model.handler()
    }
    
}
