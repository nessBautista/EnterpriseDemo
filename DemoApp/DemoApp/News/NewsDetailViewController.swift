//
//  NewsDetailViewController.swift
//  DemoApp
//
//  Created by Nestor Hernandez on 9/9/18.
//  Copyright © 2018 Nestor Hernandez. All rights reserved.
//

import UIKit
import WebKit
class NewsDetailViewController: UIViewController, WKUIDelegate {

    var strURL = String()
    var webView: WKWebView!
    
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myURL = URL(string:strURL)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
}
