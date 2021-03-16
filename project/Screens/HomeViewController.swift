//
//  HomeViewController.swift
//  project
//
//  Created by Petko Dapchev on 31.01.21.
//
import Firebase
import UIKit
import MapKit
import QRCodeScanner
import SVProgressHUD
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseFirestore
import FirebaseCore
import FirebaseFirestoreSwift

private let PlaceAnnotionView = "PlaceAnnotionView"

class Place: NSObject, MKAnnotation, Decodable{
    var coordinate: CLLocationCoordinate2D
    var id: String
    var info: String
    var name: String
    var rating: Float
    var lon: Double
    var lat: Double
   
    init(coordinate: CLLocationCoordinate2D, id: String,info: String, name: String, rating: Float, lon: Double, lat: Double) {
        self.coordinate = coordinate
        self.id = id
        self.name = name
        self.rating = rating
        self.info = info
        self.lon = lon
        self.lat = lat
       
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        info = try values.decode(String.self, forKey: .info)
        name = try values.decode(String.self, forKey: .name)
        lat = try values.decode(Double.self, forKey: .lat)
        lon = try values.decode(Double.self, forKey: .lon)
        coordinate = CLLocationCoordinate2D(latitude: self.lat, longitude: self.lon)
        rating = try values.decode(Float.self, forKey: .rating)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, name,coordinate, rating,info,lat, lon//NOTICE THIS
    }
}

class PlaceView: MKPinAnnotationView {
    
    var tapHandler: (() -> Void)?
    
    let label = UILabel()
   
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        canShowCallout = true
        
        detailCalloutAccessoryView = label
        label.textColor = .green
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.isUserInteractionEnabled = true
        
        let touchRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        touchRecognizer.numberOfTapsRequired = 1
        label.addGestureRecognizer(touchRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTap() {
        tapHandler?()
    }
}

class HomeViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    var db: Firestore!
    var places: [Place] = []
  
    @IBOutlet weak var cameraButton:UIButton!
    private var selectedPlace: Place?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        cameraButton.layer.zPosition = 10
        
        
        getAllPlacesFromDb() { [weak self] places in
            self?.places = places
       }
        
        mapView.register(PlaceView.self, forAnnotationViewWithReuseIdentifier: PlaceAnnotionView)
        
        loadAndShowPlaces()
    }
    
    private func getPlaceFromDb(documentName: String,completionBlock: @escaping (Place) -> Void ){
        let docRef = db.collection("places").document(documentName)
       
        docRef.getDocument { (document, error) in
            let result = Result {
                try document!.data(as: Place.self)
                        }
                        switch result {
                        case .success(let place):
                            if let place = place {
                                
                              completionBlock(place)
                            
                            } else {
                      
                                print("Document does not exist")
                            }
                        case .failure(let error):
                            
                            print("Error decoding city: \(error)")
                        }
                    }
                  //completionBlock(place)
        
                }
  
    private func getAllPlacesFromDb(completionBlock: @escaping ([Place]) -> Void){
            // [START get_multiple_all]
        var places: [Place] = []
        var counter = 0
        let doc_count = 3
            db.collection("places").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                       
                            self.getPlaceFromDb(documentName: document.documentID) { place in
                            counter += 1
                            
                            places.append(place)
                        
                            if counter == doc_count{
                                completionBlock(places)
                            }
                           }
                    }
                   
                    
                }
            }
           
        }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: PlaceAnnotionView, for: annotation) as! PlaceView
        let place = annotation as! Place
        view.label.text = "\(place.name), rating: \(place.rating)"
        view.tapHandler = {
            self.openPlace(place)
        }
        return view
    }
    
    @IBAction func didTapCamera(_ sender: UIButton) {
        let scanner = QRCodeScanViewController.create()
        scanner.delegate = self
        present(scanner, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let placeViewController = segue.destination as? PlaceViewController,
              let place = selectedPlace {
            placeViewController.place = place
        }
    }
    
    private func openPlace(_ place: Place) {
        selectedPlace = place
        performSegue(withIdentifier: "showPlace", sender: self)
    }
    
    private func loadAndShowPlaces() {
        SVProgressHUD.show(withStatus: "Loading...")
        
        getAllPlacesFromDb { places in
            SVProgressHUD.dismiss()
            
            NotificationManager.shared.setup(with: places)
            
            self.mapView.showAnnotations(places, animated: true)
        }
    }
    
}

extension HomeViewController: QRCodeScanViewControllerDelegate {
    func qrCodeScanViewController(_ viewController: QRCodeScanViewController, didScanQRCode value: String) {
        viewController.dismiss(animated: true, completion: nil)
        let email = UserDefaults.standard.string(forKey: "email")
        print("value: \(value)")
       
        
        db.collection("places").whereField("id",isEqualTo: "\(value)").getDocuments(){(querySnapshot,err) in
            if let err = err{
                print("Error: \(err)")
                
            }else{
                for document in querySnapshot!.documents{
                    let result = Result{
                    
                        try document.data(as: Place.self)
                                }
                            switch result {
                            case .success(let place):
                                if let place = place {
                                    
                                    self.db.collection("users").document(email!).updateData([
                                        "userPlaces": FieldValue.arrayUnion([place.name
                                        ]),
                                    "lastVisited": FieldValue.arrayUnion([Date()])
                                    ])
                                
                                } else {
                          
                                    print("Document does not exist")
                                }
                            case .failure(let error):
                                
                                print("Error decoding city: \(error)")
                            }
                        }
                }
            }
        }
     
    }




