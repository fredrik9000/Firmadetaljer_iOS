//
//  WebViewController.swift
//  Firmadetaljer
//
//  Created by Fredrik Eilertsen on 07/05/16.
//  Copyright © 2016 Fredrik Eilertsen. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    var urlString: String!
    private var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        activityIndicator.center = view.center
        activityIndicator.color = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        view.addSubview(activityIndicator)
        self.activityIndicator.startAnimating()
        webView.delegate = self
        let url = URL(string: urlString)!
        let urlRequest = URLRequest(url: url)
        webView.loadRequest(urlRequest)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.activityIndicator.stopAnimating()
        let alert = UIAlertController(title: NSLocalizedString("ErrorLoadingDataTitle", comment: ""), message: NSLocalizedString("ErrorLoadingDataMessage", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
