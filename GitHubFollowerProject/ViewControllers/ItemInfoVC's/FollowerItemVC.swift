//
//  FollowerItemVC.swift
//  GitHubFollowerProject
//
//  Created by Q B on 8/9/20.
//  Copyright © 2020 Quwayne. All rights reserved.
//

import UIKit

class FollowerItemVC: ItemInfoVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    override func actionButtonTapped() {
        delegate.didTapGetFollowers(for: user)
    }
    
    
    private func configureItems() {
        itemInfoView1.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoView2.set(itemInfoType: .following, withCount: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "GitHub Followers")
    }
}
