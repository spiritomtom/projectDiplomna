
// Swift
//
// Add this to the header of your file, e.g. in ViewController.swift

import FBSDKLoginKit

// Add this to the body
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        let loginButton = FBLoginButton()
        loginButton.center = view.center
        view.addSubview(loginButton)
        
        // Swift

        

            if let token = AccessToken.current,
                !token.isExpired {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "HomePageTransition", sender:self)
                }
                
            }
        
            
    }
    
    
}



