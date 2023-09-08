//
//  DummyViewController.swift
//  Bankey
//
//  Created by Admin on 08/09/23.
//

import Foundation

import UIKit

class DummyViewController: UIViewController {
    
    let stackView = UIStackView()
    let lable = UILabel()
    let btnLogout = UIButton(type: .system)
    
    weak var logoutDelagate: LogoutDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
}

extension DummyViewController {
    
    func style() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.text = "Welcome"
        lable.font = UIFont.preferredFont(forTextStyle: .title1)
        
        btnLogout.translatesAutoresizingMaskIntoConstraints = false
        btnLogout.configuration = .filled()
        btnLogout.setTitle("Logout", for: [])
        btnLogout.addTarget(self, action: #selector(logoutTapped), for: .primaryActionTriggered)
    }
    
    func layout() {
        stackView.addArrangedSubview(lable)
        stackView.addArrangedSubview(btnLogout)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
}

// MARK: Action
extension DummyViewController {
 
    @objc func logoutTapped(_ sender: UIButton) {
        logoutDelagate?.didLogout()
    }
    
}
