//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Юрченко Артем on 23.12.2022.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let oAuthService = OAuth2Service()
    private let oAuthTokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let alertController = AlertViewController()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkAuthorization()
        
    }
    
    private func switchToTabBarController() {
        // Получаем экземпляр `Window` приложения
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        // Cоздаём экземпляр нужного контроллера из Storyboard с помощью ранее заданного идентификатора.
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
    private func checkAuthorization() {
        
        if let token = oAuthTokenStorage.token {
            switchToTabBarController()
            fetchProfile(token: token)
        } else {
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Проверим что переходим на авторизацию
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            // Добираемся до первого контроллера в навигации
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {fatalError("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)")}
            // установим делегатом контроллера наш SplashViewController
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                UIBlockingProgressHUD.dismiss()
                self.fetchOAuthToken(code)
            }
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oAuthService.fetchOAuthToken(code) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let token):
                    self.switchToTabBarController()
                    self.fetchProfile(token: token)
                case .failure:
                    UIBlockingProgressHUD.dismiss()
                    self.showError()
                }
            }
        }
    }
    
    private func fetchProfile(token: String) {
            profileService.fetchProfile(token) { [weak self] result in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    switch result {
                    case .success:
                        ProfileImageService.shared.fetchProfileImageURL(self.profileService.profile?.username ?? "nil") { result in
                            switch result {
                            case .success(let avatarURL):
                                self.profileImageService.setAvatarUrlString(avatarUrl: avatarURL)
                            case .failure:
                                return
                            }
                        }
                        self.switchToTabBarController()
                    case .failure:
                        self.showError()
                        break
                    }
                }
            }
        }
    
    private func showError() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            let alertModel = AlertModel(title: "Что-то пошло не так", message: "Не удалось войти в систему", buttonText: "Ок") {
               
            }
            self.alertController.showAlert(vc: self, model: alertModel)
        }
    }
}
