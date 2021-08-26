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
 
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: RecipeItem) {
        //because it would keep adding image views to the content view
        for contentView in self.contentView.subviews {
            contentView.removeFromSuperview()
        }
        let imageView = UIImageView()
        imageView.sd_setImage(with: URL(string: model.photoURL), completed: nil)
        imageView.frame = contentView.bounds
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        //add some labels
    }
}
