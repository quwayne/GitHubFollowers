//
//  RepoItemVC.swift
//  GitHubFollowerProject
//
//  Created by Q B on 8/8/20.
//  Copyright © 2020 Quwayne. All rights reserved.
//

import UIKit

class RepoInfoVC: ItemInfoVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        itemInfoView1.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoView2.set(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "GitHub Profile")
        
    }
    
    
    override func actionButtonTapped() {
        delegate.didTapGitHubProfile(for: user)
    }
}


