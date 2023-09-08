//
//  AppDelegate.swift
//  Bankey
//
//  Created by Admin on 08/08/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let loginViewColntroller = LoginViewController()
    let onboardingContainerViewController = OnboardingContainerViewController()
    let dummyViewController = DummyViewController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        
        loginViewColntroller.delegate = self
        onboardingContainerViewController.delegate = self
        dummyViewController.logoutDelagate = self
        
        window?.rootViewController = loginViewColntroller
//        window?.rootViewController = onboardingContainerViewController
        return true
    }

}

extension AppDelegate {
    
    func setRootViewController(_ vc: UIViewController, animated: Bool = true) {
        func setVc() {
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
        }
        
        guard animated, let window = self.window else {
            setVc()
            return
        }
        
        setVc()
        UIView.transition(
            with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil
        )
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

