//
//  UserInfoVC.swift
//  GitHubFollowerProject
//
//  Created by Q B on 8/6/20.
//  Copyright © 2020 Quwayne. All rights reserved.
//

import UIKit

class UserInfoVC: UIViewController {
    
    let headerView = UIView()
    let itemView1  = UIView()
    let itemView2  = UIView()
    var itemViews: [UIView] = []
    
    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        configureUI()
        
        NetworkManager.shared.getUser(for: username) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.add(childVC: GHFUserHeaderVC(user: user), to: self.headerView)
                    
                    
                }
            
            case .failure(let error):
                self.presentGHFALertOnMainThread(title: "Could not load user data", message: error.rawValue, buttonTitle: buttonLabel)
            }
        }
    }
    
    
    func configureViewController() {
        
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem:
            .done, target: self, action: #selector(popVC))
        navigationItem.rightBarButtonItem = doneButton
    }
   
    func  configureUI() {
        
        itemViews = [itemView1, headerView, itemView2]
        
        for itemView in itemViews {
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
        }
        
        
        headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        itemView2.backgroundColor = .systemRed
        itemView1.backgroundColor = .systemBlue
        
        
        itemView1.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20).isActive = true
        itemView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        itemView1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        itemView1.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        
        itemView2.topAnchor.constraint(equalTo: itemView1.bottomAnchor, constant: 20).isActive = true
        itemView2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        itemView2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        itemView2.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
    }
   
    func add(childVC: UIViewController, to container: UIView) {
        
        addChild(childVC)
        container.addSubview(childVC.view)
        childVC.view.frame = container.bounds
        childVC.didMove(toParent: self)
    }
    
    @objc func popVC() {
        dismiss(animated: true)
    }
}
