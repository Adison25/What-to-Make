//
//  WebViewViewController.swift
//  What to Make
//
//  Created by Adison Emerick on 7/25/21.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController {

    private let webView: WKWebView = {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences
        let webView = WKWebView(frame: .zero, configuration: configuration)
        return webView
    }()
    
    private let url: URL
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        webView.load(URLRequest(url: url))
        configureButtons()
     }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
        webView.load(URLRequest(url: url))
    }
    
    private func configureButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDone))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(didTapRefresh))
    }

    @objc private func didTapDone(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapRefresh(){
        webView.load(URLRequest(url: url))
    }
    
}
