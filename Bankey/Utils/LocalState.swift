//
//  LocalState.swift
//  Bankey
//
//  Created by Admin on 08/09/23.
//

import Foundation

class LocalState {
    
    private enum Keys: String {
        case hasOnboardd
    }
    
    public static var hasOnboarded: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.hasOnboardd.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.hasOnboardd.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
}
