//
//  IngredientTableViewCell.swift
//  What to Make
//
//  Created by Adison Emerick on 8/2/21.
//

import UIKit
import BEMCheckBox

class IngredientTableViewCell: UITableViewCell, BEMCheckBoxDelegate {

    var checkMarkView = BEMCheckBox()
    var cellTitleLabel = UILabel()
    
    var dum: String?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(checkMarkView)
        addSubview(cellTitleLabel)
        
        configureCheckmarkView()
        configureTitleLabel()
        setCheckmarkConstraints()
        setTitleLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCheckMark() {
        checkMarkView.on == true ? checkMarkView.setOn(false, animated: true) : checkMarkView.setOn(true, animated: true)
    }
    
    func setTitle(cell: String) {
        cellTitleLabel.text = cell
    }
    
    func configureCheckmarkView() {
        checkMarkView.onAnimationType = .oneStroke
        checkMarkView.offAnimationType = .bounce
    }
    
    func configureTitleLabel() {
        cellTitleLabel.numberOfLines = 0 //will extend cell hieight thats multi line
        cellTitleLabel.adjustsFontSizeToFitWidth = true
    }
    
    func setCheckmarkConstraints() {
        checkMarkView.translatesAutoresizingMaskIntoConstraints = false //for autolayout
        checkMarkView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        checkMarkView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        checkMarkView.heightAnchor.constraint(equalToConstant: 20).isActive = true //hard coded height, may need to change depending on height of cell
        checkMarkView.widthAnchor.constraint(equalTo: checkMarkView.heightAnchor, multiplier: 16/11).isActive = true //same aspect ratio
    }
    
    func setTitleLabelConstraints() {
        cellTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        cellTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        cellTitleLabel.leadingAnchor.constraint(equalTo: checkMarkView.trailingAnchor, constant: 20).isActive = true
        cellTitleLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        cellTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 12).isActive = true
    }
}


