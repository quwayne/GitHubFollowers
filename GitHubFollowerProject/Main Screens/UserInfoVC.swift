//
//  UserInfoVC.swift
//  GitHubFollowerProject
//
//  Created by Q B on 8/9/20.
//  Copyright © 2020 Quwayne. All rights reserved.
//

import UIKit

protocol UserInfoDelegate: class {
    func didTapGitHubProfile(for user: User)
    func didTapGetFollowers(for user: User)
}


class UserInfoVC: GHFDataLoadingVC {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    
    let headerView = UIView()
    let itemView1 = UIView()
    let itemView2 = UIView()
    let dateLabel = GHFBodyLabel(textAlignment: .center)
    var itemViews: [UIView] = []
    var isSearching = false
    
    var username: String!
    weak var delegate: FollowerListDelegate!
    

    override func viewDidLoad() {
        super.viewDidLoad()
      configureViewController()
        configureScrollView()
           getUserInfo()
            layoutUI()
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismssVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
        
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 600)
        ])
        
    }
    
    
    func getUserInfo() {
        NetworkManager.shared.getUser(for: username) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
             case .success(let user):
                DispatchQueue.main.async { self.configureUIElements(with: user) }
                
            case .failure(let error):
                self.presentGHFAlertOnMainThread(message: error.rawValue, buttonTitle: buttonLabel)
            }
        }
    }
    
    
    func configureUIElements(with user: User) {
        let repoItemVC = RepoInfoVC(user: user)
        repoItemVC.delegate = self
        
        let followerItemVC = FollowerItemVC(user: user)
        followerItemVC.delegate = self
        
        self.add(childVC: repoItemVC, to: self.itemView1)
        self.add(childVC: followerItemVC, to: self.itemView2)
        self.add(childVC: GHFUserHeaderVC(user: user), to: self.headerView)
        self.dateLabel.text = "Member since \(user.createdAt.convertToMonthYearFormat())"
    }
    
    
    func layoutUI() {
        let padding: CGFloat    = 20
        let itemHeight: CGFloat = 140
        
        itemViews = [headerView, itemView1, itemView2, dateLabel]
        
        for itemView in itemViews {
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            ])
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 210),
            
            itemView1.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemView1.heightAnchor.constraint(equalToConstant: itemHeight),
            
            
            itemView2.heightAnchor.constraint(equalToConstant: itemHeight),
            itemView2.topAnchor.constraint(equalTo: itemView1.bottomAnchor, constant: padding),
            
            
            dateLabel.topAnchor.constraint(equalTo: itemView2.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: padding)
        ])
    }
    
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    
    @objc func dismssVC() {
        dismiss(animated: true)
    }
}

extension UserInfoVC: UserInfoDelegate {
    func didTapGitHubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentGHFAlertOnMainThread( message: "Unable to get URL.", buttonTitle: buttonLabel)
            return
        }
        
        presentSafariVC(with: url)
    }
    
    func didTapGetFollowers(for user: User) {
        guard user.followers != 0 else {
            presentGHFAlertOnMainThread(message: "This user has no followers. What a shame 😞.", buttonTitle: buttonLabel)
            return
        }
        
        delegate.didRequestFollowers(for: user.login)
        dismssVC()
    }
}

extension UserInfoVC: UISearchResultsUpdating, UISearchBarDelegate {
    

    func updateSearchResults(for searchController: UISearchController) {
        isSearching = true
        guard let newUser = searchController.searchBar.text, !newUser.isEmpty else { return }
        
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
       
    }

}
