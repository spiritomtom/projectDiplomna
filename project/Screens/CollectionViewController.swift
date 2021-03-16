//
//  CollectionViewController.swift
//  project
//
//  Created by Petko Dapchev on 19.12.20.
//


import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

private let NumberOfAchievments = 1
private let PlaceTableViewCellIdentifier = "PlaceTableViewCellIdentifier"

class MyUser: Decodable{
    var email: String 
    var lastVisited: [Timestamp]
    var userPlaces: [String]
    
    init(email: String, lastVisited: [Timestamp], userPlaces: [String] ) {
        self.email = email
        self.lastVisited = lastVisited
        self.userPlaces = userPlaces
    }
    
}

class CollectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var db: Firestore!
    private let email = UserDefaults.standard.string(forKey: "email")
    
    @IBOutlet weak var tableView: UITableView!
    
    private var userPlacesNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: PlaceTableViewCellIdentifier)
        tableView.separatorStyle = .none
        
        getUsersPlaces { places in
            self.userPlacesNames = places
            self.tableView.reloadData()
        }
    }
    
    private func getUsersPlaces(completionBlock: @escaping ([String]) -> Void ){
        let docRef = db.collection("users").document(email!)
        
        docRef.getDocument { (document, error) in
            let result = Result { try document!.data(as: MyUser.self) }
            switch result {
            case .success(let user):
                if let user = user {
                    completionBlock(user.userPlaces)
                } else {
                    print("Document does not exist")
                }
            case .failure(let error):
                print("Error decoding city: \(error)")
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return userPlacesNames.count
        }
        
        if section == 1 && !userPlacesNames.isEmpty {
            return NumberOfAchievments
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PlaceTableViewCellIdentifier, for: indexPath)
            cell.textLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
            cell.textLabel?.textColor = .green
            cell.textLabel?.text = userPlacesNames[indexPath.row]
            cell.selectionStyle = .none
            
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = UITableViewCell()
            cell.textLabel?.font = .systemFont(ofSize: 20, weight: .bold)
            
            let chooseColor: (Int) -> (UIColor, String) = { numberOfPlaces in
                if numberOfPlaces == 1 {
                    return (.brown, "bronze_medal".localized)
                }
                
                if numberOfPlaces == 2 {
                    return (.lightGray, "silver_medal".localized)
                }
                
                return (.yellow, "gold_medal".localized)
            }
            
            let (color, text) = chooseColor(userPlacesNames.count)
            cell.textLabel?.textColor = color
            cell.textLabel?.text = text
            cell.textLabel?.textAlignment = .center
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UITableViewHeaderFooterView()
        
        view.textLabel?.text = section == 0 ? "collecton_view_visited_places".localized : "collection_view_achievements".localized //sakrateb if/else ako e true Places ako e false Achievements
        view.backgroundColor = .systemGroupedBackground
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
}
