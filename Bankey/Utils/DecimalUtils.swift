//
//  DecimalUtils.swift
//  Bankey
//
//  Created by Admin on 11/09/23.
//

import Foundation

extension Decimal {
    
    var doubleValue: Double {
        return NSDecimalNumber(decimal: self).doubleValue
    }
    
}
