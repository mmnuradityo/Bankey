//
//  Date+Utils.swift
//  Bankey
//
//  Created by Admin on 27/03/24.
//

import Foundation

extension Date {
  static var bankeyDateFormated: DateFormatter {
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone(abbreviation: "MDT")
    return formatter
  }
  
  var monthDayYearString: String {
    let dateFormatter = Date.bankeyDateFormated
    dateFormatter.dateFormat = "MMM d, yyyy"
    return dateFormatter.string(from: self)
  }
}
