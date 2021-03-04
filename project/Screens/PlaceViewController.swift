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
    var db : Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        tableView.allowsSelection = true
        tableView.separatorStyle = .none
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: PlaceTableViewCellIdentifier)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 4 : 2
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 1 else { return }
        
        if indexPath.row == 0 {
            // change language
        }
        
        if indexPath.row == 1 {
            showRatePlaceActionSheet()
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            tableView.rowHeight = UITableView.automaticDimension
                    tableView.estimatedRowHeight = 100
            let cell = tableView.dequeueReusableCell(withIdentifier: PlaceTableViewCellIdentifier, for: indexPath)
            
            cell.textLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
            cell.textLabel?.textColor = .green
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byWordWrapping
            
            cell.selectionStyle = .none
            
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Coordinates: \(place.coordinate.latitude), \(place.coordinate.longitude))"
            case 1:
                cell.textLabel?.text = "Name: \(place.name)"
            case 2:
                cell.textLabel?.text = "Rating: \(place.rating) out of 5"
            case 3:
                cell.textLabel?.text = "place_details_information".localized(with: [place.info])
            default: break
            }
            
            return cell
        }
      
        if indexPath.section == 1 {
            let cell = UITableViewCell()
            cell.textLabel?.text = indexPath.row == 0 ? "Change language" : "Rate place"
            cell.textLabel?.font = .systemFont(ofSize: 14)
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .systemBlue
            cell.selectionStyle = .none
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    
    private func showRatePlaceActionSheet() {
        let sheet = UIAlertController(title: "Rate", message: "Choose rating", preferredStyle: .actionSheet)
        
        let ratePlace: (Int) -> Void = { rating in
           self.place.rating = (self.place.rating + Float(rating)) / 2
            self.db.collection("places").document(self.place.name).updateData([
                "rating":self.place.rating
            ]){
                err in
                if let err = err{
                    print("Error updating!: \(err)")
                }
                
            }
            self.tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
        }
        
        let oneRate = UIAlertAction(title: "1", style: .default, handler: { _ in
            ratePlace(1)
        })
        let twoRate = UIAlertAction(title: "2", style: .default, handler: { _ in
            ratePlace(2)
        })
        let threeRate = UIAlertAction(title: "3", style: .default, handler: { _ in
            ratePlace(3)
        })
        let fourRate = UIAlertAction(title: "4", style: .default, handler: { _ in
            ratePlace(4)
        })
        let fiveRate = UIAlertAction(title: "5", style: .default, handler: { _ in
            ratePlace(5)
        })
        
        sheet.addAction(oneRate)
        sheet.addAction(twoRate)
        sheet.addAction(threeRate)
        sheet.addAction(fourRate)
        sheet.addAction(fiveRate)
        
        sheet.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
        
        present(sheet, animated: true, completion: nil)
    }
}
