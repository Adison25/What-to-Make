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
    let description: String
    let ingredients: [String]
    let directions: [String]
    //let nutritionFacts: [String]
    let url: String
    let photoFileName: String
}

private var data = [
    PhotoModel(title: "Cupcake",
               description: "",
               ingredients: ["5 ounces white chocolate (finely chopped)",
                                                                "1 1/4 cups unbleached all purpose flour",
                                                                "1/4 cup cake flour (preferably unbleached)",
                                                                "1 teaspoon baking powder",
                                                                "1/2 teaspoon salt",
                                                                "1 cup whole milk",
                                                                "1 tablespoon vanilla extract",
                                                                "2/3 cup granulated sugar",
                                                                "4 tablespoons salted butter (at room temperature)",
                                                                "2 large eggs (at room temperature)",
                                                                "3/4 cup raspberry jam (or other gooey filling, optional)",
                                                                "cream cheese frosting"],
               directions: ["Preheat the oven to 350°F (176°C). Position an oven rack in the center position and line a pan of twelve 3-by-1 1/2-inch muffin cups with paper liners.",
                            "In a heatproof bowl, dump the chocolate. Bring a wide saucepan of water to a simmer over medium heat. Turn off the heat and place the bowl in the hot water. Let it stand, stirring occasionally, until the chocolate is completely melted and smooth. Be careful not to let any water get in the bowl or the chocolate will seize and clump. Remove the bowl from the water and let cool until tepid",
                            "In a small bowl, whisk together the all-purpose flour, cake flour, baking powder, and salt.",
                            "In a glass measuring cup, stir together the milk and vanilla.",
                            "In the bowl of a stand mixer or in a large bowl with a handheld electric mixer on high speed, beat the sugar and butter until light and fluffy, about 3 minutes. Beat in the eggs, 1 at a time, scraping the sides of the bowl as needed. Beat in the tepid chocolate.","Reduce the speed to low and beat in the flour mixture in 3 additions, alternating with the milk mixture in 2 additions, and mix until smooth.",
                            "Using a 2-inch diameter ice cream scoop or a 1/3 cup measuring cup, scoop the batter into the prepared cups. The cups shouldn’t be more than 2/3 full. (If you overfill the cups, they’ll end up flat rather than domed.)",
                            "Bake the white chocolate cupcakes until a toothpick inserted in the center comes out clean, 25 to 30 minutes. Do not overbake. Don’t be alarmed if the cupcakes don’t rise appreciably or if they fail to turn golden brown.",
                            "Let the cupcakes cool in the pan on a wire rack for 10 to 15 minutes. Remove the cupcakes from the pan, place them on the wire rack, and cool completely.",
                            "Just before serving, frost your white chocolate cupcakes with the white chocolate cream cheese frosting. (For an especially professional look, use an ice-cream scoop to top each cupcake with the frosting, then use a small spatula to smooth each portion of frosting into a dome.)"],
                            url: "https://leitesculinaria.com/83100/recipes-white-chocolate-cupcakes.html?utm_campaign=yummly&utm_medium=yummly&utm_source=yummly#recipe",
                            photoFileName: "meal1")
//    PhotoModel(title: "Dinner2", photoFileName: "meal2")
//    PhotoModel(photoFileName: "meal3"),
//    PhotoModel(photoFileName: "meal4"),
//    PhotoModel(photoFileName: "meal5"),
//    PhotoModel(photoFileName: "meal6"),
//    PhotoModel(photoFileName: "meal7"),
//    PhotoModel(photoFileName: "meal8"),
//    PhotoModel(photoFileName: "meal9"),
//    PhotoModel(photoFileName: "meal10")
]


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
