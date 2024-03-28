//
//  AccountSummaryViewControllerTests.swift
//  BankeyUnitTests
//
//  Created by Admin on 28/03/24.
//

import Foundation
import XCTest

@testable import Bankey

class AccountSummaryViewControllerTests: XCTestCase {
  var vc: AccountSummaryViewController!
  var mockManager: MockProfileManager!
  
  class MockProfileManager: ProfileManageable {
    var profile: Profile?
    var error: NetworkError?
    
    func fetchProfile(forUserId userId: String, completion: @escaping (Result<Profile, NetworkError>) -> Void) {
      if error != nil {
        completion(.failure(error!))
        return
      }
      profile = Profile(id: "1", firstName: "FirstName", lastName: "LastName")
      completion(.success(profile!))
    }
  }
  
  
  override func setUp() {
    super.setUp()
    vc = AccountSummaryViewController()
    mockManager = MockProfileManager()
    vc.profileManger = mockManager
    // vc.loadViewIfNeeded()
  }
  
  func testTitleAndMessageFromServerError() throws {
    let titleAndMessage = vc.titleAndMessageForTest(for: .severError)
    let title = titleAndMessage.0
    let message = titleAndMessage.1
    
    XCTAssertEqual("Server Error", title)
    XCTAssertEqual("We could not process your request. Please try again.", message)
  }
  
  func testTitleAndMessageFromDecodingError() throws {
    let titleAndMessage = vc.titleAndMessageForTest(for: .decodingError)
    let title = titleAndMessage.0
    let message = titleAndMessage.1
    
    XCTAssertEqual("Network Error", title)
    XCTAssertEqual("Ensure you are connected to the internet. Please try again.", message)
  }
  
  func testAlertForServerError() throws {
    mockManager.error = NetworkError.severError
    vc.forceFetchProfile()
    
    XCTAssertEqual("Server Error", vc.errorAlert.title)
    XCTAssertEqual("We could not process your request. Please try again.", vc.errorAlert.message)
  }
  
  func testAlertFoDecodingError() throws {
    mockManager.error = NetworkError.decodingError
    vc.forceFetchProfile()
    
    XCTAssertEqual("Network Error", vc.errorAlert.title)
    XCTAssertEqual("Ensure you are connected to the internet. Please try again.", vc.errorAlert.message)
  }
}
