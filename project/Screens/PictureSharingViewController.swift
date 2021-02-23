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
    
    
    @IBOutlet weak var img: UIImageView!
    
    let image = UIImage(named: "Image")

        
    
    @IBOutlet weak var camButton: SwiftyCamButton!
    let imagePicker = UIImagePickerController()
    
override func viewDidLoad(){
    
    
    let imageToShare = [ img! ]
    
    
    
    super.viewDidLoad()
    cameraDelegate = self
    imagePicker.delegate = self
        isPressed(camButton)
        
    
    
    
    
}
    @IBAction func isPressed(_ sender: SwiftyCamButton) {
        print("ALA BALA")
        takePhoto()
        
    }
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
         // Called when takePhoto() is called or if a SwiftyCamButton initiates a tap gesture
         // Returns a UIImage captured from the current session
    }
    
    @IBAction func buttonOnPressBrowsePicture(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func sharePicture(_ sender: Any) {
       
        
        UIGraphicsBeginImageContext(img.frame.size)
        img.layer.render(in: UIGraphicsGetCurrentContext()!)
        print("Sharing image")
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        let activityViewController = UIActivityViewController(activityItems: [image!], applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        activityViewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
    activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]

        
       present(activityViewController, animated: true, completion: nil)
    }
}

extension PictureSharingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            img.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
