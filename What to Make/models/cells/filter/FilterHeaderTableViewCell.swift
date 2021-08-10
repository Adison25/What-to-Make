//
//  FilterHeaderTableViewCell.swift
//  What to Make
//
//  Created by Adison Emerick on 8/9/21.
//

import UIKit

class FilterHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet var filterHeaderLabel: UILabel!
    
    static let identifier = "FilterHeaderTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    public func configure(with title: String) {
        filterHeaderLabel.text = title
        filterHeaderLabel.font = tableViewHeaderFont()
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
