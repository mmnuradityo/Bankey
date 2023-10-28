//
//  UITextField+SecureToggle.swift
//  Bankey
//
//  Created by Admin on 28/10/23.
//

import Foundation
import UIKit


let passwordToggleButton = UIButton(type: .custom)

extension UITextField {
    
    func enablePasswordToggle() {
        passwordToggleButton.setImage(
            UIImage(systemName: "eye.fill"), for: .normal
        )
        passwordToggleButton.setImage(
            UIImage(systemName: "eye.slash.fill"), for: .selected
        )
        passwordToggleButton.addTarget(
            self, action: #selector(togglePasswordView), for: .touchUpInside
        )
        rightView = passwordToggleButton
        rightViewMode = .always
    }
    
    @objc func togglePasswordView(_ sender: Any) {
        isSecureTextEntry.toggle()
        passwordToggleButton.isSelected.toggle()
    }
    
}
