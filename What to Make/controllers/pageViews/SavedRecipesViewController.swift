//
//  ProfileViewController.swift
//  DismissTabBarDemo
//
//  Created by Diego Bustamante on 7/15/20.
//  Copyright © 2020 Diego Bustamante. All rights reserved.
//

import UIKit
import CoreData
import CHTCollectionViewWaterfallLayout

class SavedRecipesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout {
    
    private var prevScrollDirection: CGFloat = 0
        
    //data for the collectionview
    var idx: Int = 0
    
    private let collectionView: UICollectionView = {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.itemRenderDirection = .leftToRight
        layout.columnCount = 2
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemGray6
        return collectionView
    }()
    
    private let alertLabel: UILabel = {
        let lable = UILabel()
        lable.text = "No Recipes Saved"
        lable.font = UIFont.boldSystemFont(ofSize: 40)
        lable.alpha = 0
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.amx_autoScaleFont(forReferenceScreenSize: .size5p5Inch)
        return lable
    }()
    
    lazy var filterButton : UIButton = {
        let button = UIButton(frame: CGRect(x: view.frame.size.width * 0.85, y: view.frame.size.height * 0.85, width: view.frame.size.width * 0.10, height: view.frame.size.width * 0.10 ))
        button.setBackgroundImage(UIImage(systemName: "line.horizontal.3.decrease.circle.fill"), for: .normal)
        button.tintColor = dynamicColorText
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = view.frame.size.width * 0.05
        button.alpha = 0
//        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(goToFilterView), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        setupClearNavBar()
        navigationItem.title = "Saved"
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(alertLabel)
        view.addSubview(filterButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRecipe()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        if Constants.savedRecipes.count == 0 {
            alertLabel.alpha = 1
            filterButton.alpha = 0
        }else {
            alertLabel.alpha = 0
            filterButton.alpha = 1
        }
        getSavedRecipeItems(recipes: Constants.savedRecipes)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        NSLayoutConstraint.activate([
                   alertLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                   alertLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
               ])
    }
    
    func fetchRecipe() {
        //fetch the data from core  data to display in the collectionview
        do {
            Constants.savedRecipes = try Constants.context.fetch(Recipe.fetchRequest())
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }catch {
            fatalError("Could not fetch data from core data")
        }
    }
    
    func convertRecipeToRecipeItem(item: Recipe) -> RecipeItem {
        
        var ingredients: [String] = []
        for case let it as Ingredient in item.ingredients ?? [] {
            ingredients.append(it.name ?? "")
        }
        var directions: [String] = []
        for case let it as Direction in item.directions ?? [] {
            directions.append(it.name ?? "")
        }
        var tags: [String] = []
        for case let it as Tag in item.tags ?? [] {
            tags.append(it.name ?? "")
        }
        
        let ret = RecipeItem(key: item.key!, name: item.name!, activeTime: item.activeTime!, difficulty: item.difficulty!, yield: item.yield!, photoURL: item.photoURL!, sourceURL: item.sourceURL!, ingredients: ingredients, directions: directions, tags: tags, isSaved: item.isSaved)
        return ret
    }
    
    func getSavedRecipeItems(recipes: [Recipe]) {
        var idx = 0
        Constants.savedModifiedRecipes.removeAll()
        for item in recipes {
            Constants.savedModifiedRecipes.append(convertRecipeToRecipeItem(item: item))
            idx += 1
        }
    }
    
    @objc func goToFilterView() {
        let vc = FilterSavedViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}

extension SavedRecipesViewController {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        idx = indexPath.row
        let vc = RecipeInfoViewController()
        //get recipe from array and set the cell
//        let recipe = Constants.savedRecipes[indexPath.row]
//        let rec = convertRecipeToRecipeItem(item: recipe)
        vc.configureInfoView(with: Constants.savedModifiedRecipes[indexPath.row], index: indexPath.row)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        vc.whichVc = 1 //for saved
        present(vc, animated: true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return core data size
        return Constants.savedModifiedRecipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        
        //get recipe from array and set the cell
//        let recipe = Constants.savedRecipes[indexPath.row]
//        let rec = convertRecipeToRecipeItem(item: recipe)
//        print(Constants.savedModifiedRecipes[indexPath.row])
        cell.configure(with: Constants.savedModifiedRecipes[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width/2, height: view.frame.size.width/2)
    }
    
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
