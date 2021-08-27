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
    
    var items: [Recipe] = []
    
    private let collectionView: UICollectionView = {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.itemRenderDirection = .leftToRight
        layout.columnCount = 2
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemGray6
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        setupClearNavBar()
        navigationItem.title = "Saved"
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        items = DataManager.shared.recipes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        if Constants.modifiedRecipesArr.count == 0 {
            let alert = UIAlertController(title: "No recipes with filters selected", message: "Please change your filters to see more recipes", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
        
}

extension SavedRecipesViewController {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return core data size
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        //read core data
        //        let item = configureRecipe(item: items[indexPath.row])
        
        cell.configure(with: Constants.modifiedRecipesArr[indexPath.row])
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
