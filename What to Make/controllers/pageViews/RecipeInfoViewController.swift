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
    private let ingredientsTableView = DynamicSizeTableView()
    private var ingredientsArray = [ChecklistItem]()
    private let directionsTableView = DynamicSizeTableView()
    private var directionsArray = [ChecklistItem]()
    
    struct Cells {
        static let ingredientCell = "ingredientsCell"
        static let directionCell = "directionsCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = dynamicColorBackground
        
        ingredientsTableView.register(UITableViewCell.self, forCellReuseIdentifier: Cells.ingredientCell)
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
        
        directionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: Cells.directionCell)
        directionsTableView.delegate = self
        directionsTableView.dataSource = self
        
        
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
    
    func fillArrays(with model: PhotoModel){
        
        for x in 0..<model.ingredients.count {
            ingredientsArray.append(ChecklistItem(title: model.ingredients[x]))
        }
        for x in 0..<model.directions.count {
            directionsArray.append(ChecklistItem(title: model.directions[x]))
        }
    }
    
    private func createScrollView() -> UIScrollView{
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: 2200)
        scrollView.backgroundColor = .clear
        return scrollView
    }
    
    private func createRecipeImageView(with model: PhotoModel, scrollView: UIScrollView, size: CGFloat) {
        //imageView
        let imageName = model.photoFileName
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 0 , y: 0, width: size, height: size)
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
    }
    
    private func createTitleLabel(with model: PhotoModel, scrollView: UIScrollView, size: CGFloat) {
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
    }
    
    private func createSourceButton(with model: PhotoModel, scrollView: UIScrollView, size: CGFloat) {
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
    }
    
    private func createBackButton(with model: PhotoModel, scrollView: UIScrollView, size: CGFloat) {
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
    }
    
    private func createIngredientHeader(with model: PhotoModel, scrollView: UIScrollView, size: CGFloat) {
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
    }
    
    private func createIngredientTableView(scrollView: UIScrollView, size: CGFloat) {
        //ingredientsList
        ingredientsTableView.frame = CGRect(x: 0, y: size + 80 + 80 , width: size, height: size * 1.3)
        ingredientsTableView.backgroundColor = .clear//dynamicColorBackground
        ingredientsTableView.estimatedRowHeight = UITableView.automaticDimension
        scrollView.addSubview(ingredientsTableView)
    }
    
    private func createDirectionHeader(with model: PhotoModel, scrollView: UIScrollView, size: CGFloat) {
        //ingredientsTitle
        let directionsHeader = UIButton()
        directionsHeader.setTitle("Directions:",for: .normal)
        //call some func that makes the size fit perfectly to how many characterrs are in the string
        directionsHeader.titleLabel?.font = UIFont(name: "Optima Regular", size: 30)
        //titleLabel.font = UIFont.boldSystemFont(ofSize: 40)
        directionsHeader.setTitleColor(dynamicColorText, for: .normal)
        directionsHeader.contentHorizontalAlignment =  UIControl.ContentHorizontalAlignment.left
        //ingredienHeader.contentVerticalAlignment = UIControl.ContentVerticalAlignment.top
        directionsHeader.frame = CGRect(x: 20, y: size + 80 + 80 + 550, width: 200, height: 80)
        //ingredienHeader.backgroundColor = .red
        scrollView.addSubview(directionsHeader)
    }
    
    private func createDirectionTableView(scrollView: UIScrollView, size: CGFloat) {
        //ingredientsList
        directionsTableView.frame = CGRect(x: 0, y: size + 80 + 80 + 640, width: size, height: size * 1.3)
        directionsTableView.backgroundColor = .clear//dynamicColorBackground
        //directionsTableView.estimatedRowHeight = UITableView.automaticDimension
        scrollView.addSubview(directionsTableView)
    }
    
    //home func that calls all the other functions
    func configureInfoView(with model: PhotoModel, size: CGFloat) {
        
        urlString = model.url
        fillArrays(with: model)
        
        let scrollView = createScrollView()
        createRecipeImageView(with: model, scrollView: scrollView, size: size)
        createTitleLabel(with: model, scrollView: scrollView, size: size)
        createSourceButton(with: model, scrollView: scrollView, size: size)
        createBackButton(with: model, scrollView: scrollView, size: size)
        //ingredient views
        createIngredientHeader(with: model, scrollView: scrollView, size: size)
        createIngredientTableView(scrollView: scrollView, size: size)
        //directions views
        createDirectionHeader(with: model, scrollView: scrollView, size: size)
        createDirectionTableView(scrollView: scrollView, size: size)
        
        view.addSubview(scrollView)
    }
    
    //tableview func
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count:Int?
        
        if tableView == self.ingredientsTableView {
            count = ingredientsArray.count
        }
        
        if tableView == self.directionsTableView {
            count =  directionsArray.count
        }
        
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        
        if tableView == self.ingredientsTableView {
            let item = ingredientsArray[indexPath.row]
            cell = ingredientsTableView.dequeueReusableCell(withIdentifier: Cells.ingredientCell, for: indexPath) //as! Recip
            cell?.textLabel?.text = item.title
            cell?.textLabel?.tintColor = dynamicColorText
            cell?.textLabel?.numberOfLines = 0
            cell?.accessoryType =  item.isChecked ? .checkmark : .none
        }
        
        if tableView == self.directionsTableView {
            let item = directionsArray[indexPath.row]
            cell = directionsTableView.dequeueReusableCell(withIdentifier: Cells.directionCell, for: indexPath) //as! Recip
            cell?.textLabel?.text = item.title
            cell?.textLabel?.tintColor = dynamicColorText
            cell?.textLabel?.numberOfLines = 0
            cell?.accessoryType =  item.isChecked ? .checkmark : .none
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView == self.ingredientsTableView {
            let  item  = ingredientsArray[indexPath.row]
            item.isChecked = !item.isChecked
        }
        
        if tableView == self.directionsTableView {
            let  item  = directionsArray[indexPath.row]
            item.isChecked = !item.isChecked
        }

        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}

public class DynamicSizeTableView: UITableView {
    public override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        return contentSize
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
