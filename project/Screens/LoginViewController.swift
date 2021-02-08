//
//  LoginViewController.swift
//  project
//
//  Created by Petko Dapchev on 31.01.21.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: FBLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.delegate = (UIApplication.shared.delegate as? LoginButtonDelegate)
    }
    
}
