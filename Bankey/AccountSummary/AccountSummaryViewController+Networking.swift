//
//  AccountSummaryViewController+Networking.swift
//  Bankey
//
//  Created by Admin on 27/03/24.
//

import Foundation
import UIKit


struct Account: Codable {
  let id: String
  let type: AccountType
  let name: String
  let amount: Decimal
  let createdDateTime: Date
  
  static func makeSkeleton() -> Account {
    return Account(
      id: "1", type: .Banking, name: "Account Name", amount: 0.0, createdDateTime: Date()
    )
  }
}

func fetchAccounts(
  forUserId userId: String, completion: @escaping (Result<[Account], NetworkError>) -> Void
) {
  let url = URL(
    string: "https://fierce-retreat-36855.herokuapp.com/bankey/profile/\(userId)/accounts"
  )!
  
  URLSession.shared.dataTask(with: url) { data, response, error in
    DispatchQueue.main.async {
      guard let data = data, error == nil else {
        completion(.failure(.severError))
        return
      }
      
      do {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let account = try decoder.decode([Account].self, from: data)
        completion(.success(account))
      } catch {
        completion(.failure(.decodingError))
      }
    }
  }.resume()
}
