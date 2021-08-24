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
        filterButton.titleLabel?.font = filterButton.titleLabel?.font.withSize(15)//buttonFont()
        filterButton.setTitleColor(dynamicColorText, for: .normal)
        filterButton.backgroundColor = dynamicColorBackground
//        filterButton.layer.borderColor = UIColor(named: "buttonBorder")!.cgColor
        filterButton.layer.cornerRadius = 15
        filterButton.layer.borderWidth = 1
        filterButton.layer.borderColor = dynamicBorderColor() //dynamic color
        filterButton.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        filterButton.tag = 0
    }
    
    @objc func buttonTap(){
        changeColor()

    }
    
    func changeColor() {
        if traitCollection.userInterfaceStyle == .light {
            if filterButton.tag == 0 {
                setDark()
                addFilter(filter: (filterButton.titleLabel?.text)!)
                filterButton.tag = 1
            }
            else if filterButton.tag == 1 {
                setNormal()
                removeFilter(filter: (filterButton.titleLabel?.text)!)
                filterButton.tag = 0
            }
        } else if traitCollection.userInterfaceStyle == .dark {
            if filterButton.tag == 0 {
                setLight()
                addFilter(filter: (filterButton.titleLabel?.text)!)
                filterButton.tag = 1
            }
            else if filterButton.tag == 1 {
                setNormal()
                removeFilter(filter: (filterButton.titleLabel?.text)!)
                filterButton.tag = 0
            }
        }
    }
    
    func setDark() {
        filterButton.setTitleColor(.white, for: .normal)
        filterButton.backgroundColor = .black
        filterButton.layer.borderColor = UIColor.white.cgColor
    }
    
    func setLight() {
        filterButton.setTitleColor(.black, for: .normal)
        filterButton.backgroundColor = .white
        filterButton.layer.borderColor = UIColor.black.cgColor
    }
    
    func setNormal() {
        filterButton.setTitleColor(dynamicColorText, for: .normal)
        filterButton.backgroundColor = dynamicColorBackground
        filterButton.layer.borderColor = dynamicBorderColor()
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
            
            if previousTraitCollection?.userInterfaceStyle == .light && filterButton.tag == 1 {
                setLight()
            }else if previousTraitCollection?.userInterfaceStyle == .dark && filterButton.tag == 1  {
                setDark()
            }
        }
    }

}
