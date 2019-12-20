//
//  VenuesViewModel.swift
//  Trending5FSQ
//
//  Created by Branko Popovic on 12/20/19.
//  Copyright © 2019 Branko Popovic. All rights reserved.
//

import Foundation

class VenuesViewModel: NSObject {
    private let manager: Manager
    
    override init() {
        manager = Manager.shared
        super.init()
        manager.delegate = self
    }
    
    func run() {
        manager.fetchVenues()
    }
}

extension VenuesViewModel: ManagerProtocol {
    func managerDidFetch(venues:[Venue]?) {
        if let vs = venues {
            vs.forEach { (v) in
                print("v: \(v.fsqId!), \(v.name!), \(v.category!), \(v.timestamp!.timeIntervalSince1970)")
            }
        }
        else {
            print("No venues")
        }
    }
}
