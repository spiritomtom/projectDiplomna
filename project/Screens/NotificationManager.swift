//
//  NotificationManager.swift
//  project
//
//  Created by Petko Dapchev on 25.02.21.
//

import Foundation
import UserNotifications
import CoreLocation

class NotificationManager: NSObject, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {
    
    static let shared = NotificationManager()
    
    private var locationManager = CLLocationManager()
    private var center = UNUserNotificationCenter.current()
    
    private var places = [Place]()
    
    func setup(with places: [Place]) {
        self.places = places
        
        center.removeAllPendingNotificationRequests()
        
        center.delegate = self

        center.requestAuthorization(options: [.alert, .sound], completionHandler: { granted, _ in
            guard granted  else { return }
            self.addNotificationTriggers(for: places)
        })
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorizationsAndAddTriggers()
    }
    
    private func checkAuthorizationsAndAddTriggers() {
        guard (locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways) else { return }
        
        addNotificationTriggers(for: places)
    }
    
    private func addNotificationTriggers(for places: [Place]) {
        places.forEach { place in
            let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: place.lat, longitude: place.lon), radius: 200.0, identifier: place.name)
            region.notifyOnEntry = true
            region.notifyOnExit = true
            let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
            let content = UNMutableNotificationContent()
            content.title = "near_place_notification_title".localized
            content.body = "near_place_notification_body".localized(with: [place.name])
            let notificationRequest = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(notificationRequest, withCompletionHandler: nil)
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .badge])
    }
    
}

