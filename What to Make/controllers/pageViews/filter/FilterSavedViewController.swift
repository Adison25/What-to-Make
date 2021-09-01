//
//  FilterSavedViewController.swift
//  What to Make
//
//  Created by Adison Emerick on 9/1/21.
//

import UIKit

//struct Model {
//    let text: String
//    
//    init(text: String) {
//        self.text = text
//    }
//}

class FilterSavedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MyCustomCellDelegate2 {
    
    private let tableView = DynamicSizeTableView()
    private let numberReciepesLabel = UIButton()
    private var prevScrollDirection: CGFloat = 0
    
    lazy var filterLabel: UILabel = {
        let label = UILabel()
        label.text = "Filters"
        label.font = UIFont.boldSystemFont(ofSize: 50)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.amx_autoScaleFont(forReferenceScreenSize: .size5p5Inch)
        return label
    }()
    
    lazy var clearFiltersButton: UIButton = {
        let clearFiltersButton = UIButton()
        clearFiltersButton.setTitle("CLEAR ALL", for: .normal)
        clearFiltersButton.addTarget(self, action: #selector(tappedClearAll), for: .touchUpInside)
        clearFiltersButton.setTitleColor(dynamicColorText, for: .normal)
        clearFiltersButton.titleLabel?.textAlignment = .center
        clearFiltersButton.titleLabel?.font = clearFiltersButton.titleLabel?.font.withSize(18)
        clearFiltersButton.translatesAutoresizingMaskIntoConstraints = false
        clearFiltersButton.titleLabel?.amx_autoScaleFont(forReferenceScreenSize: .size5p5Inch)
        return clearFiltersButton
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
    var done = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupClearNavBar()
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
        numberReciepesLabel.titleLabel?.amx_autoScaleFont(forReferenceScreenSize: .size5p5Inch)
        view.addSubview(filterLabel)
        view.addSubview(clearFiltersButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            filterLabel.topAnchor.constraint(equalTo: view.topAnchor,constant: view.frame.size.height * 0.10),
            filterLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15)
        ])
        NSLayoutConstraint.activate([
            clearFiltersButton.centerYAnchor.constraint(equalTo: filterLabel.centerYAnchor,constant: view.frame.size.height*0.01),
            clearFiltersButton.leftAnchor.constraint(equalTo: filterLabel.leftAnchor, constant: view.frame.size.width * 0.65)
        ])
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
        numberReciepesLabel.addTarget(self, action: #selector(openSaved), for: .touchUpInside)
        //        numberReciepesLabel.backgroundColor = dynamicColorBackground
        numberReciepesLabel.layer.cornerRadius = 18
        numberReciepesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            numberReciepesLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -view.frame.size.height * 0.05),
            numberReciepesLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.60), //or 0.25 can change depending on what i want it to look like
            numberReciepesLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.frame.size.width/5)
        ])
    }
    
    @objc func openSaved() {
        if Constants.modifiedRecipesArr.count > 0 {
            let vc = (UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: Constants.Storyboard.tabBarVC) as! TabBarController)
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .fullScreen
            vc.selectedIndex = 0
            self.present(vc, animated: true)
        }
    }
    
    @objc func tappedClearAll(){
        //resets all the buttons
        resetButtonActiveArray()
        tableView.reloadData()
        resetModifiedArray()
        configureNumRecipeLabel()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        if indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: FilterHeaderTableViewCell.identifier, for: indexPath) as! FilterHeaderTableViewCell
            cell.configure(with: header[equivalentToIndexPathEven(idx: indexPath.row) ])
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row == 1  || indexPath.row == 3 || indexPath.row == 5 || indexPath.row == 7  {
            let cell = tableView.dequeueReusableCell(withIdentifier: FilterCollectionTableViewCell.identifier, for: indexPath) as! FilterCollectionTableViewCell
            let num = equivalentToIndexPathOdd(idx: indexPath.row)
            cell.configure(with: buttonArray[num], idx: num)
            cell.selectionStyle = .none
            cell.delegate2 = self
            return cell
        }
        else {
            let cell = UITableViewCell()
            cell.backgroundColor = .systemGray6
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //reconfigure because when a cell goes off screen it resets to base default and so font gets small for some reason
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: FilterHeaderTableViewCell.identifier, for: indexPath) as! FilterHeaderTableViewCell
            cell.configure(with: header[equivalentToIndexPathEven(idx: indexPath.row) ])
            cell.selectionStyle = .none
        }
        else if indexPath.row == 1  || indexPath.row == 3 || indexPath.row == 5 || indexPath.row == 7  {
            let cell = tableView.dequeueReusableCell(withIdentifier: FilterCollectionTableViewCell.identifier, for: indexPath) as! FilterCollectionTableViewCell
            let num = equivalentToIndexPathOdd(idx: indexPath.row)
            cell.configure(with: buttonArray[num], idx: num)
            cell.selectionStyle = .none
            cell.delegate2 = self
        }
    }

    
}

extension FilterSavedViewController {
    
    func equivalentToIndexPathEven(idx: Int) -> Int {
        switch(idx) {
        case 0:
            return 0
        case 2:
            return 1
        case 4:
            return 2
        case 6:
            return 3
        default:
            return 0
        }
    }
    
    func equivalentToIndexPathOdd(idx: Int) -> Int {
        switch(idx) {
        case 1:
            return 0
        case 3:
            return 1
        case 5:
            return 2
        case 7:
            return 3
        default:
            return 0
        }
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
