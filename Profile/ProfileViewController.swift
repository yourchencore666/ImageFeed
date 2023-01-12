//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Юрченко Артем on 06.12.2022.
//

import UIKit

final class ProfileViewController: UIViewController {

    // MARK: - Private Properties
    private let profileImageView = UIImageView()
    private let userNameLabel = UILabel()
    private let nickNameLabel = UILabel()
    private let userDescriptionLabel = UILabel()
    private let logoutButton = UIButton(type: .system)
    private let oAuthStorage = OAuth2TokenStorage()
    private var userProfileData: ProfileService.Profile?
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let token = self.oAuthStorage.token ?? "No token"
        
        setProfileImage()
        setUserNameLabel()
        setNickNameLabel()
        setUserDescriptionLabel()
        setLogoutButton()
        fetchProfile(token: token)
    }
    // MARK: - Private Methods
    private func setProfileImage() {
        profileImageView.image = UIImage(named: "UserPhoto")
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    private func setUserNameLabel() {
        userNameLabel.text = "Unknown"
        userNameLabel.textColor = .white
        userNameLabel.font = UIFont.systemFont(ofSize: 23, weight: UIFont.Weight(rawValue: 0.5))
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userNameLabel)
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            userNameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor)
        ])
    }
    
    private func setNickNameLabel() {
        nickNameLabel.text = "@unknown"
        nickNameLabel.textColor = UIColor(named: "YP Gray")
        nickNameLabel.font = UIFont(name: "YS Display-Medium", size: 13)
        nickNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nickNameLabel)
        NSLayoutConstraint.activate([
            nickNameLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8),
            nickNameLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor)
        ])
    }
    
    private func setUserDescriptionLabel() {
        userDescriptionLabel.text = "description"
        userDescriptionLabel.textColor = .white
        userDescriptionLabel.font = UIFont(name: "YS Display-Medium", size: 13)
        userDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userDescriptionLabel)
        NSLayoutConstraint.activate([
            userDescriptionLabel.topAnchor.constraint(equalTo: nickNameLabel.bottomAnchor, constant: 8),
            userDescriptionLabel.leadingAnchor.constraint(equalTo: nickNameLabel.leadingAnchor)
        ])
    }
    
    private func setLogoutButton() {
        logoutButton.setImage(UIImage(systemName: "ipad.and.arrow.forward"), for: .normal)
        logoutButton.tintColor = UIColor(named: "YP Red")
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        NSLayoutConstraint.activate([
            logoutButton.widthAnchor.constraint(equalToConstant: 20),
            logoutButton.heightAnchor.constraint(equalToConstant: 22),
            logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 56),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26)
        ])
    }
    
    private func fetchProfile (token: String) {
           ProfileService().fetchProfile(token) { result in
               switch result {
               case .success (let profile):
                   self.userProfileData = profile
                   self.userNameLabel.text = profile.name
                   self.nickNameLabel.text = profile.loginName
                   self.userDescriptionLabel.text = profile.bio
                   return
               case .failure(let error):
                   print("❌\(error)")
                   return
                   
               }

           }
       }
    
}

