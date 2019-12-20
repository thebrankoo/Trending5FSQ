//
//  Manager.swift
//  Trending5FSQ
//
//  Created by Branko Popovic on 12/20/19.
//  Copyright © 2019 Branko Popovic. All rights reserved.
//

import Foundation

protocol ManagerProtocol: class {
    func managerDidFetch(venues:[Venue]?)
}

class Manager: NSObject {
    static var shared = Manager()
    
    private let cdManager: CDManager
    private let locationDetector: LocationDetector
    private let fsqRequester: FSQRequester
    
    weak var delegate: ManagerProtocol?
    
    override init() {
        cdManager = CDManager.shared
        locationDetector = LocationDetector()
        fsqRequester = FSQRequester()
        super.init()
    }
    
    func fetchVenues() {
        fetchRequestVenues {[weak self] (venues) in
            if let venues = venues {
                self?.delegate?.managerDidFetch(venues: venues)
                self?.persistData()
            }
            else {
                self?.fetchPersistedVenues(completion: { (venues) in
                    self?.delegate?.managerDidFetch(venues: venues)
                })
            }
        }
    }
    
    func venueWithInfo(fqId: String, name: String, address: String, category: String, distance: Int64) -> Venue {
        if let venue = cdManager.update(venueWithId: fqId, address: address, category: category, name: name, distance: distance) {
            return venue
        }
        
        return makeVenue(fqId: fqId, name: name, address: address, category: category, distance: distance)
    }
    
    func makeVenue(fqId: String, name: String, address: String, category: String, distance: Int64) -> Venue {
        let venue = Venue.make(withManagedObjectContext: CDManager.shared.persistentContainer.viewContext)
        venue.timestamp = Date()
        venue.fsqId = fqId
        venue.name = name
        venue.address = address
        venue.category = category
        venue.distance = distance
        
        return venue
    }
    
    func persistData() {
        cdManager.saveContext()
    }
    
    private func fetchRequestVenues(completion: @escaping ([Venue]?)->Void) {
        locationDetector.fetchCurrentLocation { [weak self] (lat, long) in
            if let long = long, let lat = lat {
                self?.fsqRequester.requestTrendingVenues(longitude: long, latitude: lat, completion: { (venues) in
                    completion(venues)
                })
            }
            else {
                print("Invalid long and lat")
                completion(nil)
            }
        }
    }
    
    private func fetchPersistedVenues(completion: @escaping ([Venue]?)->Void) {
        cdManager.fetchVenues { (venues) in
            completion(venues)
        }
    }
    
}
