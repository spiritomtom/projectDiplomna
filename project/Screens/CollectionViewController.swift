//
//  CollectionViewController.swift
//  project
//
//  Created by Petko Dapchev on 19.12.20.
//


import UIKit


class CollectionViewController: UIViewController {

    override func viewDidLoad() {
        
            performSegue(withIdentifier: "showCollection", sender: self)
            
        
        super.viewDidLoad()
    }
}
