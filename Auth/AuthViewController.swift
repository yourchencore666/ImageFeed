//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Юрченко Артем on 20.12.2022.
//

import UIKit

final class AuthViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var unsplashLogo: UIImageView!
    @IBOutlet private weak var signInButton: UIButton!
    
    // MARK: - Public Properties
    weak var delegate: AuthViewControllerDelegate?
    
    // MARK: - Private Properties
    private let webViewIdentifier = "ShowWebView"
    private let oAuthService = OAuth2Service()
    private let oAuthStorage = OAuth2TokenStorage()
    
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
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        oAuthService.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else {return}
            
            switch result {
                
            case .success(let token):
                self.oAuthStorage.token = token
                self.delegate?.authViewController(self, didAuthenticateWithCode: code)
                print("your token: \(token)")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}
