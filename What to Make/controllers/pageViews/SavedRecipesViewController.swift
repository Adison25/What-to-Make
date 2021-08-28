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
        lable.font.withSize(40)
        lable.alpha = 0
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchRecipe()
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        if Constants.items.count == 0 {
            alertLabel.alpha = 1
//            let alert = UIAlertController(title: "No recipes with filters selected", message: "Please change your filters to see more recipes", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
//            self.present(alert, animated: true)
        }else {
            alertLabel.alpha = 0 }
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
            Constants.items = try Constants.context.fetch(Recipe.fetchRequest())
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }catch {
            fatalError("Could not fetch data from core data")
        }
    }
    
    func covertRecipeToRecipeItem(item: Recipe) -> RecipeItem {
        
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
        
        let ret = RecipeItem(name: item.name!, activeTime: item.activeTime!, photoURL: item.photoURL!, sourceURL: item.sourceURL!, ingredients: ingredients, directions: directions, tags: tags, isSaved: item.isSaved)
        return ret
    }
}

extension SavedRecipesViewController {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        idx = indexPath.row
        let vc = RecipeInfoViewController()
        //get recipe from array and set the cell
        let recipe = Constants.items[indexPath.row]
        let rec = covertRecipeToRecipeItem(item: recipe)
        vc.configureInfoView(with: rec, index: indexPath.row)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return core data size
        return Constants.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        
        //get recipe from array and set the cell
        let recipe = Constants.items[indexPath.row]
        let rec = covertRecipeToRecipeItem(item: recipe)
        cell.configure(with: rec)
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
