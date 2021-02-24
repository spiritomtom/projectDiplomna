
// Swift
//
// AppDelegate.swift

import UIKit
import FBSDKLoginKit
import Firebase
import FirebaseFirestore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LoginButtonDelegate {
    
    var window: UIWindow?
    var db: Firestore!
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
        FirebaseApp.configure()
        db = Firestore.firestore()
        
        
        //let db = Firestore.firestore()
        
        /*db.collection("places").document("placesID")
            .setData(["coordinates" : "28,22",
                   "info" :"test",
                   "test": "ala-bala2",
                   "rating" : 3.0
            ]){(error:Error?) in
                if let error = error{
                    print("\(error.localizedDescription)")}else {
                print("----------")
            }
        }*/
        

        window = UIWindow()
        
        
        if loggedInUser {
            window?.rootViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
        } else {
            window?.rootViewController = mainStoryboard.instantiateInitialViewController()
        }
        
        return true
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let result = result, let token = result.token else { return }
        
        if !token.isExpired {
            loggedInUser = true
            window?.rootViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
            let graphRequest : GraphRequest = GraphRequest(graphPath: "/me", parameters: ["fields": "email"], tokenString: token.tokenString,version: Settings.defaultGraphAPIVersion,httpMethod: .get)
           
            graphRequest.start(completionHandler: { (connection, result, error) -> Void in
                        guard error == nil else {
                            print("Error took place: \(error!)")
                            return
                        }
                        
                        //let id = result.valueForKey("id") as! String
                            
                        if let email = (result as? [String: Any])?["email"] as? String{
                        
                            UserDefaults.standard.setValue(email, forKey: "email")
                            self.db.collection("users").document(email).setData([
                                "email" : "\(email)",
                                "userPlaces":" "
                            ],merge: true)
                            //UserDefaults.standard.string(forKey: "email")!   kato iskam da getna email-a
                            
                        }
                    })
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        loggedInUser = false
        window?.rootViewController = mainStoryboard.instantiateInitialViewController()
    }
 }
 

