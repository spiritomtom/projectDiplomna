
// Swift
//
// AppDelegate.swift

import UIKit
import FBSDKLoginKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LoginButtonDelegate {
    
    var window: UIWindow?
    
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    private var loggedInUser: Bool {
        get {
            UserDefaults.standard.bool(forKey: "loggedInUser")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "loggedInUser")
        }
    }
    
    func application(  _ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? ) -> Bool {
        
        window = UIWindow()
        
        if loggedInUser {
            window?.rootViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
        } else {
            window?.rootViewController = mainStoryboard.instantiateInitialViewController()
        }
        
        FirebaseApp.configure()
        return true
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let result = result, let token = result.token else { return }
        
        if !token.isExpired {
            loggedInUser = true
            window?.rootViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        loggedInUser = false
        window?.rootViewController = mainStoryboard.instantiateInitialViewController()
    }
 }
 

