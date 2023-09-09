//
//  MainViewController.swift
//  Bankey
//
//  Created by Admin on 09/09/23.
//

import UIKit

class MainviewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTabBar()
    }
    
    private func setupView() {
        func onVcSetup(_ vc: UIViewController, imgName: String, title: String) -> UINavigationController {
            vc.setStatusBarImage(imgName: imgName, title: title)
            return UINavigationController(rootViewController: vc)
        }
        
        let summaryVc = onVcSetup(AcctountSummaryViewController(), imgName: "list.dash.header.rectangle", title: "Summary")
        summaryVc.navigationBar.tintColor = appColor
        hideNavigationBarLine(summaryVc.navigationBar)
        
        viewControllers = [
            summaryVc,
            onVcSetup(MoveMoneySummaryViewController(), imgName: "arrow.left.arrow.right", title: "Move Money"),
            onVcSetup(MoreViewController(), imgName: "ellipsis.circle", title: "More")
        ]
    }
    
    private func hideNavigationBarLine(_ navigationBar: UINavigationBar) {
        let img = UIImage()
        navigationBar.shadowImage = img
        navigationBar.setBackgroundImage(img, for: .default)
        navigationBar.isTranslucent = false
    }
    
    private func setupTabBar() {
        tabBar.tintColor = appColor
        tabBar.isTranslucent = false
    }
}

class AcctountSummaryViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
    }
}

class MoveMoneySummaryViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
    }
}

class MoreViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }
}
