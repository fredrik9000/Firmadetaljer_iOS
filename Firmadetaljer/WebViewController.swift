//
//  WebViewController.swift
//  Firmadetaljer
//
//  Created by Fredrik Eilertsen on 07/05/16.
//  Copyright © 2016 Fredrik Eilertsen. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var urlString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: urlString)!
        let urlRequest = URLRequest(url: url)
        webView.loadRequest(urlRequest)
    }
}
