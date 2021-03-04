//
//  PictureSharingViewController.swift
//  project
//
//  Created by Petko Dapchev on 16.02.21.
//

import Foundation
import UIKit

class PictureSharingViewController: UIViewController {
    @IBOutlet weak var img: UIImageView!
    
    var image: UIImage?
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var takeImageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        takeImageButton.layer.cornerRadius = 15
    }
    
    @IBAction func buttonOnPressBrowsePicture(_ sender: Any) {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func sharePicture(_ sender: Any) {
        guard let image = image else { return }
        
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        activityViewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
       present(activityViewController, animated: true, completion: nil)
    }
}

extension PictureSharingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            self.img.image = image
            self.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
}
