//
//  UserSearchVC.swift
//  GitHubFollowerProject
//
//  Created by Q B on 7/22/20.
//  Copyright © 2020 Quwayne. All rights reserved.
//

import UIKit

class UserSearchVC: UIViewController {

    let logoImageView = UIImageView()
    let usernameTextField = GHFTextField()
    let actionButton = GHFButton(backgroundColor: .systemGreen, title: "Get Followers")
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubviews(logoImageView, usernameTextField, actionButton)
        configureLogoImageView()
        configureTextField()
        configureActionButton()
        dismissKeyboardTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        usernameTextField.text = ""
        navigationController?.setNavigationBarHidden(true, animated: true) 
    }
    
    var logoImageViewTopConstraint:NSLayoutConstraint!
    
    func configureLogoImageView() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = Images
            .ghLogo
        
        let topConstraintContraint: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 20 : 80
        
        
        logoImageViewTopConstraint = logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstraintContraint)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
   
    var usernameEntered: Bool { return !usernameTextField.text!.isEmpty }

    func configureTextField() {
        usernameTextField.delegate = self
        
        usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 40).isActive = true
        usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func configureActionButton() {
        actionButton.addTarget(self, action: #selector(pushFollowersList), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            actionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    @objc func pushFollowersList() {
        guard usernameEntered else {
            presentGHFAlertOnMainThread(message: "Please enter a username. We need to know who to look for ;) ", buttonTitle: buttonLabel)
            return
        }
        
        usernameTextField.resignFirstResponder()
        
        let followerListVC = FollowerListVC(username: usernameTextField.text!)
        navigationController?.pushViewController(followerListVC, animated: true)
    }
   
    
    func dismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
}



extension UserSearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowersList()
        return true
    }
}
