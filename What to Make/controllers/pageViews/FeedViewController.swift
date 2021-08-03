//
//  HomeViewController.swift
//  DismissTabBarDemo
//
//  Created by Diego Bustamante on 7/15/20.
//  Copyright © 2020 Diego Bustamante. All rights reserved.
//

import UIKit

public let tabBarNotificationKey = Notification.Name(rawValue: "tabBarNotificationKey")

struct PhotoModel {
    let title: String
    //let description: String
    let ingredients: [String]
    let directions: [String]
    //let nutritionFacts: [String]
    let url: String
    let photoFileName: String
}

private var data = fetchData() 

class FeedViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private let cellId = "PhotoCollectionViewCell"
    private var prevScrollDirection: CGFloat = 0

    var gradient : CAGradientLayer?
    let gradientView : UIView = {
        let view = UIView()
        return view
    }()

    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: CGRect(x: 0 , y: 0, width: view.frame.size.width , height: view.frame.size.height), collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = false
        collectionView.backgroundColor = .clear//dynamicColorBackground//.clear
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.alwaysBounceVertical = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupCollectionView()
        setupClearNavBar()
        setupNavBarUI()
        //setupGradient()

    }
}

extension FeedViewController {
    fileprivate func setupNavBarUI() {
        navigationItem.title = "Recipes"
    }
    
    fileprivate func setupCollectionView() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    
//    fileprivate func setupGradient() {
//        let height : CGFloat = 90 // Height of the nav bar
//        let color = UIColor.white.withAlphaComponent(0.7).cgColor // You can mess with opacity to your liking
//        let clear = UIColor.white.withAlphaComponent(0.0).cgColor
//        gradient = view.setupGradient(height: height, topColor: color, bottomColor: clear)
//        view.addSubview(gradientView)
//        NSLayoutConstraint.activate([
//            gradientView.topAnchor.constraint(equalTo: view.topAnchor),
//            gradientView.leftAnchor.constraint(equalTo: view.leftAnchor),
//        ])
//        gradientView.layer.insertSublayer(gradient!, at: 0)
//    }
}


extension FeedViewController {
    
    //on cell tap
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = RecipeInfoViewController()
        let model = data[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        let size =  cell.frame.size.height
        vc.configureInfoView(with: model, size: size)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let model = data[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        cell.configure(with: model)
        //print(cell.frame.size.height)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.width)
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
