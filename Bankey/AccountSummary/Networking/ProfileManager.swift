//
//  ProfileManager.swift
//  Bankey
//
//  Created by Admin on 28/03/24.
//

import Foundation

protocol ProfileManageable: AnyObject {
  func fetchProfile( forUserId userId: String, completion: @escaping (Result<Profile, NetworkError>) -> Void)
}

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

class ProfileMagener: ProfileManageable {
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
