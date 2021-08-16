//
//  PhotoCollectionViewCell.swift
//  What to Make
//
//  Created by Adison Emerick on 7/19/21.
//

import UIKit
import SDWebImage

class PhotoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PhotoCollectionViewCell"
    
    var disabledHighlightedAnimation = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: RecipeItem) {
//        let imageName = model.photoFileName
//        let image = UIImage(named: imageName)
        let imageView = UIImageView() //UIImageView(image: image!)
        imageView.sd_setImage(with: URL(string: model.photoURL), completed: nil)
        imageView.frame = CGRect(x: 0 , y: 0, width: contentView.frame.size.height, height: contentView.frame.size.height)
        //print(contentView.frame.size.height)
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
    }
 
}
