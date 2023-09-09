//
//  UIViewCOntroller+Utils.swift
//  Bankey
//
//  Created by Admin on 09/09/23.
//

import UIKit

extension UIViewController {
    
    func setStatusBar() {
        let statusBarSize = UIApplication.shared.statusBarFrame.size
        let frame = CGRect(origin: .zero, size: statusBarSize)
        let statusBarView = UIView(frame: frame)
        
        statusBarView.backgroundColor = appColor
        view.addSubview(statusBarView)
    }
    
    func setStatusBarImage(imgName: String, title: String) {
        let config = UIImage.SymbolConfiguration(scale: .large)
        let img = UIImage(systemName: imgName, withConfiguration: config)
        tabBarItem = UITabBarItem(title: title, image: img, tag: 0)
    }
    
}
