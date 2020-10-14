//
//  GHFUserHeaderVC.swift
//  GitHubFollowerProject
//
//  Created by Q B on 8/6/20.
//  Copyright © 2020 Quwayne. All rights reserved.
//

import UIKit

class GHFUserHeaderVC: UIViewController {
    
    let avatarImageView = GHFAvatarImageView(frame: .zero)
    let usernameLabel = GHFTitleLabel(textAlignment: .left, fontSize: 34)
    let nameLabel = GHFSecondaryLabel(fontSize: 18)
    let locationImageView = UIImageView()
    let locationLabel = GHFSecondaryLabel(fontSize: 18)
    let bioLabel = GHFBodyLabel(textAlignment: .left)

    var user: User!
    
    init(user: User) {
      super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIElements()
           addSubViews()
           configureUI()
    }
    
    
    func configureUIElements() {
        avatarImageView.downloadImage(from: user.avatarUrl)
        
        usernameLabel.text = user.login
        nameLabel.text = user.name ?? ""
        
        locationImageView.image = SFSymbols.location
        locationImageView.tintColor = .secondaryLabel
        locationLabel.text = user.location ?? ""
       
        bioLabel.text = user.bio ?? "No bio available"
        bioLabel.numberOfLines = 3
    }
    

   func addSubViews() {
        view.addSubview(avatarImageView)
        view.addSubview(usernameLabel)
        view.addSubview(nameLabel)
        view.addSubview(locationImageView)
        view.addSubview(locationLabel)
        view.addSubview(bioLabel)
    }
    
    func configureUI() {
        let padding: CGFloat = 20
        let smallPadding: CGFloat = 12
        locationImageView.translatesAutoresizingMaskIntoConstraints = false
       
        avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding).isActive = true
        avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 90).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        
        usernameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor).isActive = true
        usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: smallPadding).isActive = true
        usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor, constant: 8).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: smallPadding).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: padding).isActive = true
        
        
        locationImageView.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor).isActive = true
        locationImageView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: smallPadding).isActive = true
     locationImageView.widthAnchor.constraint(equalToConstant: padding).isActive = true
        
        
        
        locationLabel.centerYAnchor.constraint(equalTo: locationImageView.centerYAnchor).isActive = true
        locationLabel.leadingAnchor.constraint(equalTo: locationImageView.trailingAnchor, constant: 5).isActive = true
        locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
    locationLabel.heightAnchor.constraint(equalToConstant: padding).isActive = true
        
        
        bioLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: smallPadding).isActive = true
        bioLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor).isActive = true
        bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
        bioLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
}
