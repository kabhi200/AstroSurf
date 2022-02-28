//
//  AstroSurfWebViewController.swift
//  AstroSurf
//
//  Created by Abhishek Kumar on 28/02/22.
//

import UIKit
import WebKit

class AstroSurfWebViewController: UIViewController, WKUIDelegate {
   
    @IBOutlet var webView: WKWebView!

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true //** Added as an example for your case
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlString = AstroSurfPhotoDetailViewModel.shared.getMediaUrl()
        let myURL = URL(string: urlString)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
}
