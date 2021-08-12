//
//  SettingsViewController.swift
//  DismissTabBarDemo
//
//  Created by Diego Bustamante on 7/15/20.
//  Copyright © 2020 Diego Bustamante. All rights reserved.
//

import UIKit

struct Model {
    let text: String
    
    init(text: String) {
        self.text = text
    }
}

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {    

    private let tableView = DynamicSizeTableView()
    private var prevScrollDirection: CGFloat = 0
    
//    var models = [Model]()
    var buttonArray = [
        ["Under 15 Min","Under 30 Min","Under 45 Min"],
        ["Breakfast","Lunch","Dinner"],
        ["Gluten Free","Vegetarian", "Mediterranean", "Pescatarian", "Vegan","Kosher","Nut Free"]
    ]
//    var timeArray = ["Under 15 Min", "Under 30 Min", "Under 45 Min"]
    var header = ["Time","Dish Type","Dietary"]
    var indexHeader = 0
    var indexButton = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        models.append(Model(text: "Under 15 Min"))
//        models.append(Model(text: "Under 30 Min"))
//        models.append(Model(text: "Under 45"))
        
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
            
        tableView.register(FilterHeaderTableViewCell.nib(), forCellReuseIdentifier: FilterHeaderTableViewCell.identifier)
        tableView.register(FilterCollectionTableViewCell.nib(), forCellReuseIdentifier: FilterCollectionTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: FilterHeaderTableViewCell.identifier, for: indexPath) as! FilterHeaderTableViewCell
            cell.configure(with: header[indexHeader])
            cell.selectionStyle = .none
            
            if indexHeader < 2 {
                indexHeader += 1
            }else {
                indexHeader = 0
            }
//            print("indexHeader\(indexPath.row)")
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: FilterCollectionTableViewCell.identifier, for: indexPath) as! FilterCollectionTableViewCell
//            print("\(buttonArray[indexButton])")
            cell.configure(with: buttonArray[indexButton])
//            cell.configure(with: models)
            cell.selectionStyle = .none

            if indexButton < 2 {
                indexButton += 1
            }else {
                indexButton = 0
            }
//            print("tableview\(indexPath.row)")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("im here!") //hits the end of the rows
    }

}


extension FilterViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewY = scrollView.contentOffset.y
        let scrollSizeHeight = scrollView.contentSize.height
        let scrollFrameHeight = scrollView.frame.height
        let scrollHeight = scrollSizeHeight - scrollFrameHeight
        var isHidden = false

        if prevScrollDirection > scrollViewY && prevScrollDirection < scrollHeight {
            isHidden = false
           // print("Scroll Up")
        } else if prevScrollDirection < scrollViewY && scrollViewY > 0 {
            isHidden = true
           // print("Scroll Down")
        }
        let userInfo : [String : Bool] = [ "isHidden" : isHidden ]
        NotificationCenter.default.post(name: tabBarNotificationKey, object: nil, userInfo: userInfo)
        prevScrollDirection = scrollView.contentOffset.y
    }
}
