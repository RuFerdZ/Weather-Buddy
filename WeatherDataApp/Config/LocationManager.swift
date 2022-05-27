//
//  LocationManager.swift
//  WeatherDataApp
//
//  Created by Rusiru Fernando on 5/17/22.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    
    // initialise manager
    private let manager = CLLocationManager()
    
    // stores the location
    @Published var location: CLLocation? = nil
    
    // setups the location configurations (ie - permissions, accuracy, etc)
    override init() {
        super.init()
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.manager.distanceFilter = kCLDistanceFilterNone
        self.manager.requestWhenInUseAuthorization()
        self.manager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    // returns the location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {
            return
        }
        
        self.location = location
    }
    
    
}
