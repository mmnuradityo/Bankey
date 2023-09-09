//
//  AppDelegate.swift
//  Bankey
//
//  Created by Admin on 08/08/23.
//

import UIKit

let appColor: UIColor = .systemTeal

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let loginViewColntroller = LoginViewController()
    let onboardingContainerViewController = OnboardingContainerViewController()
    let dummyViewController = DummyViewController()
    let mainviewController = MainviewController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .systemBackground
        
        loginViewColntroller.delegate = self
        onboardingContainerViewController.delegate = self
        dummyViewController.logoutDelagate = self
        
        setRootViewController(mainviewController)
//        setRootViewController(loginViewColntroller)
        mainviewController.selectedIndex = 1
        return true
    }

}

extension AppDelegate {
    
    func setRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard animated, let window = self.window else {
            setRootViewController(vc)
            return
        }
        
        setRootViewController(vc)
        UIView.transition(
            with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil
        )
    }
    
    func setRootViewController(_ vc: UIViewController) {
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
    }
    
}
 
extension AppDelegate: LoginViewVontrollerDelegate {
     
    func didLogin() {
        setRootViewController(
            LocalState.hasOnboarded ? dummyViewController : onboardingContainerViewController
        )
    }
    
}

extension AppDelegate: OnboardingContainerViewControllerDelegate {
    
    func didFinishOnboarding() {
        LocalState.hasOnboarded = true
        setRootViewController(dummyViewController)
    }
    
}

extension AppDelegate: LogoutDelegate {
    
    func didLogout() {
        setRootViewController(loginViewColntroller)
    }
    
}

