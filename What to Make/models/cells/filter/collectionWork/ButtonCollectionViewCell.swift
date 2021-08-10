//
//  ButtonCollectionViewCell.swift
//  What to Make
//
//  Created by Adison Emerick on 8/9/21.
//

import UIKit

class ButtonCollectionViewCell: UICollectionViewCell {

    @IBOutlet var filterButton: UIButton!
    
    static let identifier = "ButtonCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with title: String) {
        filterButton.setTitle(title, for: .normal)
        filterButton.titleLabel?.font = buttonFont()
        filterButton.backgroundColor = .green
    }

}
