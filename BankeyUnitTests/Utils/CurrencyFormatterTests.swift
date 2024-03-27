//
//  CurrencyFormatterTests.swift
//  BankeyUnitTests
//
//  Created by Admin on 26/10/23.
//

import Foundation
import XCTest

@testable import Bankey

class Test: XCTestCase {
    
    var formatter: CurrencyFormatter!
    
    override func setUp() {
        super.setUp()
        formatter = CurrencyFormatter()
    }
    
    func testBreakeDollarsIntoCent() throws {
        let result = formatter.breakIntoDollarsAndCents(929466.23)
        XCTAssertEqual(result.0, "929,466")
        XCTAssertEqual(result.1, "23")
    }
 
    func testDollarsFormatted() throws {
        let result = formatter.dollarsFormatted(929.466)
        XCTAssertNotEqual(result, "929.466")
        XCTAssertEqual(result, "$929.47")
    }
    
    func testZeroDollarsFormatted() throws {
        let result = formatter.dollarsFormatted(0)
        XCTAssertNotEqual(result, "0")
        XCTAssertEqual(result, "$0.00")
    }
    
    func testDollarsFormattedWithCurrentcySymbol() throws {
        let locale = Locale.current
        let currencySymbol = locale.currencySymbol!
        
        let result = formatter.dollarsFormatted(929466.23)
        XCTAssertEqual(result, "\(currencySymbol)929,466.23")
    }
}
