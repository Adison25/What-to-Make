//
//  IngredientTableViewCell.swift
//  What to Make
//
//  Created by Adison Emerick on 8/4/21.
//

import UIKit
import BEMCheckBox

class IngredientTableViewCell: UITableViewCell {
    
    static let identifier = "IngredientTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    public func configure(with title: String) {
        ingredientTextView.text = title
        ingredientTextView.numberOfLines = 0
    }
    
    @IBAction func checkBoxAction(_ sender: BEMCheckBox) {
        sender.offAnimationType = .fade
    }
    @IBOutlet var ingredientTextView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
