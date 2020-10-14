//
//  FollowerListVC.swift
//  GitHubFollowerProject
//
//  Created by Q B on 7/22/20.
//  Copyright © 2020 Quwayne. All rights reserved.
//

import UIKit

protocol  FollowerListDelegate: class {
    func didRequestFollowers(for username: String)
}

class FollowerListVC: GHFDataLoadingVC {
    
    enum Section { case main }
    
    var username: String!
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var page = 1
    var hasMoreFollowers = true
    var isSearching = false
    var isLoadingMoreFollower = false
    
    var collectionView: UICollectionView!
    var datasource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
        title = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        getFollowers(username: username, page: page)
        configureSearchController()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //MARK: - Search, View and CollectionView
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self , action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseidentifier)
    }
    
    
    //MARK: - Network Call
    func getFollowers(username: String, page: Int) {
        showLoadingView()
        isLoadingMoreFollower = true
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let followers):
                self.updateInterface(with: followers)
                
            case .failure(let error):
                self.presentGHFAlertOnMainThread(message: error.rawValue, buttonTitle: buttonLabel)
            }
        }
    }
    
    
    func updateInterface(with followers: [Follower]) {
        if followers.count < 100 { self.hasMoreFollowers = false }
        self.followers.append(contentsOf: followers)
        
        if self.followers.isEmpty {
            let message = "This user does not have any followers. Go follow them :) ."
            DispatchQueue.main.async { self.showEmptyStateView(with: message, in: self.view) }
            return
        }
        self.updateData(on: self.followers )
    }
    
    //MARK: - Diffusable Data Source
    func configureDataSource() {
        datasource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseidentifier, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    
    func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async { self.datasource.apply(snapshot, animatingDifferences: true) }
    }
    
    
    @objc func addButtonTapped() {
        showLoadingView()
        
        NetworkManager.shared.getUser(for: username) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let user):
                let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
                
                PersistenceManager
                    .updateWith(favorite: favorite, actionType: .add) { [weak self] error in
                        guard let self = self else { return }
                        
                        guard let _ = error else {
                            self.presentGHFAlertOnMainThread(message: "\(user.login) is now added to your favorites.", buttonTitle: buttonLabel)
                            return
                        }
                        
                        self.presentGHFAlertOnMainThread( message: "Favorites could not be added. Please try again", buttonTitle: buttonLabel)
                }
            case .failure(let error):
                self.presentGHFAlertOnMainThread(message: error.rawValue, buttonTitle: buttonLabel)
            }
            
        }
        
    }
    
    
    func addUserToFavorites(user: User) {
        let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
        
        PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
            guard let self = self else { return }
            
            guard let _ = error else {
                self.presentGHFAlertOnMainThread(message: "You have successfully favorited this user 🎉", buttonTitle: "Hooray!")
                return
            }
            
            self.presentGHFAlertOnMainThread(message: "Sorry", buttonTitle: "Ok")
        }
    }
}



//MARK: - Extensions
extension FollowerListVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let offset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offset > contentHeight - height {
            guard hasMoreFollowers else { return }
            page += 1
            getFollowers(username: username, page: page)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentArray = isSearching ? filteredFollowers : followers
         let follower =                                currentArray[indexPath.item]
        let destVC = UserInfoVC()
        destVC.username = follower.login
        destVC.delegate = self
        let navigationController = UINavigationController(rootViewController: destVC)
        present(navigationController, animated: true)
        
    }
    
}
    
extension FollowerListVC: UISearchResultsUpdating, UISearchBarDelegate {
        
        func updateSearchResults(for searchController: UISearchController) {
            isSearching = true
            guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
            filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
            updateData(on: filteredFollowers)
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            isSearching = false
            updateData(on: followers)
           
        }
}


extension FollowerListVC: FollowerListDelegate {
    
    func didRequestFollowers(for username: String) {
        self.username = username
        title = username
        page = 1
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.setContentOffset(.zero, animated: true)
        getFollowers(username: username, page: page)
    }
}

