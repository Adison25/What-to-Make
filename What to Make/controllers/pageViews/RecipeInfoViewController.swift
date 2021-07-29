//
//  RecipeInfoViewController.swift
//  What to Make
//
//  Created by Adison Emerick on 7/22/21.
//

import UIKit

class ChecklistItem {
    var title: String
    var isChecked: Bool = false
    
    init(title: String){
        self.title = title
    }
}

class RecipeInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var urlString: String = ""
    private let ingredientsTableView = UITableView()
    private var ingredientsArray = [ChecklistItem]()
    
    struct Cells {
        static let ingredientCell = "ingredientsCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = dynamicColorBackground
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "wow", style: .plain, target: self, action: #selector(didTapDone))
        
        ingredientsTableView.register(UITableViewCell.self, forCellReuseIdentifier: Cells.ingredientCell)
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
    }
    
    @objc private func didTapDone(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func openLink(){
        guard let url = URL(string: urlString) else {
            return
        }
        let vc = WebViewViewController(url: url)
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
    func fillArrayIngredients(with model: PhotoModel){
        //print(model.ingredients.count)
        for x in 0..<model.ingredients.count {
            //print(x)
            ingredientsArray.append(ChecklistItem(title: model.ingredients[x]))
//            ingredientsArray[x].title = model.ingredients[x]
        }
    }
    
    func configureInfoView(with model: PhotoModel, size: CGFloat) {
        
        urlString = model.url
        fillArrayIngredients(with: model)
        
        //create scroll view for the whole page
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: 2200)
        scrollView.backgroundColor = .clear

        
        //imageView
        let imageName = model.photoFileName
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 0 , y: 0, width: size, height: size)
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
        
        //title
        let titleLabel = UIButton()
        titleLabel.setTitle("\(model.title)",for: .normal)
        //call some func that makes the size fit perfectly to how many characterrs are in the string
        titleLabel.titleLabel?.font = UIFont(name: "Optima Regular", size: 40)
        //titleLabel.font = UIFont.boldSystemFont(ofSize: 40)
        titleLabel.setTitleColor(dynamicColorText, for: .normal)
        titleLabel.titleLabel?.textAlignment = .center
        titleLabel.frame = CGRect(x: 0, y: size, width: size, height: 80)
        //titleLabel.addTarget(self, action: #selector(hi), for: .touchUpInside)
        //titleLabel.backgroundColor = .red
        scrollView.addSubview(titleLabel)
        
        //source
        let sourceButton = UIButton()
        sourceButton.setTitle("Source", for: .normal)
        //call some func that makes the size fit perfectly to how many characterrs are in the string
        sourceButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 18)
        sourceButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        sourceButton.setTitleColor(dynamicColorTextLink, for: .normal)
        sourceButton.titleLabel?.textAlignment = .center
        sourceButton.frame = CGRect(x: size * 0.80 , y: size + 80 + 20  , width: 80, height: 40)
        sourceButton.addTarget(self, action: #selector(openLink), for: .touchUpInside)
        //sourceButton.backgroundColor = .red
        //sourceButton.roundCorners(corners:  [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 7)
        scrollView.addSubview(sourceButton)
        
        //backButton
        let backButton = UIButton()
        backButton.setTitle("Back", for: .normal)
        //call some func that makes the size fit perfectly to how many characterrs are in the string
        backButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 18)
        backButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        backButton.setTitleColor(dynamicColorTextLink, for: .normal)
        backButton.titleLabel?.textAlignment = .center
        backButton.frame = CGRect(x: 0 , y: 40  , width: 80, height: 40)
        backButton.addTarget(self, action: #selector(didTapDone), for: .touchUpInside)
        //sourceButton.backgroundColor = .red
        //sourceButton.roundCorners(corners:  [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 7)
        scrollView.addSubview(backButton)
        
        //ingredientsTitle
        let ingredienHeader = UIButton()
        ingredienHeader.setTitle("Ingredients:",for: .normal)
        //call some func that makes the size fit perfectly to how many characterrs are in the string
        ingredienHeader.titleLabel?.font = UIFont(name: "Optima Regular", size: 30)
        //titleLabel.font = UIFont.boldSystemFont(ofSize: 40)
        ingredienHeader.setTitleColor(dynamicColorText, for: .normal)
        ingredienHeader.contentHorizontalAlignment =  UIControl.ContentHorizontalAlignment.left
        //ingredienHeader.contentVerticalAlignment = UIControl.ContentVerticalAlignment.top
        ingredienHeader.frame = CGRect(x: 20, y: size + 80, width: 200, height: 80)
        //ingredienHeader.backgroundColor = .red
        scrollView.addSubview(ingredienHeader)
        
        //ingredientsList
        
        //need to make size dynamic
        ingredientsTableView.frame = CGRect(x: 0, y: size + 80 + 80 , width: size, height: size * 1.3)
        ingredientsTableView.backgroundColor = .clear//dynamicColorBackground
        scrollView.addSubview(ingredientsTableView)
        
        //directions
        
        //append scroll view to view
        view.addSubview(scrollView)
    }
    
    //tableview func
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = ingredientsArray[indexPath.row]
        let cell = ingredientsTableView.dequeueReusableCell(withIdentifier: Cells.ingredientCell, for: indexPath) //as! Recip
        cell.textLabel?.text = item.title
        cell.textLabel?.tintColor = dynamicColorText
        cell.accessoryType =  item.isChecked ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let  item  = ingredientsArray[indexPath.row]
        item.isChecked = !item.isChecked
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

}

extension UIView {

//    func addBlurrEffect() {
//        let blurEffectView = TSBlurEffectView() // creating a blur effect view
//        blurEffectView.intensity = 1 // setting blur intensity from 0.1 to 10
//        self.addSubview(blurEffectView) // adding blur effect view as a subview to your view in which you want to use
//    }
//
//    func removeBlurEffect() {
//        for subview in self.subviews {
//            if subview is UIVisualEffectView {
//                subview.removeFromSuperview()
//            }
//        }
//    }
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {

        DispatchQueue.main.async {
            let path = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
    }
}
