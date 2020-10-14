//
//  GHFAlertVC.swift
//  GitHubFollowerProject
//
//  Created by Q B on 7/23/20.
//  Copyright © 2020 Quwayne. All rights reserved.
//

import UIKit

class GHFAlertVC: UIViewController {

    let containerView = GHFAlertContainerView()
    let messageLabel = GHFBodyLabel(textAlignment: .center)
    let actionButton = GHFButton(backgroundColor: .systemPink , title: "Ok")
    
   
    var message: String?
    var buttonTitle: String?
    
    let padding: CGFloat = 20
    
    init( message: String, buttonTitle: String) {
        super.init(nibName: nil, bundle: nil)
        self.message = message
        self.buttonTitle = buttonTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        
        configureContainerView()
        configureActionButton()
        configureMessageLabel()
        }
    
    //MARK: - Configure
    func configureContainerView() {
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
        
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    
    func configureMessageLabel() {
        containerView.addSubview(messageLabel)
        
        messageLabel.text = message ?? "Unable to complete request"
        messageLabel.numberOfLines = 4
        
        NSLayoutConstraint.activate([
           
            messageLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,constant: -padding),
            messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -12)
        ])
    }
    
    
    func configureActionButton() {
        containerView.addSubview(actionButton)
        actionButton.setTitle(buttonTitle ?? "OK", for: .normal)
        actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
        
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: padding + 24)
        ])
    }

   @objc func dismissVC() {
        dismiss(animated: true)
    }
}
