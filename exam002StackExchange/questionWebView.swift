//
//  questionWebView.swift
//  exam002StackExchange
//
//  Created by Arkadiy Akimov on 17/08/2022.
//

import UIKit
import WebKit

class questionWebView : UIViewController, WKNavigationDelegate {
    var questionURL : URL!
    var webView : WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        view.addSubview(webView)
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updatePage()
    }
    
    func updatePage(){
        webView.load(URLRequest(url: questionURL))
    }
}
