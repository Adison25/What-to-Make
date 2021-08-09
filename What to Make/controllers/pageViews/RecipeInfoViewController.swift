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

    struct Cells {
        static let ingredientCell = "ingredientsCell"
        static let directionCell = "directionsCell"
    }

    private var urlString: String = ""
    private let ingredientsTableView = DynamicSizeTableView()
    private var ingredientsArray = [ChecklistItem]()
    private let directionsTableView = DynamicSizeTableView()
    private var directionsArray = [ChecklistItem]()
    
    lazy var scrollContentViewSize = CGSize(width: view.frame.size.width, height: view.frame.height)
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = dynamicColorBackground
        
//        ingredientsTableView.register(UITableViewCell.self, forCellReuseIdentifier: Cells.ingredientCell)
        ingredientsTableView.register(IngredientTableViewCell.nib(), forCellReuseIdentifier: IngredientTableViewCell.identifier)
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
        
//        directionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: Cells.directionCell)
        directionsTableView.register(DirectionTableViewCell.nib(), forCellReuseIdentifier: DirectionTableViewCell.identifier)
        directionsTableView.delegate = self
        directionsTableView.dataSource = self
    }
    
    //dismisses the current vc
    @objc private func didTapDone(){
        dismiss(animated: true, completion: nil)
    }
    
    //opens the link
    @objc func openLink(){
        guard let url = URL(string: urlString) else {
            return
        }
        let vc = WebViewViewController(url: url)
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
    private func updateScrollViewContentSize(height: CGFloat){
        scrollContentViewSize = CGSize(width: view.frame.size.width, height: view.frame.height + height)
        reloadInputViews()
    }
    
    //appens the information from the model (will change when I work on json stuff
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
        scrollView.contentSize = scrollContentViewSize
        scrollView.backgroundColor = .clear
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false //if we dont specify this then our constraints wont be used properly
        return scrollView
    }
    
    private func createRecipeImageView(with model: PhotoModel, scrollView: UIScrollView, size: CGFloat) -> UIImageView {
        //imageView
        let imageName = model.photoFileName
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        //imageView.frame = CGRect(x: 0 , y: 0, width: size, height: size)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .red
        scrollView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }

    private func createTitleLabel(with model: PhotoModel, scrollView: UIScrollView, size: CGFloat) -> UIButton{
        //title
        let titleLabel = UIButton()
        titleLabel.setTitle("\(model.title)",for: .normal)
        //call some func that makes the size fit perfectly to how many characterrs are in the string
        titleLabel.titleLabel?.font = recipeTitleFont()
        titleLabel.titleLabel?.numberOfLines = 0
        titleLabel.titleLabel?.lineBreakMode = .byWordWrapping
        //titleLabel.font = UIFont.boldSystemFont(ofSize: 40)
        titleLabel.setTitleColor(dynamicColorText, for: .normal)
        titleLabel.titleLabel?.textAlignment = .center
        //titleLabel.frame = CGRect(x: 0, y: size, width: size, height: 80)
        //titleLabel.addTarget(self, action: #selector(hi), for: .touchUpInside)
        //titleLabel.backgroundColor = .red
        scrollView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }

    private func createSourceButton(with model: PhotoModel, scrollView: UIScrollView, size: CGFloat) -> UIButton {
        //source
        let sourceButton = UIButton()
        sourceButton.setTitle("i", for: .normal)
//        sourceButton.backgroundColor = .red
        //call some func that makes the size fit perfectly to how many characterrs are in the string
        sourceButton.titleLabel?.font = UIFont(name: "Apple Color Emoji", size: 18)
//        sourceButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        sourceButton.setTitleColor(dynamicColorText, for: .normal)
        sourceButton.titleLabel?.textAlignment = .center
        sourceButton.backgroundColor = dynamicColorBackground
        sourceButton.layer.cornerRadius = 20
        sourceButton.addTarget(self, action: #selector(openLink), for: .touchUpInside)
        scrollView.addSubview(sourceButton)
        sourceButton.translatesAutoresizingMaskIntoConstraints = false
        return sourceButton
    }

    private func createBackButton(with model: PhotoModel, scrollView: UIScrollView, size: CGFloat) -> UIButton {
        //backButton
        let backButton = UIButton()
        backButton.setTitle("X", for: .normal)
        //call some func that makes the size fit perfectly to how many characterrs are in the string
        backButton.titleLabel?.font = UIFont(name: "Apple Color Emoji", size: 18)
//        backButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        backButton.setTitleColor(dynamicColorText, for: .normal)
        backButton.titleLabel?.textAlignment = .center
        backButton.addTarget(self, action: #selector(didTapDone), for: .touchUpInside)
        backButton.backgroundColor = dynamicColorBackground
        backButton.layer.cornerRadius = 20
//        backButton.layer.borderWidth = 3
        scrollView.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        return backButton
    }

    private func createIngredientHeader(with model: PhotoModel, scrollView: UIScrollView, size: CGFloat)  -> UIButton{
        //ingredientsTitle
        let ingredientHeader = UIButton()
        ingredientHeader.setTitle("Ingredients:",for: .normal)
        //call some func that makes the size fit perfectly to how many characterrs are in the string
        ingredientHeader.titleLabel?.font = tableViewHeaderFont()
        //titleLabel.font = UIFont.boldSystemFont(ofSize: 40)
        ingredientHeader.setTitleColor(dynamicColorText, for: .normal)
        ingredientHeader.contentHorizontalAlignment =  UIControl.ContentHorizontalAlignment.center
        //ingredienHeader.contentVerticalAlignment = UIControl.ContentVerticalAlignment.top
//        ingredientHeader.frame = CGRect(x: 20, y: size + 80, width: 200, height: 80)
        //ingredienHeader.backgroundColor = .red
        scrollView.addSubview(ingredientHeader)
        ingredientHeader.translatesAutoresizingMaskIntoConstraints = false
        return ingredientHeader
    }

    private func createIngredientTableView(scrollView: UIScrollView, size: CGFloat){
        //ingredientsList
        //ingredientsTableView.frame = CGRect(x: 0, y: size + 80 + 80 , width: size, height: size * 1.3)
        ingredientsTableView.backgroundColor = .clear//dynamicColorBackground
        ingredientsTableView.estimatedRowHeight = UITableView.automaticDimension
        ingredientsTableView.separatorStyle = .none
        scrollView.addSubview(ingredientsTableView)
        ingredientsTableView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func createDirectionHeader(with model: PhotoModel, scrollView: UIScrollView, size: CGFloat) -> UIButton{
        //ingredientsTitle
        let directionsHeader = UIButton()
        directionsHeader.setTitle("Directions:",for: .normal)
        //call some func that makes the size fit perfectly to how many characterrs are in the string
        directionsHeader.titleLabel?.font = UIFont(name: "Optima Regular", size: 30)
        //titleLabel.font = UIFont.boldSystemFont(ofSize: 40)
        directionsHeader.setTitleColor(dynamicColorText, for: .normal)
        directionsHeader.contentHorizontalAlignment =  UIControl.ContentHorizontalAlignment.center
        //ingredienHeader.contentVerticalAlignment = UIControl.ContentVerticalAlignment.top
//        directionsHeader.frame = CGRect(x: 20, y: size + 80 + 80 + 550, width: 200, height: 80)
        //ingredienHeader.backgroundColor = .red
        scrollView.addSubview(directionsHeader)
        directionsHeader.translatesAutoresizingMaskIntoConstraints = false
        return directionsHeader
    }

    private func createDirectionTableView(scrollView: UIScrollView, size: CGFloat) {
        //ingredientsList
//        directionsTableView.frame = CGRect(x: 0, y: size + 80 + 80 + 640, width: size, height: size * 1.3)
        directionsTableView.backgroundColor = .clear//dynamicColorBackground
        directionsTableView.estimatedRowHeight = UITableView.automaticDimension
        directionsTableView.separatorStyle = .none
        scrollView.addSubview(directionsTableView)
        directionsTableView.translatesAutoresizingMaskIntoConstraints = false
    }

    //home func that calls all the other functions
    func configureInfoView(with model: PhotoModel, size: CGFloat) {
        
        urlString = model.url
        fillArrays(with: model)
        
        let scrollView = createScrollView()
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        let imageView = createRecipeImageView(with: model, scrollView: scrollView, size: size)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imageView.heightAnchor.constraint(equalToConstant: size)
        ])
        let titleButton = createTitleLabel(with: model, scrollView: scrollView, size: size)
        NSLayoutConstraint.activate([
            titleButton.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant: 25),
            titleButton.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            titleButton.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            titleButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
        let sourceButton = createSourceButton(with: model, scrollView: scrollView, size: size)
        NSLayoutConstraint.activate([
            sourceButton.topAnchor.constraint(equalTo: scrollView.topAnchor,constant: 25),
            sourceButton.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.09),
            sourceButton.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -10)
        ])
        let backButton = createBackButton(with: model, scrollView: scrollView, size: size)
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: scrollView.topAnchor,constant: 25),
            backButton.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.09), //or 0.25 can change depending on what i want it to look like
            backButton.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10)
        ])
        //ingredient views
        let ingredientHeader = createIngredientHeader(with: model, scrollView: scrollView, size: size)
        NSLayoutConstraint.activate([
            ingredientHeader.topAnchor.constraint(equalTo: titleButton.bottomAnchor,constant: 25),
            ingredientHeader.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.41)
        ])
        createIngredientTableView(scrollView: scrollView, size: size)
        NSLayoutConstraint.activate([
            ingredientsTableView.topAnchor.constraint(equalTo: titleButton.bottomAnchor,constant: 75),
            ingredientsTableView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        //directions views
        let directionHeader = createDirectionHeader(with: model, scrollView: scrollView, size: size)
        NSLayoutConstraint.activate([
            directionHeader.topAnchor.constraint(equalTo: ingredientsTableView.bottomAnchor,constant: 25),
            directionHeader.widthAnchor.constraint(equalTo: ingredientsTableView.widthAnchor, multiplier: 0.41)
        ])
        createDirectionTableView(scrollView: scrollView, size: size)
        NSLayoutConstraint.activate([
            directionsTableView.topAnchor.constraint(equalTo: ingredientsTableView.bottomAnchor,constant: 75),
            directionsTableView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            directionsTableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
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
        
        if tableView == self.ingredientsTableView {
            let item = ingredientsArray[indexPath.row]
            let cell = ingredientsTableView.dequeueReusableCell(withIdentifier: IngredientTableViewCell.identifier, for: indexPath) as! IngredientTableViewCell
            cell.configure(with: item.title)
            cell.selectionStyle = .none
            return cell
        }
//        var cell:UITableViewCell?

//        if tableView == self.directionsTableView {
        else {
            let item = directionsArray[indexPath.row]
            let cell = directionsTableView.dequeueReusableCell(withIdentifier: DirectionTableViewCell.identifier, for: indexPath) as! DirectionTableViewCell
            cell.configure(with: item.title, step: String(indexPath.row + 1))
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        if tableView == self.ingredientsTableView {
//            let  item  = ingredientsArray[indexPath.row]
//            item.isChecked = !item.isChecked
//        }
//
//        if tableView == self.directionsTableView {
//            let  item  = directionsArray[indexPath.row]
//            item.isChecked = !item.isChecked
//        }
//
//        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}

extension UIView {

    func addBlurrEffect() {
        let blurEffectView = TSBlurEffectView() // creating a blur effect view
        blurEffectView.intensity = 1 // setting blur intensity from 0.1 to 10
        self.addSubview(blurEffectView) // adding blur effect view as a subview to your view in which you want to use
    }

    func removeBlurEffect() {
        for subview in self.subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
    }
    
//    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
//
//        DispatchQueue.main.async {
//            let path = UIBezierPath(roundedRect: self.bounds,
//                                    byRoundingCorners: corners,
//                                    cornerRadii: CGSize(width: radius, height: radius))
//            let maskLayer = CAShapeLayer()
//            maskLayer.frame = self.bounds
//            maskLayer.path = path.cgPath
//            self.layer.mask = maskLayer
//        }
//    }
}
