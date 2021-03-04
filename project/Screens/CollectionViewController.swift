//
//  CollectionViewController.swift
//  project
//
//  Created by Petko Dapchev on 19.12.20.
//


import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class MyUser: Decodable{
    var email: String 
    var timestamp: Timestamp
    var userPlaces: [String]
    
    init(email: String, timestamp: Timestamp, userPlaces: [String] ) {
        self.email = email
        self.timestamp = timestamp
        self.userPlaces = userPlaces
        
       
    }
    
}

class CollectionViewController: UIViewController {
    var db: Firestore!
        let email = UserDefaults.standard.string(forKey: "email")
    
    override func viewDidLoad() {
            
        
        super.viewDidLoad()
        var user_places: [String] = []
        getUsersPlaces(places_visited: user_places){places in
            user_places = places
            
        }
        print("User Places: ------ \(user_places)")
        
        
        
        
    }
    private func getUsersPlaces(places_visited: [String],completionBlock: @escaping ([String]) -> Void ){
        let docRef = db.collection("places").document(email!)
       
        var user_places = places_visited
        docRef.getDocument { (document, error) in
            let result = Result {
                try document!.data(as: MyUser.self)
                        }
                        switch result {
                        case .success(let user):
                            if let user = user {
                                user_places.append(contentsOf: user.userPlaces)
                              completionBlock(user_places)
                            
                            } else {
                      
                                print("Document does not exist")
                            }
                        case .failure(let error):
                            
                            print("Error decoding city: \(error)")
                        }
                    }
                  
        
                }
}
