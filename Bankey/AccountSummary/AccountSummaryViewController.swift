//
//  AccountSummaryViewController.swift
//  Bankey
//
//  Created by Admin on 09/09/23.
//

import Foundation
import UIKit

class AccountSummaryViewController: UIViewController {
  
  // Requst Model
  var profile: Profile?
  var accounts: [Account] = []
  
  // View Model
  var header = AccountSummaryheaderView.ViewModel(
    welcomeMessage: "Welcome", name: "", date: Date()
  )
  var accountsCellViewModels: [AccountSummaryViewCell.ViewModel] = []
  
  // componennts
  var tableView = UITableView()
  var headerView = AccountSummaryheaderView(frame: .zero)
  let refreshControl = UIRefreshControl()
  
  lazy var logoutBarButtonItem: UIBarButtonItem = {
    let barButtonItem = UIBarButtonItem(
      title: "Logout", style: .plain, target: self, action: #selector(logoutTapped)
    )
    barButtonItem.tintColor = .label
    return barButtonItem
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    style()
    layout()
  }
}

extension AccountSummaryViewController {
  
  func setup() {
    setupNavigationBar()
    setupTableView()
    setupHeaderView()
    setupRefreshControl()
    fetchData()
  }
  
  private func setupNavigationBar() {
    navigationItem.rightBarButtonItem = logoutBarButtonItem
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
    var size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    
    size.width = UIScreen.main.bounds.width
    headerView.frame.size = size
    
    tableView.tableHeaderView = headerView
  }
  
  private func setupRefreshControl() {
    refreshControl.tintColor = appColor
    refreshControl.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
    tableView.refreshControl = refreshControl
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
    return accountsCellViewModels.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard !accountsCellViewModels.isEmpty, let cell = tableView.dequeueReusableCell(
      withIdentifier: AccountSummaryViewCell.reuseID,
      for: indexPath
    ) as? AccountSummaryViewCell else {
      return UITableViewCell()
    }
    let account = accountsCellViewModels[indexPath.row]
    cell.configure(with: account)
    
    return cell
  }
  
}

extension AccountSummaryViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
}

// MARK: Networking
extension AccountSummaryViewController {
  private func fetchData() {
    let group = DispatchGroup()
    
    // Testing-random number selection
    let userId = String(Int.random(in: 1..<4))
    
    group.enter()
    fetchProfile(forUserId: userId) { result in
      switch result {
      case .success(let profile):
        self.profile = profile
        self.configureTableHeaderView(with: profile)
        
      case .failure(let error):
        print(error.localizedDescription)
      }
      
      group.leave()
    }
    
    group.enter()
    fetchAccounts(forUserId: userId) { result in
      switch result {
      case .success(let accounts):
        self.accounts = accounts
        self.configureTableCells(with: accounts)
        
      case .failure(let error):
        print(error.localizedDescription)
      }
      
      group.leave()
    }
    
    group.notify(queue: .main) {
      self.tableView.reloadData()
      self.tableView.refreshControl?.endRefreshing()
    }
  }
  
  private func configureTableHeaderView(with profile: Profile) {
    let vm = AccountSummaryheaderView.ViewModel(
      welcomeMessage: "Good Morning, ", name: profile.firstName, date: Date()
    )
    
    headerView.configure(viewModel: vm)
  }
  
  private func configureTableCells(with accounts: [Account]) {
    accountsCellViewModels = accounts.map {
      AccountSummaryViewCell.ViewModel(
        accountType: $0.type, accountName: $0.name, balance: $0.amount
      )
    }
  }
}

// MARK: Actions
extension AccountSummaryViewController {
  
  @objc func logoutTapped(sender: UIButton) {
    NotificationCenter.default.post(
      name: .logout, object: nil
    )
  }
  
  @objc func refreshContent() {
    fetchData()
  }
}
