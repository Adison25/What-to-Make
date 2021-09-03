//
//  SettingsViewController.swift
//  What to Make
//
//  Created by Adison Emerick on 8/20/21.
//

import UIKit
import GoogleMobileAds

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

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GADFullScreenContentDelegate {
    
    private var prevScrollDirection: CGFloat = 0
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        //        table.backgroundColor = .systemBackground
        table.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
        return table
    }()
    
    lazy var sheetLoc: UIView = {
        let view = UIView(frame: CGRect(x: view.frame.size.width/2 * 0.90, y: view.frame.size.height * 0.95, width: 100, height: 100))
        return view
    }()
    
    private var interstitial: GADInterstitialAd!
    
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
        tableView.estimatedRowHeight = UITableView.automaticDimension
        view.addSubview(sheetLoc)
        
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
                    
                }))
                self.present(alert, animated: true)
                
            }),
            SettingsOption(title: "Add Acount", icon: UIImage(systemName: "person.fill.badge.plus"), iconBackgroundColor: .systemGreen, handler: {
                
                //need to make title bigger and recreate the instagram add acount action sheet
                let actionSheet = UIAlertController(title: "Add Account", message: "", preferredStyle: .actionSheet)
                actionSheet.popoverPresentationController?.sourceView = self.sheetLoc
                actionSheet.addAction(UIAlertAction(title: "Log Into Existing Acount", style: .default, handler: {_ in
                    //go to sign in page
                    print("sign in")
                    
                }))
                actionSheet.addAction(UIAlertAction(title: "Create New Account", style: .default, handler: { action in
                    //go to intial vc
                }))
                actionSheet.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                self.present(actionSheet, animated: true)
            })
        ]))
        models.append(Section(title: "Advertising", options: [
            SettingsOption(title: "Remove Ads $2.99", icon: UIImage(systemName: "megaphone.fill"), iconBackgroundColor: .systemBlue, handler: {
                
            }),
            SettingsOption(title: "Watch an Ad", icon: UIImage(systemName: "play.circle.fill"), iconBackgroundColor: .systemYellow, handler: {
                
                let request = GADRequest()
                GADInterstitialAd.load(withAdUnitID:"ca-app-pub-4337025650731051/4044218146",
                                       request: request,
                                       completionHandler: { [self] ad, error in
                                        if let error = error {
                                            print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                                            return
                                        }
                                        interstitial = ad
                                        interstitial.fullScreenContentDelegate = self
                                       }
                )
                
                if self.interstitial != nil {
                    self.interstitial.present(fromRootViewController: self)
                }else {
                    print("ad wasnt ready")
                }
                
            })
            
        ]))
        models.append(Section(title: "Information", options: [
            SettingsOption(title: "About", icon: UIImage(systemName: "info.circle.fill"), iconBackgroundColor: .systemGray, handler: {
                
            }),
            SettingsOption(title: "Privacy Policy", icon: UIImage(systemName: "hand.raised.fill"), iconBackgroundColor: .systemTeal, handler: {
                
            })
        ]))        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension SettingsViewController {
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
    
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Success!")
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("user dismmissed the ad")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewY = scrollView.contentOffset.y
        let scrollSizeHeight = scrollView.contentSize.height
        let scrollFrameHeight = scrollView.frame.height
        let scrollHeight = scrollSizeHeight - scrollFrameHeight
        var isHidden = false
        
        if prevScrollDirection > scrollViewY && prevScrollDirection < scrollHeight {
            isHidden = false
        } else if prevScrollDirection < scrollViewY && scrollViewY > 0 {
            isHidden = true
        }
        let userInfo : [String : Bool] = [ "isHidden" : isHidden ]
        NotificationCenter.default.post(name: tabBarNotificationKey, object: nil, userInfo: userInfo)
        prevScrollDirection = scrollView.contentOffset.y
    }
}

