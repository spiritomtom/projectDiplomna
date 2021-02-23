//
//  PictureSharingViewController.swift
//  project
//
//  Created by Petko Dapchev on 16.02.21.
//

import Foundation
import UIKit
import SwiftyCam
class PictureSharingViewController: SwiftyCamViewController, SwiftyCamViewControllerDelegate{
    
    
    let image = UIImage(named: "Image")

        
          
    @IBOutlet weak var camButton: SwiftyCamButton!
    
    
override func viewDidLoad(){
    
    
   // let imageToShare = [ image! ]
    
    //let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
    
    super.viewDidLoad()
    cameraDelegate = self
    
        isPressed(camButton)
        
    
    //activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
    
   // activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]

    // present the view controller
   // self.present(activityViewController, animated: true, completion: nil)
    
    
}
    @IBAction func isPressed(_ sender: SwiftyCamButton) {
        print("ALA BALA")
        takePhoto()
        
    }
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
         // Called when takePhoto() is called or if a SwiftyCamButton initiates a tap gesture
         // Returns a UIImage captured from the current session
    }
    
}
