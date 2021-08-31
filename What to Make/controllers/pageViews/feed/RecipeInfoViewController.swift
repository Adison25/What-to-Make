//
//  RecipeInfoViewController.swift
//  What to Make
//
//  Created by Adison Emerick on 7/22/21.
//
import UIKit
import AMXFontAutoScale

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
    
    lazy var navBar: UIView = {
        let bar = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height * 0.10))
        bar.backgroundColor = .systemBackground
        return bar
    }()
    
    lazy var backButton: UIButton = {
        let itemWidth =  navBar.frame.size.height/3//navBar.frame.size.width*0.08
        let itemHeight =  navBar.frame.size.height/4
        let backButton = UIButton(frame: CGRect(x: view.frame.size.width * 0.05, y: navBar.frame.size.height/3*2, width: itemWidth, height: itemHeight))
        backButton.setBackgroundImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = dynamicColorText
        backButton.addTarget(self, action: #selector(didTapDone), for: .touchUpInside)
        return backButton
    }()
    
    lazy var bookMarkButton: UIButton = {
        let itemWidth = navBar.frame.size.height/3//navBar.frame.size.width*0.08
        let itemHeight =  navBar.frame.size.height/3
        let bookmarkButton = UIButton(frame: CGRect(x: view.frame.size.width * 0.85, y: navBar.frame.size.height/3*2, width: itemWidth, height: itemHeight))
        bookmarkButton.setBackgroundImage(UIImage(systemName: "bookmark"), for: .normal)
        bookmarkButton.tintColor = dynamicColorText
        bookmarkButton.addTarget(self, action: #selector(bookmarkRecipe(sender:)), for: .touchUpInside)
        return bookmarkButton
    }()
    
    lazy var sourceButton: UIButton = {
        let itemWidth = navBar.frame.size.height/3//self.navBar.frame.size.width*0.04
        let itemHeight =  self.navBar.frame.size.height/3
        let sourceButton = UIButton(frame: CGRect(x: view.frame.size.width * 0.75, y: navBar.frame.size.height/3*2, width: itemWidth, height: itemHeight))
        sourceButton.setBackgroundImage(UIImage(systemName: "info.circle"), for: .normal)
        sourceButton.tintColor = dynamicColorText
        sourceButton.addTarget(self, action: #selector(openLink), for: .touchUpInside)
        return sourceButton
    }()
    
    var whichVc : Int = 0
    
    private var urlString: String = ""
    private let ingredientsTableView = DynamicSizeTableView()
    private var ingredientsArray = [ChecklistItem]()
    private let directionsTableView = DynamicSizeTableView()
    private var directionsArray = [ChecklistItem]()
    
    lazy var scrollContentViewSize = CGSize(width: view.frame.size.width, height: view.frame.height)
    private var isSaved: Bool = false
    var idx = 0
    var key = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6//dynamicColorBackground
        
        ingredientsTableView.register(IngredientTableViewCell.nib(), forCellReuseIdentifier: IngredientTableViewCell.identifier)
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
        
        directionsTableView.register(DirectionTableViewCell.nib(), forCellReuseIdentifier: DirectionTableViewCell.identifier)
        directionsTableView.delegate = self
        directionsTableView.dataSource = self
    }
}
 
extension RecipeInfoViewController {
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
            addToCoreData(idx: idx)
            
        } else {
            sender.setBackgroundImage(UIImage(systemName: "bookmark"), for: .normal)
            isSaved = false
            updateSavedRecipe(idx: idx, active: isSaved)
            //the recipe to be removed
            let location = saveIdx(key: key)
            let recipeToRemove = Constants.savedRecipes[location]
            //remove the recipe
            Constants.context.delete(recipeToRemove)
            //save the data
            saveCoreData()
        }
    }
    
    func saveIdx(key: String) -> Int {
        var loc = 0
        for item in Constants.savedRecipes {
            if item.key == key {
                return loc
            }
            loc += 1
        }
        return loc
    }
    
    func checkIsSave(idx: Int, key: String) -> Bool {
        for it in Constants.savedRecipes {
            if it.key == key {
                return true
            }
        }
        return false
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
}

extension RecipeInfoViewController {
    
    private func createScrollView() -> UIScrollView{
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: navBar.frame.size.height, width: view.frame.size.width, height: view.frame.size.height - navBar.frame.size.height))
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
        let activeLabel = UIButton()
        activeLabel.setTitle("Active Time: \(model.activeTime)",for: .normal)
        //call some func that makes the size fit perfectly to how many characterrs are in the string
        activeLabel.titleLabel?.font = activeLabel.titleLabel?.font.withSize(15)//recipeTitleFont()
        activeLabel.titleLabel?.numberOfLines = 0
        activeLabel.setTitleColor(dynamicColorText, for: .normal)
        activeLabel.titleLabel?.textAlignment = .left
        scrollView.addSubview(activeLabel)
        activeLabel.translatesAutoresizingMaskIntoConstraints = false
        activeLabel.titleLabel?.amx_autoScaleFont(forReferenceScreenSize: .size5p5Inch)
        return activeLabel
    }
    
    private func createTitleLabel(with model: RecipeItem, scrollView: UIScrollView) -> UIButton{
        //title
        let titleLabel = UIButton()
        titleLabel.setTitle("\(model.name)",for: .normal)
        //call some func that makes the size fit perfectly to how many characterrs are in the string
        titleLabel.titleLabel?.font = UIFont.boldSystemFont(ofSize: 50)//titleLabel.titleLabel?.font.withSize(50)//recipeTitleFont()
        titleLabel.titleLabel?.numberOfLines = 0
        titleLabel.titleLabel?.lineBreakMode = .byWordWrapping
        titleLabel.setTitleColor(dynamicColorText, for: .normal)
        titleLabel.titleLabel?.textAlignment = .center
        scrollView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.titleLabel?.amx_autoScaleFont(forReferenceScreenSize: .size5p5Inch)
        return titleLabel
    }
    
    private func createIngredientHeader(scrollView: UIScrollView)  -> UIButton{
        let ingredientHeader = UIButton()
        ingredientHeader.setTitle("Ingredients:",for: .normal)
        ingredientHeader.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)//tableViewHeaderFont()
        ingredientHeader.setTitleColor(dynamicColorText, for: .normal)
        ingredientHeader.contentHorizontalAlignment =  UIControl.ContentHorizontalAlignment.left
        scrollView.addSubview(ingredientHeader)
        ingredientHeader.translatesAutoresizingMaskIntoConstraints = false
        ingredientHeader.titleLabel?.amx_autoScaleFont(forReferenceScreenSize: .size5p5Inch)
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
        directionsHeader.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        directionsHeader.setTitleColor(dynamicColorText, for: .normal)
        directionsHeader.contentHorizontalAlignment =  UIControl.ContentHorizontalAlignment.left
        scrollView.addSubview(directionsHeader)
        directionsHeader.translatesAutoresizingMaskIntoConstraints = false
        directionsHeader.titleLabel?.amx_autoScaleFont(forReferenceScreenSize: .size5p5Inch)
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
    
    // MARK: - infostackview
    
    private func createInfoStackView(scrollView: UIScrollView) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill // .leading .firstBaseline .center .trailing .lastBaseline
//        stackView.distribution = .fillEqually // .fillEqually .fillProportionally .equalSpacing .equalCentering
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .systemBackground
        stackView.layer.cornerRadius = 10
        return stackView
    }
    
    private func createVerticalStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center // .leading .firstBaseline .center .trailing .lastBaseline
        stackView.distribution = .fillEqually // .fillEqually .fillProportionally .equalSpacing .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func createInfoStackViewHeader(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.amx_autoScaleFont(forReferenceScreenSize: .size5p5Inch)
        return label
    }
    
    private func createInfoStackViewLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font =  label.font.withSize(15)
        label.alpha = 0.90
        label.amx_autoScaleFont(forReferenceScreenSize: .size5p5Inch)
        return label
    }
    
    private func updateNavbar() {
        navBar.addSubview(bookMarkButton)
        navBar.addSubview(backButton)
        navBar.addSubview(sourceButton)
        if isSaved == false {
            bookMarkButton.setBackgroundImage(UIImage(systemName: "bookmark"), for: .normal)
        }else {
            bookMarkButton.setBackgroundImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        }
    }
    
    func configureStackView(scrollView: UIScrollView, infoStackView: UIStackView, model: RecipeItem) {
        let num = scrollView.frame.size.width * 0.90
        
        let vert1 = createVerticalStackView()
        let timeLabel = createInfoStackViewHeader(text: "\(model.activeTime)")
        let timeLabel1 = createInfoStackViewLabel(text: "Total Time")
        vert1.addArrangedSubview(timeLabel)
        vert1.addArrangedSubview(timeLabel1)
        infoStackView.addArrangedSubview(vert1)
        NSLayoutConstraint.activate([
            vert1.widthAnchor.constraint(equalToConstant: (num/3) - 1)
        ])
        
        //separator
        let separator = UIView()
        separator.widthAnchor.constraint(equalToConstant: 1).isActive = true
        separator.backgroundColor = dynamicColorText
        infoStackView.addArrangedSubview(separator)
        separator.heightAnchor.constraint(equalTo: infoStackView.heightAnchor, multiplier: 1.0).isActive = true

        let vert2 = createVerticalStackView()
        let ingredientLabel = createInfoStackViewHeader(text: "\(model.ingredients.count)")
        let ingredientLabel1 = createInfoStackViewLabel(text: "Ingredients")
        vert2.addArrangedSubview(ingredientLabel)
        vert2.addArrangedSubview(ingredientLabel1)
        infoStackView.addArrangedSubview(vert2)
        NSLayoutConstraint.activate([
            vert2.widthAnchor.constraint(equalToConstant: (num/3) - 1)
        ])
        
        let separator2 = UIView()
        separator2.widthAnchor.constraint(equalToConstant: 1).isActive = true
        separator2.backgroundColor = dynamicColorText
        infoStackView.addArrangedSubview(separator2)
        separator2.heightAnchor.constraint(equalTo: infoStackView.heightAnchor, multiplier: 1.0).isActive = true
        
        let vert3 = createVerticalStackView()
        let stepLabel = createInfoStackViewHeader(text: "\(model.directions.count)")
        let stepLabel1 = createInfoStackViewLabel(text: "Directions")
        vert3.addArrangedSubview(stepLabel)
        vert3.addArrangedSubview(stepLabel1)
        infoStackView.addArrangedSubview(vert3)
        NSLayoutConstraint.activate([
            vert3.widthAnchor.constraint(equalToConstant: num/3 )
        ])
    }
    
    private func createBoldLabel(scrollView: UIScrollView, str: String) -> UILabel {
        let label = UILabel()
        let boldAttribute = [
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 18.0)!
        ]
        let boldText = NSAttributedString(string: str, attributes: boldAttribute)
        label.attributedText = boldText
        label.translatesAutoresizingMaskIntoConstraints = false
        label.amx_autoScaleFont(forReferenceScreenSize: .size5p5Inch)
        scrollView.addSubview(label)
        label.textAlignment = .right
        return label
    }
    private func createRegularLabel(scrollView: UIScrollView, str: String) -> UILabel {
        let label = UILabel()
        let regularAttribute = [
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Light", size: 18.0)!
        ]
        let regularText = NSAttributedString(string: str, attributes: regularAttribute)
        label.attributedText = regularText
        label.translatesAutoresizingMaskIntoConstraints = false
        label.amx_autoScaleFont(forReferenceScreenSize: .size5p5Inch)
        label.numberOfLines = 0
        scrollView.addSubview(label)
        return label
    }
    
    //home func that calls all the other functions
    func configureInfoView(with model: RecipeItem, index: Int) {
        
        idx = index
        key = model.key
        urlString = model.sourceURL
        fillArrays(with: model)
        isSaved = model.isSaved
        if whichVc == 2 {
            isSaved = checkIsSave(idx: idx, key: key) }
        
        let scrollView = createScrollView()
        view.addSubview(navBar)
        updateNavbar()
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        let titleButton = createTitleLabel(with: model, scrollView: scrollView)
        NSLayoutConstraint.activate([
            titleButton.topAnchor.constraint(equalTo: scrollView.topAnchor,constant: view.frame.size.height * 0.05),
            titleButton.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            titleButton.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            titleButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
        let imageView = createRecipeImageView(with: model, scrollView: scrollView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: titleButton.bottomAnchor,constant: view.frame.size.height * 0.05),
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        let infoStackView = createInfoStackView(scrollView: scrollView)
        NSLayoutConstraint.activate([
            infoStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant: -view.frame.size.height * 0.05),
            infoStackView.heightAnchor.constraint(equalToConstant: scrollView.frame.size.width * 0.20),
            infoStackView.widthAnchor.constraint(equalToConstant: scrollView.frame.size.width * 0.90 ),
            infoStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
        configureStackView(scrollView: scrollView, infoStackView: infoStackView, model: model)
        
        //difficulty labels
        let difficultLabel = createBoldLabel(scrollView: scrollView, str: "Difficulty: ")
        NSLayoutConstraint.activate([
            difficultLabel.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: scrollView.frame.size.height * 0.05),
            difficultLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor,constant: scrollView.frame.size.width * 0.15),
            difficultLabel.widthAnchor.constraint(equalToConstant: view.frame.size.width * 0.20)
        ])
        let difficultLabel2 = createRegularLabel(scrollView: scrollView, str: "\(model.difficulty)")
        NSLayoutConstraint.activate([
            difficultLabel2.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: scrollView.frame.size.height * 0.05),
            difficultLabel2.leftAnchor.constraint(equalTo: difficultLabel.rightAnchor, constant: 5),
            difficultLabel2.widthAnchor.constraint(equalToConstant: view.frame.size.width * 0.20)
        ])
        //yield labels
        let yieldLabel = createBoldLabel(scrollView: scrollView, str: "Yield: ")
        NSLayoutConstraint.activate([
            yieldLabel.topAnchor.constraint(equalTo: difficultLabel.bottomAnchor, constant: 15),
            yieldLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor,constant: scrollView.frame.size.width * 0.15),
            yieldLabel.widthAnchor.constraint(equalToConstant: view.frame.size.width * 0.20)
        ])
        let yieldLabel2 = createRegularLabel(scrollView: scrollView, str: "\(model.yield)")
        NSLayoutConstraint.activate([
            yieldLabel2.topAnchor.constraint(equalTo: difficultLabel2.bottomAnchor, constant: 15),
            yieldLabel2.leftAnchor.constraint(equalTo: yieldLabel.rightAnchor, constant: 5),
            yieldLabel2.widthAnchor.constraint(equalToConstant: view.frame.size.width * 0.20)
        ])
        
        //ingredient views
        let ingredientHeader = createIngredientHeader(scrollView: scrollView)
        NSLayoutConstraint.activate([
            ingredientHeader.topAnchor.constraint(equalTo: difficultLabel.bottomAnchor,constant: scrollView.frame.size.height * 0.05),
            ingredientHeader.leftAnchor.constraint(equalTo: scrollView.leftAnchor,constant: 10),
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
            directionHeader.leftAnchor.constraint(equalTo: scrollView.leftAnchor,constant: 10),
            directionHeader.widthAnchor.constraint(equalTo: ingredientsTableView.widthAnchor, multiplier: 0.41)
        ])
        createDirectionTableView(scrollView: scrollView)
        NSLayoutConstraint.activate([
            directionsTableView.topAnchor.constraint(equalTo: directionHeader.bottomAnchor,constant: 15),
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
            var boxSize: CGFloat = 40 //1024
            boxSize = boxSize * view.frame.size.width / 414
            cell.configure(with: item.title, boxSize: boxSize)
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
