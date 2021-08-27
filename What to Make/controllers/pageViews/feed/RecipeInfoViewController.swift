//
//  RecipeInfoViewController.swift
//  What to Make
//
//  Created by Adison Emerick on 7/22/21.
//
import UIKit
import CoreData

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
    private var isSaved: Bool = false
    private var idx = 0

    var recipes: [Recipe] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6//dynamicColorBackground
        
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
    
    @objc func bookmarkRecipe(sender:UIButton) {
        
        if isSaved == false {
            sender.setBackgroundImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            isSaved = true
            updateSavedRecipe(idx: idx, active: isSaved)
            //add recipe to core data
            let item = Constants.modifiedRecipesArr[idx]
            let recipe = DataManager.shared.recipe(name: item.name, activeTime: item.activeTime, isSaved: item.isSaved, photoURL: item.photoURL, sourceURL: item.sourceURL)

            DataManager.shared.saveContext()
            
        } else {
            sender.setBackgroundImage(UIImage(systemName: "bookmark"), for: .normal)
            isSaved = false
            updateSavedRecipe(idx: idx, active: isSaved)
            //remove recipe from core data
        }
        
        //save to core data
        
    }
    
    private func updateScrollViewContentSize(height: CGFloat){
        scrollContentViewSize = CGSize(width: view.frame.size.width, height: view.frame.height + height)
        reloadInputViews()
    }
    
    //appens the information from the model (will change when I work on json stuff
    func fillArrays(with model: RecipeItem){
        
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
        scrollView.backgroundColor = .systemGray6//.clear
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false //if we dont specify this then our constraints wont be used properly
        return scrollView
    }
    
    private func createRecipeImageView(with model: RecipeItem, scrollView: UIScrollView) -> UIImageView {
        //imageView
        let imageView = UIImageView()
        imageView.sd_setImage(with: URL(string: model.photoURL), completed: nil)
        imageView.contentMode = .scaleAspectFill
//        imageView.isUserInteractionEnabled = true
        scrollView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    
    private func createActiveTimeLabel(with model: RecipeItem, scrollView: UIScrollView) -> UIButton{
        //title
        let activeLabel = UIButton()
        activeLabel.setTitle("Active Time: \(model.activeTime)",for: .normal)
        //call some func that makes the size fit perfectly to how many characterrs are in the string
        activeLabel.titleLabel?.font = activeLabel.titleLabel?.font.withSize(15)//recipeTitleFont()
        activeLabel.titleLabel?.numberOfLines = 0
        activeLabel.setTitleColor(dynamicColorText, for: .normal)
        activeLabel.titleLabel?.textAlignment = .left
        scrollView.addSubview(activeLabel)
        activeLabel.translatesAutoresizingMaskIntoConstraints = false
        return activeLabel
    }

    private func createTitleLabel(with model: RecipeItem, scrollView: UIScrollView) -> UIButton{
        //title
        let titleLabel = UIButton()
        titleLabel.setTitle("\(model.name)",for: .normal)
        //call some func that makes the size fit perfectly to how many characterrs are in the string
        titleLabel.titleLabel?.font = titleLabel.titleLabel?.font.withSize(50)//recipeTitleFont()
        titleLabel.titleLabel?.numberOfLines = 0
        titleLabel.titleLabel?.lineBreakMode = .byWordWrapping
        titleLabel.setTitleColor(dynamicColorText, for: .normal)
        titleLabel.titleLabel?.textAlignment = .center
        scrollView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }

    private func createSourceButton(scrollView: UIScrollView) -> UIButton {
        let sourceButton = UIButton()
        sourceButton.setTitle("i", for: .normal)
        //call some func that makes the size fit perfectly to how many characterrs are in the string
        sourceButton.titleLabel?.font = UIFont(name: "Apple Color Emoji", size: 18)
        sourceButton.setTitleColor(dynamicColorText, for: .normal)
        sourceButton.titleLabel?.textAlignment = .center
        sourceButton.backgroundColor = dynamicColorBackground
        sourceButton.layer.cornerRadius = 20
        sourceButton.addTarget(self, action: #selector(openLink), for: .touchUpInside)
        scrollView.addSubview(sourceButton)
        sourceButton.translatesAutoresizingMaskIntoConstraints = false
        return sourceButton
    }
    
    private func createBookmarkButton(scrollView: UIScrollView) -> UIButton {
        let bookmarkButton = UIButton()
        if isSaved == false {
            bookmarkButton.setBackgroundImage(UIImage(systemName: "bookmark"), for: .normal)
        }else {
            bookmarkButton.setBackgroundImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        }
//        bookmarkButton.tintColor = dynamicColorTextLink
        bookmarkButton.tag = 1
        bookmarkButton.addTarget(self, action: #selector(bookmarkRecipe), for: .touchUpInside)
        scrollView.addSubview(bookmarkButton)
        bookmarkButton.translatesAutoresizingMaskIntoConstraints = false
        return bookmarkButton
    }


    private func createBackButton(scrollView: UIScrollView) -> UIButton {
        let backButton = UIButton()
        backButton.setTitle("X", for: .normal)
        //call some func that makes the size fit perfectly to how many characterrs are in the string
        backButton.titleLabel?.font = UIFont(name: "Apple Color Emoji", size: 18)
        backButton.setTitleColor(dynamicColorText, for: .normal)
        backButton.titleLabel?.textAlignment = .center
        backButton.addTarget(self, action: #selector(didTapDone), for: .touchUpInside)
        backButton.backgroundColor = dynamicColorBackground
        backButton.layer.cornerRadius = 20
        scrollView.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        return backButton
    }

    private func createIngredientHeader(scrollView: UIScrollView)  -> UIButton{
        let ingredientHeader = UIButton()
        ingredientHeader.setTitle("Ingredients:",for: .normal)
        //call some func that makes the size fit perfectly to how many characterrs are in the string
        ingredientHeader.titleLabel?.font = ingredientHeader.titleLabel?.font.withSize(30)//tableViewHeaderFont()
        ingredientHeader.setTitleColor(dynamicColorText, for: .normal)
        ingredientHeader.contentHorizontalAlignment =  UIControl.ContentHorizontalAlignment.center
        scrollView.addSubview(ingredientHeader)
        ingredientHeader.translatesAutoresizingMaskIntoConstraints = false
        return ingredientHeader
    }

    private func createIngredientTableView(scrollView: UIScrollView){
        ingredientsTableView.backgroundColor = .systemGray6//.clear//dynamicColorBackground
        ingredientsTableView.estimatedRowHeight = UITableView.automaticDimension
        ingredientsTableView.separatorStyle = .none
        scrollView.addSubview(ingredientsTableView)
        ingredientsTableView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func createDirectionHeader(scrollView: UIScrollView) -> UIButton{
        let directionsHeader = UIButton()
        directionsHeader.setTitle("Directions:",for: .normal)
        //call some func that makes the size fit perfectly to how many characterrs are in the string
        directionsHeader.titleLabel?.font = directionsHeader.titleLabel?.font.withSize(30)
        directionsHeader.setTitleColor(dynamicColorText, for: .normal)
        directionsHeader.contentHorizontalAlignment =  UIControl.ContentHorizontalAlignment.center
        scrollView.addSubview(directionsHeader)
        directionsHeader.translatesAutoresizingMaskIntoConstraints = false
        return directionsHeader
    }

    private func createDirectionTableView(scrollView: UIScrollView) {
        //ingredientsList
        directionsTableView.backgroundColor = .systemGray6//.clear//dynamicColorBackground
        directionsTableView.estimatedRowHeight = UITableView.automaticDimension
        directionsTableView.separatorStyle = .none
        scrollView.addSubview(directionsTableView)
        directionsTableView.translatesAutoresizingMaskIntoConstraints = false
    }

    //home func that calls all the other functions
    func configureInfoView(with model: RecipeItem, index: Int) {
        
        idx = index
        urlString = model.sourceURL
        fillArrays(with: model)
        isSaved = model.isSaved
                
        let scrollView = createScrollView()
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        let imageView = createRecipeImageView(with: model, scrollView: scrollView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        let sourceButton = createSourceButton(scrollView: scrollView)
        NSLayoutConstraint.activate([
            sourceButton.topAnchor.constraint(equalTo: scrollView.topAnchor,constant: 25),
            sourceButton.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.10),
            sourceButton.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -10)
        ])
        let bookmarkButton = createBookmarkButton(scrollView: scrollView)
        NSLayoutConstraint.activate([
            bookmarkButton.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant: -50),
            bookmarkButton.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.10),
            bookmarkButton.heightAnchor.constraint(equalTo: sourceButton.heightAnchor),
            bookmarkButton.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -10)
        ])
        let backButton = createBackButton(scrollView: scrollView)
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: scrollView.topAnchor,constant: 25),
            backButton.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.10), //or 0.25 can change depending on what i want it to look like
            backButton.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10)
        ])
        let titleButton = createTitleLabel(with: model, scrollView: scrollView)
        NSLayoutConstraint.activate([
            titleButton.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant: 25),
            titleButton.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            titleButton.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            titleButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
        let activeButton = createActiveTimeLabel(with: model, scrollView: scrollView)
        NSLayoutConstraint.activate([
            activeButton.topAnchor.constraint(equalTo: titleButton.bottomAnchor,constant: 25),
            activeButton.leftAnchor.constraint(equalTo: scrollView.leftAnchor,constant: 20)
//            activeButton.rightAnchor.constraint(equalTo: scrollView.rightAnchor)
//            activeButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
        //ingredient views
        let ingredientHeader = createIngredientHeader(scrollView: scrollView)
        NSLayoutConstraint.activate([
            ingredientHeader.topAnchor.constraint(equalTo: activeButton.bottomAnchor,constant: 25),
            ingredientHeader.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.41)
        ])
        createIngredientTableView(scrollView: scrollView)
        NSLayoutConstraint.activate([
            ingredientsTableView.topAnchor.constraint(equalTo: ingredientHeader.bottomAnchor,constant: 15),
            ingredientsTableView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        //directions views
        let directionHeader = createDirectionHeader(scrollView: scrollView)
        NSLayoutConstraint.activate([
            directionHeader.topAnchor.constraint(equalTo: ingredientsTableView.bottomAnchor,constant: 25),
            directionHeader.widthAnchor.constraint(equalTo: ingredientsTableView.widthAnchor, multiplier: 0.41)
        ])
        createDirectionTableView(scrollView: scrollView)
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
        else {
            let item = directionsArray[indexPath.row]
            let cell = directionsTableView.dequeueReusableCell(withIdentifier: DirectionTableViewCell.identifier, for: indexPath) as! DirectionTableViewCell
            cell.configure(with: item.title, step: String(indexPath.row + 1))
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
}
