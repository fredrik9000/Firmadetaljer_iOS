//
//  WebViewController.swift
//  Firmadetaljer
//
//  Created by Fredrik Eilertsen on 07/05/16.
//  Copyright © 2016 Fredrik Eilertsen. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet private weak var webView: WKWebView!
    private var activityIndicator: UIActivityIndicatorView!
    var urlString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        activityIndicator.center = view.center
        activityIndicator.color = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        view.addSubview(activityIndicator)
        self.activityIndicator.startAnimating()
        
        webView.navigationDelegate = self
        let url = URL(string: urlString)!
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        handleError(error)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        handleError(error)
    }
    
    private func handleError(_ error: Error) {
        self.activityIndicator.stopAnimating()
        let alert = UIAlertController(title: NSLocalizedString("ErrorLoadingDataTitle", comment: ""),
                                      message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
