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
    let mainviewController = MainviewController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .systemBackground
        
        loginViewColntroller.delegate = self
        onboardingContainerViewController.delegate = self
        
        registerForNotifications()
        
        displayLogin()
        
        return true
    }
    
    private func registerForNotifications() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(didLogout), name: .logout, object: nil
        )
    }
    
    private func displayLogin() {
        setRootViewController(loginViewColntroller)
    }
    
    private func displayNextScreen() {
        if LocalState.hasOnboarded {
            prepMain()
            setRootViewController(mainviewController)
        } else {
            setRootViewController(onboardingContainerViewController)
        }
    }
    
    private func prepMain() {
        mainviewController.setStatusBar()
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().backgroundColor = appColor
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
        displayNextScreen()
    }
    
}

extension AppDelegate: OnboardingContainerViewControllerDelegate {
    
    func didFinishOnboarding() {
        LocalState.hasOnboarded = true
        prepMain()
        setRootViewController(mainviewController)
    }
    
}


// MARK: Actions
extension AppDelegate: LogoutDelegate {
    
    @objc func didLogout() {
        setRootViewController(loginViewColntroller)
    }
    
}

