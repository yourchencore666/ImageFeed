//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Юрченко Артем on 20.12.2022.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private weak var webView: WKWebView!
    

    
    // MARK: - Public Properties
    // MARK: - Private Properties
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var urlComponents = URLComponents(string: defaultBaseUrl!.absoluteString)!
        urlComponents.queryItems = [
        URLQueryItem(name: "client_id", value: accessKey),
        URLQueryItem(name: "redirect_uri", value: redirectUri),
        URLQueryItem(name: "response_type", value: "code"),
        URLQueryItem(name: "scope", value: accessScope)
        ]
        let url = urlComponents.url!
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    // MARK: - Private Methods
    // MARK: - IBActions
    @IBAction func didTapBackButton(_ sender: Any) {
    }
    
    // MARK: - Table View Data Source
}
