//
//  UIViewCOntroller+Utils.swift
//  Bankey
//
//  Created by Admin on 09/09/23.
//

import UIKit

extension UIViewController {
    
    func setStatusBar() {
        let navBarApperance = UINavigationBarAppearance()
        navBarApperance.configureWithTransparentBackground() // to hide Nabigation bar line also
        navBarApperance.backgroundColor = appColor
        UINavigationBar.appearance().standardAppearance = navBarApperance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarApperance
    }
    
    func setStatusBarImage(imgName: String, title: String) {
        let config = UIImage.SymbolConfiguration(scale: .large)
        let img = UIImage(systemName: imgName, withConfiguration: config)
        tabBarItem = UITabBarItem(title: title, image: img, tag: 0)
    }
    
}
