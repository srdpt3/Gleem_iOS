//
//  LocationManager.swift
//  Gleem_iOS
//
//  Created by Dustin yang on 8/22/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import Foundation
import Combine
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    let objectWillChange = PassthroughSubject<Void, Never>()
    private let geocoder = CLGeocoder()
    @Published var status: CLAuthorizationStatus? {
        willSet { objectWillChange.send() }
    }
    
    @Published var location: CLLocation? {
        willSet { objectWillChange.send() }
    }
    
    override init() {
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    
    @Published var placemark: CLPlacemark? {
        willSet { objectWillChange.send() }
    }
    
    @Published var locationName: CLLocation? {
        willSet { objectWillChange.send() }
    }
    
    private func geocode() {
        guard let location = self.location else { return }
        geocoder.reverseGeocodeLocation(location, completionHandler: { (places, error) in
            if error == nil {
//                var address: String = ""

                self.placemark = places?[0]
                self.locationName = self.placemark?.location
//                // Location name
//                      if let locationName = self.placemark?.addressDictionary?["Name"] as? String {
//                          address += locationName + ", "
//                      }
//
//                      // Street address
//                      if let street = self.placemark?.addressDictionary?["Thoroughfare"] as? String {
//                          address += street + ", "
//                      }
//
//                      // City
//                      if let city = self.placemark?.addressDictionary?["City"] as? String {
//                          address += city + ", "
//                      }
//
//                      // Zip code
//                      if let zip = self.placemark?.addressDictionary?["ZIP"] as? String {
//                          address += zip + ", "
//                      }
//
//                      // Country
//                      if let country = self.placemark?.addressDictionary?["Country"] as? String {
//                          address += country
//                      }
//
//                print(address)
//
//
//                print(self.locationName)
            } else {
                self.placemark = nil
            }
        })
    }
    
    
    
    
}


extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.status = status
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        self.geocode()
    }
}


extension CLLocation {
    var latitude: Double {
        return self.coordinate.latitude
    }
    
    var longitude: Double {
        return self.coordinate.longitude
    }
}
