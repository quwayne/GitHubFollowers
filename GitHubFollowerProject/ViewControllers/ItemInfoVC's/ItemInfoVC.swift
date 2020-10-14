//
//  ItemInfoVC.swift
//  GitHubFollowerProject
//
//  Created by Q B on 8/7/20.
//  Copyright © 2020 Quwayne. All rights reserved.
//

import UIKit

class ItemInfoVC: UIViewController {

     let stackView = UIStackView()
     let itemInfoView1 = ItemInfoView()
     let itemInfoView2 = ItemInfoView()
     let actionButton = GHFButton()
    
    var user: User!
    
    weak var delegate: UserInfoDelegate!
    
    init(user: User) {
      super.init(nibName: nil, bundle: nil)
        self.user = user
    }

    override func viewDidLoad() {
      super.viewDidLoad()
        configureBackgroundView()
         configureActionButton()
          configureStackView()
              configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    private func configureBackgroundView() {
        view.layer.cornerRadius = 18
        view.backgroundColor = .secondarySystemBackground
    }
    
    
    private func configureStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
    
        
        stackView.addArrangedSubview(itemInfoView1)
        stackView.addArrangedSubview(itemInfoView2)
    }
    
    private func configureActionButton() {
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }
    
    @objc func actionButtonTapped() {
        
    }
    
    
    private func configureUI() {
        view.addSubview(stackView)
        view.addSubview(actionButton)
        
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        actionButton.layer.cornerRadius = 18
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 50),
             
            
            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
           actionButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

}
