//
//  ButtonCollectionViewCell.swift
//  What to Make
//
//  Created by Adison Emerick on 8/9/21.
//

import UIKit

protocol MyCustomCellDelegate: AnyObject {
    func updateLabel()
}

class ButtonCollectionViewCell: UICollectionViewCell {

    @IBOutlet var filterButton: UIButton!
    
    static let identifier = "ButtonCollectionViewCell"
    
    weak var delegate: MyCustomCellDelegate?
    
    var rowIdx = 0
    var colIdx = 0
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with title: String, row: Int, col: Int) {
        filterButton.setTitle(title, for: .normal)
        filterButton.titleLabel?.font = filterButton.titleLabel?.font.withSize(16)//buttonFont()
        filterButton.setTitleColor(dynamicColorText, for: .normal)
        filterButton.backgroundColor = dynamicColorBackground
//        filterButton.layer.borderColor = UIColor(named: "buttonBorder")!.cgColor
        filterButton.layer.cornerRadius = 18
        filterButton.layer.borderWidth = 1
        filterButton.layer.borderColor = dynamicBorderColor() //dynamic color
        filterButton.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        filterButton.tag = Constants.buttonActiveArray[row][col]
        filterButton.titleLabel?.amx_autoScaleFont(forReferenceScreenSize: .size5p5Inch)
        rowIdx = row
        colIdx = col
        changeColorStart()
    }
    
    @objc func buttonTap(){
        changeColor()
        delegate?.updateLabel()
    }
    
    func changeColorStart() {
        if traitCollection.userInterfaceStyle == .light {
            if filterButton.tag == 1 {
                setDark()
                removeFilter(filter: (filterButton.titleLabel?.text)!)
            }
        } else if traitCollection.userInterfaceStyle == .dark {
            if filterButton.tag == 1 {
                setLight()
                removeFilter(filter: (filterButton.titleLabel?.text)!)
            }
        }
    }
    
    func changeColor() {
        if traitCollection.userInterfaceStyle == .light {
            if filterButton.tag == 0 {
                setDark()
                addFilter(filter: (filterButton.titleLabel?.text)!)
                filterButton.tag = 1
                Constants.buttonActiveArray[rowIdx][colIdx] = 1
            }
            else if filterButton.tag == 1 {
                setNormal()
                removeFilter(filter: (filterButton.titleLabel?.text)!)
                filterButton.tag = 0
                Constants.buttonActiveArray[rowIdx][colIdx] = 0
            }
        } else if traitCollection.userInterfaceStyle == .dark {
            if filterButton.tag == 0 {
                setLight()
                addFilter(filter: (filterButton.titleLabel?.text)!)
                filterButton.tag = 1
                Constants.buttonActiveArray[rowIdx][colIdx] = 1
            }
            else if filterButton.tag == 1 {
                setNormal()
                removeFilter(filter: (filterButton.titleLabel?.text)!)
                filterButton.tag = 0
                Constants.buttonActiveArray[rowIdx][colIdx] = 0
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
