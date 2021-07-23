//
//  PhotoCollectionViewCell.swift
//  What to Make
//
//  Created by Adison Emerick on 7/19/21.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PhotoCollectionViewCell"
    
    // subviews
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: PhotoModel) {
        createInfoModel(with: model)
    }
//    @objc func openRecipeScreen() {
//        print("openRecipeScreen")
//    }
//  
//    @objc func like() {
//        print("like")
//    }
//    
//    @objc func addToFolder() {
//        print("addToFolder")
//    }
   
    
    private func createInfoModel(with model: PhotoModel){
        createImageView(with: model)
//        let infoModel = createUIView()
//        addTitleButton(with: model, infoModel: infoModel)
//        addLikeButton(with: model, infoModel: infoModel)
//        addTags(with: model, infoModel: infoModel)
//        addFolderTag(with: model, infoModel: infoModel)
//        contentView.addSubview(infoModel)
    }
    
    private func createImageView(with model: PhotoModel){
        
        let imageName = model.photoFileName
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 0 , y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height)
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
    }
    
    /*
     * Need to create size function so that it goes to the max size for title without going ...
     */
//
//    //1 oval button saying add to folder
//    private func addFolderTag(with model: PhotoModel, infoModel: UIView){
//        let addToFolderButton = UIButton()
//        addToFolderButton.setTitle("Add to Folder", for: .normal)
//        //call some func that makes the size fit perfectly to how many characterrs are in the string
//        addToFolderButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 22)
//        addToFolderButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
//        addToFolderButton.titleLabel?.textColor = .white
//        addToFolderButton.titleLabel?.textAlignment = .center
//        addToFolderButton.frame = CGRect(x: infoModel.frame.width * 0.12, y: infoModel.frame.height * 0.65, width: infoModel.frame.width * 0.75, height: 40)
//        addToFolderButton.addTarget(self, action: #selector(addToFolder), for: .touchUpInside)
//        addToFolderButton.backgroundColor = .black
//        addToFolderButton.roundCorners(corners:  [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 7)
//        infoModel.addSubview(addToFolderButton)
//    }
//
//    //adds the 3 tags, time - num people- type of meal
//    private func addTags(with model: PhotoModel, infoModel: UIView){
//        //3 oval buttons in same row giving the top three tags
//        //time
//        let button1 = UIButton()
//        button1.setTitle("\(model.tags[0])", for: .normal)
//        //call some func that makes the size fit perfectly to how many characterrs are in the string
//        button1.titleLabel?.font = UIFont(name: "Avenir Next", size: 15)
//        button1.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
//        button1.titleLabel?.textColor = .white
//        button1.titleLabel?.textAlignment = .center
//        button1.frame = CGRect(x: infoModel.frame.width * 0.05, y: infoModel.frame.height * 0.35, width: infoModel.frame.width * 0.26, height: 40)
//        button1.backgroundColor = .black
//        button1.roundCorners(corners:  [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 7)
//        button1.addTarget(self, action: #selector(openRecipeScreen), for: .touchUpInside)
//        infoModel.addSubview(button1)
//
//        //num people
//        let button2 = UIButton()
//        button2.setTitle("\(model.tags[1])", for: .normal)
//        //call some func that makes the size fit perfectly to how many characterrs are in the string
//        button2.titleLabel?.font = UIFont(name: "Avenir Next", size: 15)
//        button2.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
//        button2.titleLabel?.textColor = .white
//        button2.titleLabel?.textAlignment = .center
//        button2.frame = CGRect(x: infoModel.frame.width * 0.37, y: infoModel.frame.height * 0.35, width: infoModel.frame.width * 0.26, height: 40)
//        button2.backgroundColor = .black
//        button2.roundCorners(corners:  [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 7)
//        button2.addTarget(self, action: #selector(openRecipeScreen), for: .touchUpInside)
//        infoModel.addSubview(button2)
//
//        //food tag
//        let button3 = UIButton()
//        button3.setTitle("\(model.tags[2])", for: .normal)
//        //call some func that makes the size fit perfectly to how many characterrs are in the string
//        button3.titleLabel?.font = UIFont(name: "Avenir Next", size: 15)
//        button3.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
//        button3.titleLabel?.textColor = .white
//        button3.titleLabel?.textAlignment = .center
//        button3.frame = CGRect(x: infoModel.frame.width * 0.69, y: infoModel.frame.height * 0.35, width: infoModel.frame.width * 0.26, height: 40)
//        button3.backgroundColor = .black
//        button3.roundCorners(corners:  [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 7)
//        button3.addTarget(self, action: #selector(openRecipeScreen), for: .touchUpInside)
//        infoModel.addSubview(button3)
//    }
//
//    //creating heart button on modal
//    private func addLikeButton(with model: PhotoModel, infoModel: UIView){
//
//        let likeButton = UIButton()
//        let heartImage = UIImage(named: "heart") as UIImage?
//        likeButton.frame = CGRect(x: infoModel.frame.width * 0.77, y: 10 , width: 50, height: 50)
//        likeButton.setImage(heartImage, for: .normal)
//        likeButton.addTarget(self, action: #selector(like), for: .touchUpInside)
//        infoModel.addSubview(likeButton)
//    }
//
//    private func addTitleButton(with model: PhotoModel, infoModel: UIView){
//
//        //adding text button to infoModel
//        let titleButton = UIButton()
//        titleButton.setTitle( model.title, for: .normal)
//        //call some func that makes the size fit perfectly to how many characterrs are in the string
//        titleButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 27)
//        titleButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 27)
//        titleButton.titleLabel?.textColor = .white
//        titleButton.titleLabel?.textAlignment = .left
//        titleButton.frame = CGRect(x: infoModel.frame.width * 0.05, y: 0, width: infoModel.frame.width * 0.75, height: 75)
//        //titleLabel.backgroundColor = .red
//        titleButton.addTarget(self, action: #selector(openRecipeScreen), for: .touchUpInside)
//        infoModel.addSubview(titleButton)
//    }
//
//    private func createUIView() -> UIView {
//
//        let infoModel = UIView()
//        infoModel.frame = CGRect(x: contentView.frame.size.width * 0.1, y: contentView.frame.size.height - 300 , width: contentView.frame.size.width * 0.8 , height: 200)
//        infoModel.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 30)
//        infoModel.addBlurrEffect()
//        infoModel.backgroundColor = UIColor.black.withAlphaComponent(0.3)
//        return infoModel
//    }
  
}
