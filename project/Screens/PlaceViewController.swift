//
//  PlaceViewController.swift
//  project
//
//  Created by Petko Dapchev on 31.01.21.
//

import UIKit
import FirebaseFirestore





private let PlaceTableViewCellIdentifier = "PlaceTableViewCellIdentifier"

class PlaceViewController: UITableViewController {
    
    var place: Place!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: PlaceTableViewCellIdentifier)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.rowHeight = UITableView.automaticDimension
                tableView.estimatedRowHeight = 100
        let cell = tableView.dequeueReusableCell(withIdentifier: PlaceTableViewCellIdentifier, for: indexPath)
        
        cell.textLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        cell.textLabel?.textColor = .green
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Coordinates: \(place.coordinate.latitude), \(place.coordinate.longitude))"
        case 1:
            cell.textLabel?.text = "Name: \(place.name)"
        case 2:
            cell.textLabel?.text = "Rating: \(place.rating) out of 5"
        case 3:
            cell.textLabel?.text = "Information about this palce : \(place.info)."
        default: break
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
}
