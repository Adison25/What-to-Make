//
//  RecipeInfoTableViewCell.swift
//  What to Make
//
//  Created by Adison Emerick on 7/28/21.
//

import UIKit

class RecipeInfoTableViewCell: UITableViewCell {

    var checkMarkImageView = UIImageView()
    var cellTitleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //addSubview(checkMarkImageView)
        addSubview(cellTitleLabel)
        
        //configureImageView()
        configureTitleLabel()
        //setImageConstraints()
       // setTitleLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setString(cell: String) {
        cellTitleLabel.text = cell
    }
    
    func configureImageView() {
        checkMarkImageView.layer.cornerRadius = 10
        checkMarkImageView.clipsToBounds = true
    }
    
    func configureTitleLabel() {
        cellTitleLabel.numberOfLines = 0 //will extend cell hieight thats multi line
        cellTitleLabel.adjustsFontSizeToFitWidth = true
    }
    
    func setImageConstraints() {
        checkMarkImageView.translatesAutoresizingMaskIntoConstraints = false //for autolayout
        checkMarkImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        checkMarkImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        checkMarkImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true //hard coded height, may need to change depending on height of cell
        checkMarkImageView.widthAnchor.constraint(equalTo: checkMarkImageView.heightAnchor, multiplier: 16/11).isActive = true //same aspect ratio
    }
    
    func setTitleLabelConstraints() {
        cellTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        cellTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        cellTitleLabel.leadingAnchor.constraint(equalTo: checkMarkImageView.trailingAnchor, constant: 20).isActive = true
        cellTitleLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        cellTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 12).isActive = true
    }
}
