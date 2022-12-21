//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Юрченко Артем on 20.12.2022.
//

import UIKit

class AuthViewController: UIViewController {
    
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var unsplashLogo: UIImageView!
    @IBOutlet private weak var signInButton: UIButton!
    // MARK: - Public Properties
    
   private let webViewIdentifier = "ShowWebView"
    // MARK: - Private Properties
    // MARK: - Lifecycle
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == webViewIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(webViewIdentifier)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Private Methods
    // MARK: - IBActions
    // MARK: - Table View Data Source
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        //TODO: process code
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
