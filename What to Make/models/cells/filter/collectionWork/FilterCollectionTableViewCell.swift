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
    
    var models = [String]()
    var totalWidth : CGFloat = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        collectionView.register(ButtonCollectionViewCell.nib(), forCellWithReuseIdentifier: ButtonCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
//        collectionView.backgroundColor = .red
//        collectionView.allowsMultipleSelection = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with models: [String]) {
        self.models = models
        collectionView.reloadData()
    }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCollectionViewCell.identifier, for: indexPath) as! ButtonCollectionViewCell
        cell.configure(with: models[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let aWidth : CGFloat = models[indexPath.row].width(withConstraintedHeight: 0, font: UIFont.systemFont(ofSize: 17.0))
        totalWidth += aWidth
//        print(aWidth)
//        print(contentView.frame.size.width)
//        let aHeight = aWidth/contentView.frame.size.width
//        print(aHeight)
//        let height = aHeight * 20
//        print(height)
//        print(totalWidth)
//        print(indexPath.row)
        return CGSize(width: aWidth + 15 , height: 30)
    }

    func getHeight() -> CGFloat {
        return 20 * ceil( totalWidth / contentView.frame.size.height)
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
//        print("ere")

        self.collectionView.frame = CGRect(x: 0, y: 0,
                                       width: targetSize.width, height: 600)
        self.collectionView.layoutIfNeeded()

        // It Tells what size is required for the CollectionView
        return self.collectionView.collectionViewLayout.collectionViewContentSize

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("im here bud")
    }

}

extension String {

func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
    let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
    let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

    return ceil(boundingBox.width)
}
}
