//
//  FilterCollectionTableViewCell.swift
//  What to Make
//
//  Created by Adison Emerick on 8/9/21.
//

import UIKit

class FilterCollectionTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    static let identifier = "FilterCollectionTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    @IBOutlet var collectionView: UICollectionView!
    
    var models = [Model]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        collectionView.register(ButtonCollectionViewCell.nib(), forCellWithReuseIdentifier: ButtonCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
//        collectionView.backgroundColor = .red
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with models: [Model]) {
        self.models = models
        collectionView.reloadData()
    }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCollectionViewCell.identifier, for: indexPath) as! ButtonCollectionViewCell
        cell.configure(with: models[indexPath.row].text)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let aWidth : CGFloat = models[indexPath.row].text.width(withConstraintedHeight: 40, font: UIFont.systemFont(ofSize: 17.0))

             return CGSize(width: aWidth + 15 , height: 40)
//        return CGSize(width: 250, height: 250)
    }
    
    // THIS IS THE MOST IMPORTANT METHOD
    //
    // This method tells the auto layout
    // You cannot calculate the collectionView content size in any other place,
    // because you run into race condition issues.

    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {

        // If the cell's size has to be exactly the content
        // Size of the collection View, just return the
        // collectionViewLayout's collectionViewContentSize.

        self.collectionView.frame = CGRect(x: 0, y: 0,
                                       width: targetSize.width, height: 600)
        self.collectionView.layoutIfNeeded()

        // It Tells what size is required for the CollectionView
        return self.collectionView.collectionViewLayout.collectionViewContentSize

    }

}

extension String {

func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
    let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
    let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

    return ceil(boundingBox.width)
}
}
