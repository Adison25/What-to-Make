//
//  SettingsViewController.swift
//  DismissTabBarDemo
//
//  Created by Diego Bustamante on 7/15/20.
//  Copyright © 2020 Diego Bustamante. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    
    lazy var scrollContentViewSize = CGSize(width: view.frame.size.width, height: view.frame.height)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupClearNavBar()
        navigationItem.title = "Filters"
        configureFilterView()
    }
    
    private func createScrollView() -> UIScrollView{
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.contentSize = scrollContentViewSize
        scrollView.backgroundColor = .clear
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false //if we dont specify this then our constraints wont be used properly
        return scrollView
    }
    
    private func createHeader(scrollView: UIScrollView, title: String)  -> UIButton{
        //ingredientsTitle
        let header = UIButton()
        header.setTitle("\(title)",for: .normal)
        //call some func that makes the size fit perfectly to how many characterrs are in the string
        header.titleLabel?.font = tableViewHeaderFont()
        header.setTitleColor(dynamicColorText, for: .normal)
        header.contentHorizontalAlignment =  UIControl.ContentHorizontalAlignment.center
        scrollView.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }
    
    private func configureFilterView() {
        let scrollView = createScrollView()
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        let timeHeader = createHeader(scrollView: scrollView, title: "Time")
        
    }
    
    private func updateScrollViewContentSize(height: CGFloat){
        scrollContentViewSize = CGSize(width: view.frame.size.width, height: view.frame.height + height)
        reloadInputViews()
    }
}
