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
  
  // Networking
  var profileManger: ProfileManageable = ProfileMagener()
  
  // Error alert
  lazy var errorAlert: UIAlertController = {
    let alert =  UIAlertController(title: "", message: "", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    return alert
  }()
  
  var isLoaded = false
  
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
    setupSkeletons()
    fetchData()
  }
  
  private func setupNavigationBar() {
    navigationItem.rightBarButtonItem = logoutBarButtonItem
  }
  
  private func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.register(AccountSummaryViewCell.self, forCellReuseIdentifier: AccountSummaryViewCell.reuseID)
    tableView.register(SkeletonCell.self, forCellReuseIdentifier: SkeletonCell.reuseID)
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
  
  private func setupSkeletons() {
    let row = Account.makeSkeleton()
    accounts = Array(repeating: row, count: 10)
    
    configureTableCells(with: accounts)
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
    guard !accountsCellViewModels.isEmpty else { return UITableViewCell() }
    let account = accountsCellViewModels[indexPath.row]
    
    if isLoaded {
      let cell = tableView.dequeueReusableCell(
        withIdentifier: AccountSummaryViewCell.reuseID,
        for: indexPath
      ) as! AccountSummaryViewCell
      cell.configure(with: account)
      return cell
    }
    
    let cell = tableView.dequeueReusableCell(
      withIdentifier: SkeletonCell.reuseID, for: indexPath
    ) as! SkeletonCell
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
    
    fetchProfile(group: group, userId: userId)
    fetchAccoounts(group: group, userId: userId)
    
    group.notify(queue: .main) {
      self.reloadView()
    }
  }
  
  private func fetchProfile(group: DispatchGroup, userId: String) {
    group.enter()
    profileManger.fetchProfile(forUserId: userId) { result in
      switch result {
      case .success(let profile):
        self.profile = profile
        
      case .failure(let error):
        self.dispalyError(error)
      }
      
      group.leave()
    }
    
  }
  
  private func fetchAccoounts(group: DispatchGroup, userId: String) {
    group.enter()
    fetchAccounts(forUserId: userId) { result in
      switch result {
      case .success(let accounts):
        self.accounts = accounts
        
      case .failure(let error):
        self.dispalyError(error)
      }
      
      group.leave()
    }
  }
  
  private func reloadView() {
    
    self.tableView.refreshControl?.endRefreshing()
    
    guard let profile = self.profile else { return }
    
    self.isLoaded = true
    self.configureTableHeaderView(with: profile)
    self.configureTableCells(with: self.accounts)
    
    self.tableView.reloadData()
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
  
  private func dispalyError(_ error: NetworkError) {
    let titleAndMessage = titleAndMessage(for: error)
    self.showErrorAlert(title: titleAndMessage.0, message: titleAndMessage.1)
  }
  
  private func titleAndMessage(for error: NetworkError) -> (String, String){
    let title: String
    let message: String
    
    switch error {
    case .decodingError:
      title = "Network Error"
      message = "Ensure you are connected to the internet. Please try again."
    case .severError:
      title = "Server Error"
      message = "We could not process your request. Please try again."
    }
    return (title, message)
  }
  
  private func showErrorAlert(title: String, message: String) {
    errorAlert.title = title
    errorAlert.message = message
    present(errorAlert, animated: true, completion: nil)
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
    reset()
    setupSkeletons()
    tableView.reloadData()
    fetchData()
  }
  
  private func reset() {
    profile = nil
    accounts = []
    isLoaded = false
  }
}

// MARK: unit testing
extension AccountSummaryViewController {
  func titleAndMessageForTest(for error: NetworkError) -> (String, String) {
    return titleAndMessage(for: error)
  }
  
  func forceFetchProfile() {
      fetchProfile(group: DispatchGroup(), userId: "1")
  }
}
