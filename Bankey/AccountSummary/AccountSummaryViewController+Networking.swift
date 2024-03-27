//
//  AccountSummaryViewController+Networking.swift
//  Bankey
//
//  Created by Admin on 27/03/24.
//

import Foundation
import UIKit

enum NetworkError: Error {
  case severError
  case decodingError
}

struct Profile: Codable {
  let id: String
  let firstName: String
  let lastName: String
  
  enum CodingKeys: String, CodingKey {
    case id
    case firstName = "first_name"
    case lastName = "last_name"
  }
}

extension AccountSummaryViewController {
  func fetchProfile(
    forUserId userId: String, completion: @escaping (Result<Profile, NetworkError>) -> Void
  ) {
    let url = URL(
      string: "https://fierce-retreat-36855.herokuapp.com/bankey/profile/\(userId)"
    )!
    
    URLSession.shared.dataTask(with: url) { data, response, error in
      DispatchQueue.main.async {
        guard let data = data, error == nil else {
          completion(.failure(.severError))
          return
        }
        
        do {
          let profile = try JSONDecoder().decode(Profile.self, from: data)
          completion(.success(profile))
        } catch {
          completion(.failure(.decodingError))
        }
      }
    }.resume()
  }
  
}

struct Account: Codable {
  let id: String
  let type: AccountType
  let name: String
  let amount: Decimal
  let createdDateTime: Date
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
