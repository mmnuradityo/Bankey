//
//  AccountSummaryViewController.swift
//  Bankey
//
//  Created by Admin on 09/09/23.
//

import Foundation
import UIKit

class AccountSummaryViewController: UIViewController {
    
    var accounts: [AccountSummaryViewCell.ViewModel] = []
    
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        style()
        layout()
    }
}

extension AccountSummaryViewController {
    
    func setup() {
        setupTableView()
        setupHeaderView()
        fetchData()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(AccountSummaryViewCell.self, forCellReuseIdentifier: AccountSummaryViewCell.reuseID)
        tableView.rowHeight = AccountSummaryViewCell.rowHeight
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = appColor
    }
    
    private func setupHeaderView() {
        let header = AccountSummaryheaderView(frame: .zero)
        var size = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        size.width = UIScreen.main.bounds.width
        header.frame.size = size
        
        tableView.tableHeaderView = header
    }
    
    func style() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func layout() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
}


extension AccountSummaryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !accounts.isEmpty, let cell = tableView.dequeueReusableCell(
            withIdentifier: AccountSummaryViewCell.reuseID,
            for: indexPath
        ) as? AccountSummaryViewCell else {
            return UITableViewCell()
        }
        let account = accounts[indexPath.row]
        cell.configure(with: account)
        
        return cell
    }

}

extension AccountSummaryViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension AccountSummaryViewController {
    
    func fetchData() {
        let savings = AccountSummaryViewCell.ViewModel(
            accountType: .Banking, accountName: "Basic Savings", balance: 929466.23
        )
        let chequing = AccountSummaryViewCell.ViewModel(
            accountType: .Banking, accountName: "No-Fee All-In Chequing", balance: 17562.44
        )
        let visa = AccountSummaryViewCell.ViewModel(
            accountType: .CreditCard, accountName: "Visa Avion Card", balance: 412.83
        )
        let masterCard = AccountSummaryViewCell.ViewModel(
            accountType: .CreditCard, accountName: "Student Mastercard", balance: 50.83
        )
        let investment1 = AccountSummaryViewCell.ViewModel(
            accountType: .Investment, accountName: "Tax-Free Saver", balance: 2000.00
        )
        let investment2 = AccountSummaryViewCell.ViewModel(
            accountType: .Investment, accountName: "Growth Fund", balance: 15000.00
        )
        
        accounts.append(savings)
        accounts.append(chequing)
        accounts.append(visa)
        accounts.append(masterCard)
        accounts.append(investment1)
        accounts.append(investment2)
    }
    
}
