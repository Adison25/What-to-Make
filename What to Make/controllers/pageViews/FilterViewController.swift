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

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MyCustomCellDelegate2 {

    private let tableView = DynamicSizeTableView()
    private let numberReciepesLabel = UIButton()
    private let clearFiltersButton = UIButton()
    private var prevScrollDirection: CGFloat = 0
    
    lazy var filterLabel: UILabel = {
        let label = UILabel()
        label.text = "Filters"
        label.font = UIFont.boldSystemFont(ofSize: 50)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var buttonArray = [
        ["Under 15 min","Under 30 Min", "Under 60 Min"],
        ["Breakfast","Snack","Smoothies", "Lunch","Sandwiches","Dinner","Bowl Meals","Pasta", "Salad","Soups", "Pizza","Chicken","Dessert", "Drinks"],
        ["Gluten Free","Vegetarian", "Mediterranean", "Pescatarian", "Vegan","Kosher","Nut Free"],
        ["Easy","Medium", "Hard"]
    ]
    var header = ["Time","Dish Type","Dietary","Difficulty"]
    var indexHeader = 0
    var indexButton = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupClearNavBar()
        navigationItem.title = "Filters"
        view.backgroundColor = .systemGray6
        view.addSubview(tableView)
        tableView.register(FilterHeaderTableViewCell.nib(), forCellReuseIdentifier: FilterHeaderTableViewCell.identifier)
        tableView.register(FilterCollectionTableViewCell.nib(), forCellReuseIdentifier: FilterCollectionTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        //adding label
        view.addSubview(numberReciepesLabel)
        view.addSubview(filterLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            filterLabel.topAnchor.constraint(equalTo: view.topAnchor,constant: view.frame.size.height * 0.10),
            filterLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.frame.size.width * 0.05)
        ])
        //tableView.frame = view.bounds
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: filterLabel.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.backgroundColor = .systemGray6
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNumRecipeLabel()
    }
    
    func updateLabel2() {
        configureNumRecipeLabel()
    }
    
    func configureNumRecipeLabel() {
        if Constants.modifiedRecipesArr.count == 0 {
            numberReciepesLabel.setTitle("SHOW RECIPES", for: .normal)
            numberReciepesLabel.backgroundColor = .systemGray4
            numberReciepesLabel.setTitleColor(dynamicColorBackground, for: .normal)
        }else {
            numberReciepesLabel.setTitle("SHOW \(Constants.modifiedRecipesArr.count) RECIPES", for: .normal)
            Utilities.styleFilledButton(numberReciepesLabel)
            numberReciepesLabel.setTitleColor(dynamicColorText, for: .normal)
        }
        numberReciepesLabel.titleLabel?.textAlignment = .center
        numberReciepesLabel.addTarget(self, action: #selector(openFeed), for: .touchUpInside)
//        numberReciepesLabel.backgroundColor = dynamicColorBackground
        numberReciepesLabel.layer.cornerRadius = 18
        numberReciepesLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            numberReciepesLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -view.frame.size.height * 0.05),
            numberReciepesLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.60), //or 0.25 can change depending on what i want it to look like
            numberReciepesLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.frame.size.width/5)
        ])
    }
    
    @objc func openFeed() {
        if Constants.modifiedRecipesArr.count > 0 {
            let vc = (UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: Constants.Storyboard.tabBarVC) as! TabBarController)
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
    
    @objc func tappedClearAll(){
        //resets all the buttons
        tableView.reloadData()
    }
    
    func configureClearAll() {
        clearFiltersButton.setTitle("CLEAR ALL", for: .normal)
        clearFiltersButton.addTarget(self, action: #selector(tappedClearAll), for: .touchUpInside)
        clearFiltersButton.setTitleColor(dynamicColorText, for: .normal)
        clearFiltersButton.titleLabel?.textAlignment = .center
        clearFiltersButton.frame = CGRect(x: 300, y: 90, width: 100, height: 50)
        clearFiltersButton.superview?.bringSubviewToFront(clearFiltersButton)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: FilterHeaderTableViewCell.identifier, for: indexPath) as! FilterHeaderTableViewCell
            cell.configure(with: header[indexHeader])
            cell.selectionStyle = .none
            
            if indexHeader < 3 {
                indexHeader += 1
            }else {
                indexHeader = 0
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: FilterCollectionTableViewCell.identifier, for: indexPath) as! FilterCollectionTableViewCell
            cell.configure(with: buttonArray[indexButton], idx: indexButton)
            cell.selectionStyle = .none
            cell.delegate2 = self
            if indexButton < 3 {
                indexButton += 1
            }else {
                indexButton = 0
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
        } else if prevScrollDirection < scrollViewY && scrollViewY > 0 {
            isHidden = true
        }
        let userInfo : [String : Bool] = [ "isHidden" : isHidden ]
        NotificationCenter.default.post(name: tabBarNotificationKey, object: nil, userInfo: userInfo)
        prevScrollDirection = scrollView.contentOffset.y
    }
}
