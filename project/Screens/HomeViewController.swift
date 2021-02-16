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

private let PlaceAnnotionView = "PlaceAnnotionView"

class Place: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D

    var id: String
    var name: String
    var rating: Float
    var info: String
    
    init(coordinate: CLLocationCoordinate2D, id: String, name: String, rating: Float,info: String) {
        self.coordinate = coordinate
        self.id = id
        self.name = name
        self.rating = rating
        self.info = info
        super.init()
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
    
  
    
    @IBOutlet weak var cameraButton:UIButton!
    private var selectedPlace: Place?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        cameraButton.layer.zPosition = 10
        
        
        
        mapView.register(PlaceView.self, forAnnotationViewWithReuseIdentifier: PlaceAnnotionView)
        
        loadAndShowPlaces()
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
        guard let placeViewController = segue.destination as? PlaceViewController,
              let place = selectedPlace else { return }
        
        placeViewController.place = place
    }
    
    private func openPlace(_ place: Place) {
        selectedPlace = place
        performSegue(withIdentifier: "showPlace", sender: self)
    }
    
    private func loadAndShowPlaces() {
        SVProgressHUD.show(withStatus: "Loading...")
      
        loadPlaces { places, error in
            SVProgressHUD.dismiss()
            
            if let places = places {
                self.mapView.showAnnotations(places, animated: true)
                
                return
            }
            
            if let error = error {
                SVProgressHUD.showError(withStatus: error.localizedDescription)
                SVProgressHUD.dismiss(withDelay: 3)
            }
        }
    }
    
    private func loadPlaces(completion: @escaping ([Place]?, Error?) -> Void) {
        ///TODO:- load from internet and show
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            /*
             if success call completion([places], nil)
             if error call completion(nil, error)
             */
            
            let place1 = Place(coordinate: .init(latitude: 42.665201899532036, longitude:  23.378899623703767), id: "addd", name: "Test", rating: 5.5, info: "This is Mr. Bricolague")
            let place2 = Place(coordinate: .init(latitude: 42.68507949329909, longitude:  23.36799912642389), id: "vvv", name: "Place 3", rating: 2.5, info: "This is an ancient building")
            
            completion([place1, place2], nil)
        }
    }
    
    
}

extension HomeViewController: QRCodeScanViewControllerDelegate {
    func qrCodeScanViewController(_ viewController: QRCodeScanViewController, didScanQRCode value: String) {
        viewController.dismiss(animated: true, completion: nil)
        
        print("value: \(value)")
        /// TODO:- find place by id and open it
        /// openPlace(place)
        
    }
}



