//
//  LocationManager.swift
//  Trending5FSQ
//
//  Created by Branko Popovic on 12/19/19.
//  Copyright © 2019 Branko Popovic. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationDetectorProtocol: class {
    func didChangedAuthStatusToEnabled()
}

class LocationDetector: NSObject, CLLocationManagerDelegate {
    private let locationManager: CLLocationManager?
    typealias LocationFetched = (_ lat: Double?, _ long: Double?)->Void
    private var locationFetchedAction: LocationFetched?
    private var didFirstLocationUpdate = false
    
    weak var delegate: LocationDetectorProtocol?
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func fetchCurrentLocation(completion: @escaping LocationFetched)->Bool {
        locationFetchedAction = completion
        locationManager?.startUpdatingLocation()
        return isLocationServiceEnabled()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if didFirstLocationUpdate {
            return
        }
        didFirstLocationUpdate = true
        
        manager.stopUpdatingLocation()
        
        guard let lastLocation = locations.last else {
            locationFetchedAction?(nil, nil)
            return
        }
        
        locationFetchedAction?(lastLocation.coordinate.latitude, lastLocation.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse || status == .restricted {
            delegate?.didChangedAuthStatusToEnabled()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    private func isLocationServiceEnabled()->Bool {
        return CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse
    }
}
