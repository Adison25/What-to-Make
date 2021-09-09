//
//  HomeViewController.swift
//  DismissTabBarDemo
//
//  Created by Diego Bustamante on 7/15/20.
//  Copyright © 2020 Diego Bustamante. All rights reserved.
//
import UIKit
import CHTCollectionViewWaterfallLayout

public let tabBarNotificationKey = Notification.Name(rawValue: "tabBarNotificationKey")

class FeedViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, CHTCollectionViewDelegateWaterfallLayout {
    
    private var prevScrollDirection: CGFloat = 0
    var called = false

    lazy var collectionView : UICollectionView = {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.itemRenderDirection = .leftToRight
        layout.columnCount = 2
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemGray6//dynamicColorBackground//.clear
        return collectionView
    }()
    
    lazy var filterButton : UIButton = {
        let button = UIButton(frame: CGRect(x: view.frame.size.width * 0.85, y: view.frame.size.height * 0.85, width: view.frame.size.width * 0.10, height: view.frame.size.width * 0.10))
        button.setBackgroundImage(UIImage(systemName: "line.horizontal.3.decrease.circle.fill"), for: .normal)
        button.tintColor = dynamicColorText
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = view.frame.size.width * 0.05
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(goToFilterView), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupClearNavBar()
        navigationItem.title = "Recipes"
        view.backgroundColor = .systemGray6
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(filterButton)
        
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(didPullToRefreash), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    @objc func didPullToRefreash(){
        Constants.allRecipes.shuffle()
        Constants.modifiedRecipesArr = Constants.allRecipes
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView.reloadData()
        }
    }
    
    @objc func goToFilterView() {
        let vc = FilterViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}

extension FeedViewController {
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = RecipeInfoViewController()
        vc.whichVc = 2
        vc.configureInfoView(with: Constants.modifiedRecipesArr[indexPath.row], index: indexPath.row)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.modifiedRecipesArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        cell.configure(with: Constants.modifiedRecipesArr[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width/2,  height: view.frame.size.width/2)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        called = false
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
//        if called == false && prevScrollDirection < -1 * view.frame.size.height * 0.32 {
//            Constants.allRecipes.shuffle()
//            Constants.modifiedRecipesArr = Constants.allRecipes
//            DispatchQueue.main.async {
//                collectionView.reloadData()
//            }
//
//            called = true
//        }
        let userInfo : [String : Bool] = [ "isHidden" : isHidden ]
        NotificationCenter.default.post(name: tabBarNotificationKey, object: nil, userInfo: userInfo)
        prevScrollDirection = scrollView.contentOffset.y
    }
}
