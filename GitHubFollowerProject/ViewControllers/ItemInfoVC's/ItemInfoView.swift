//
//  ItemInfoView.swift
//  GitHubFollowerProject
//
//  Created by Q B on 8/7/20.
//  Copyright © 2020 Quwayne. All rights reserved.
//

import UIKit

enum ItemInfoType {
    case repos, gists, followers, following
}


class ItemInfoView: UIView {
    
    let symbolImageView = UIImageView()
    let titleLabel = GHFTitleLabel(textAlignment: .center, fontSize: 14)
    let countLabel = GHFTitleLabel(textAlignment: .center, fontSize: 14)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        addSubview(symbolImageView)
        addSubview(titleLabel)
        addSubview(countLabel)
        
        symbolImageView.translatesAutoresizingMaskIntoConstraints = false
        symbolImageView.contentMode = .scaleAspectFill
        symbolImageView.tintColor = .label
        
        
        
        symbolImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        symbolImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        symbolImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        symbolImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        titleLabel.centerYAnchor.constraint(equalTo: symbolImageView.centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: 12).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        
        countLabel.topAnchor.constraint(equalTo: symbolImageView.bottomAnchor, constant:  4).isActive = true
        countLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        countLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        countLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
    }
    
    func set(itemInfoType: ItemInfoType, withCount count: Int) {
        switch itemInfoType {
        case .repos:
            symbolImageView.image   = SFSymbols.repos
            titleLabel.text         = "Public Repos"
        case .gists:
            symbolImageView.image   = SFSymbols.gists
            titleLabel.text         = "Public Gists"
        case .followers:
            symbolImageView.image   = SFSymbols.followers
            titleLabel.text         = "Followers"
        case .following:
            symbolImageView.image   = SFSymbols.following
            titleLabel.text         = "Following"
        }
        
        countLabel.text = String(count)
    }
}
