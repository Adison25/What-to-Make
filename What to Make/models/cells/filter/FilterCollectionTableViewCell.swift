//
//  FilterCollectionTableViewCell.swift
//  What to Make
//
//  Created by Adison Emerick on 8/9/21.
//

import UIKit

protocol MyCustomCellDelegate2: AnyObject {
    func updateLabel2()
}

class FilterCollectionTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MyCustomCellDelegate{

    static let identifier = "FilterCollectionTableViewCell"
    var filterArr: [String] = []
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    @IBOutlet var collectionView: UICollectionView!
    
    var models = [String]()
    var row = 0
    var fontSize: CGFloat = 0
    
    weak var delegate2: MyCustomCellDelegate2?
    
    override func awakeFromNib() {
        super.awakeFromNib()
            
        collectionView.register(ButtonCollectionViewCell.nib(), forCellWithReuseIdentifier: ButtonCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateLabel() {
        delegate2?.updateLabel2()
    }
    
    
    func configure(with models: [String],idx: Int) {
        self.models = models
        self.row = idx
        collectionView.reloadData()
    }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCollectionViewCell.identifier, for: indexPath) as! ButtonCollectionViewCell
        cell.configure(with: models[indexPath.row],row: row, col: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    // When this function is not overriden the "table view cell height zero" warning is displayed.
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        // `collectionView.contentSize` has a wrong width because in this nested example, the sizing pass occurs before te layout pass,
        // so we need to force a force a  layout pass with the corredt width.
        self.contentView.frame = self.bounds
        self.contentView.layoutIfNeeded()
        // Returns `collectionView.contentSize` in order to set the UITableVieweCell height a value greater than 0.
        return self.collectionView.contentSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //40 for ipad font
        //1024 for ipad width
        //414 for iphone width
//        print(contentView.frame.size.width)
//        print((contentView.frame.size.width/414) * 17)
//        print(contentView.frame.width * 0.075)
        Constants.size = contentView.frame.size.width/414 * 17
//        print(Constants.size)
        let aWidth : CGFloat = models[indexPath.row].width(withConstraintedHeight: 0, font: UIFont.systemFont(ofSize: Constants.size))
        return CGSize(width: aWidth + 15 , height: contentView.frame.width * 0.075)
    }
    

}

extension String {

func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
    let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
    let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

    return ceil(boundingBox.width)
}
}
