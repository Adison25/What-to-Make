//
//  DirectionTableViewCell.swift
//  What to Make
//
//  Created by Adison Emerick on 8/5/21.
//

import UIKit

class DirectionTableViewCell: UITableViewCell {

    static let identifier = "DirectionTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    @IBOutlet var view: UIView!
    @IBOutlet var stepLabel: UILabel!
    @IBOutlet var directionLabel: UILabel!
        
    public func configure(with title: String, step: String) {
        stepLabel.text = "Step \(step)"
        directionLabel.text = title
        directionLabel.numberOfLines = 0
        view.layer.cornerRadius = 10
        stepLabel.amx_autoScaleFont(forReferenceScreenSize: .size5p5Inch)
        directionLabel.amx_autoScaleFont(forReferenceScreenSize: .size5p5Inch)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
