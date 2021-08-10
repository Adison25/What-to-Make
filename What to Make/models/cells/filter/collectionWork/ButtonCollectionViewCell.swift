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
        filterButton.setTitleColor(dynamicColorText, for: .normal)
        filterButton.backgroundColor = dynamicColorBackground
        filterButton.layer.cornerRadius = 15
        filterButton.layer.borderWidth = 1
        filterButton.layer.borderColor = dynamicBorderColor() //dynamic color
        filterButton.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
    }
    
    @objc func buttonTap(){
//        filterButton.backgroundColor = dynamicColorBackgrounad
        //dynamic color changing
    }
    
    func dynamicBorderColor() -> CGColor {
        if UITraitCollection.current.userInterfaceStyle == .dark {
            return UIColor.white.cgColor
            
        }
        else {
            return UIColor.black.cgColor
            
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if (traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)) {
            filterButton.layer.borderColor = UIColor(named: "buttonBorder")!.cgColor
        }
    }

}
