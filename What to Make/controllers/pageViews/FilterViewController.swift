//
//  SettingsViewController.swift
//  DismissTabBarDemo
//
//  Created by Diego Bustamante on 7/15/20.
//  Copyright © 2020 Diego Bustamante. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate {
    
//    lazy var scrollContentViewSize = CGSize(width: view.frame.size.width, height: view.frame.height)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        createStackView()
    }
    
    private func createStackView() {
        
        let section1 = createInerSectionStackView(title: "Time")
        let section2 = createInerSectionStackView(title: "Dish Type")
        let section3 = createInerSectionStackView(title: "Dietary")
        
        let stackView = UIStackView(arrangedSubviews: [section1,section2,section3])
        stackView.frame = view.bounds
        stackView.backgroundColor = .orange
        //config
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
//        stackView.spacing = 20
        view.addSubview(stackView)
    }
    
    
    //create the 2 sections on a stack view
    private func createInerSectionStackView(title: String) -> UIStackView{
        let header = UILabel()
        header.backgroundColor = .red
        header.text = "\(title)"
        header.textColor = dynamicColorText
        header.font = tableViewHeaderFont()
        
        let buttonStackView = createButtonStackView()
        
        let stackView = UIStackView(arrangedSubviews: [header,buttonStackView])
        stackView.frame = view.bounds
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        return stackView
    }
    
    private func createButtonStackView() -> UIStackView {

        let button1 = createButton(title: "Under 15 Min")
        let button2 = createButton(title: "Under 15 Min")
        let button3 = createButton(title: "Under 15 Min")
//        let button4 = createButton(title: "Under 15 Min")
//        let button5 = createButton(title: "Under 15 Min")
//        let button6 = createButton(title: "Under 15 Min")
//        let button7 = createButton(title: "Under 15 Min")

        let stackView = UIStackView(arrangedSubviews: [button1,button2,button3]) //[button1,button2,button3,button4,button5,button6,button7])
        stackView.backgroundColor = .blue
        stackView.frame = view.bounds
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
//        stackView.alignment = .fill
        stackView.spacing = 5
        return stackView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.contentView.backgroundColor = .blue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    
    private func createButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle("\(title)", for: .normal)
        button.titleLabel?.font = buttonFont()
        button.setTitleColor(dynamicColorText, for: .normal)
        button.backgroundColor = .purple
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = dynamicColorBackground
        button.layer.cornerRadius = 20
        return button
    }
    
//    private func createScrollView() -> UIScrollView{
//        let scrollView = UIScrollView(frame: view.bounds)
//        scrollView.contentSize = scrollContentViewSize
//        scrollView.backgroundColor = .clear
//        view.addSubview(scrollView)
//        scrollView.translatesAutoresizingMaskIntoConstraints = false //if we dont specify this then our constraints wont be used properly
//        return scrollView
//    }
//
//    private func createHeader(scrollView: UIScrollView, title: String)  -> UIButton{
//        //ingredientsTitle
//        let header = UIButton()
//        header.setTitle("\(title)",for: .normal)
//        //call some func that makes the size fit perfectly to how many characterrs are in the string
//        header.titleLabel?.font = tableViewHeaderFont()
//        header.setTitleColor(dynamicColorText, for: .normal)
//        header.contentHorizontalAlignment =  UIControl.ContentHorizontalAlignment.center
//        scrollView.addSubview(header)
//        header.translatesAutoresizingMaskIntoConstraints = false
//        return header
//    }
//
//    private func configureFilterView() {
//        let scrollView = createScrollView()
//        NSLayoutConstraint.activate([
//            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
//        ])
//        let timeHeader = createHeader(scrollView: scrollView, title: "Time")
//        NSLayoutConstraint.activate([
//            timeHeader.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
//            timeHeader.leftAnchor.constraint(equalTo: scrollView.leftAnchor,constant: 20)
//        ])
//    }
//
//    private func updateScrollViewContentSize(height: CGFloat){
//        scrollContentViewSize = CGSize(width: view.frame.size.width, height: view.frame.height + height)
//        reloadInputViews()
//    }
}
