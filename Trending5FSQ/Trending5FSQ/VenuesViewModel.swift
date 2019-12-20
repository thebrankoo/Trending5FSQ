//
//  VenuesViewModel.swift
//  Trending5FSQ
//
//  Created by Branko Popovic on 12/20/19.
//  Copyright © 2019 Branko Popovic. All rights reserved.
//

import Foundation

protocol VenuesViewModelProtocol: class {
    func venuesViewModelDidFinishDataLoading()
}

class VenuesViewModel: NSObject {
    private let manager: Manager
    
    private var fetchedData: [Venue]? = nil
    
    weak var delegate: VenuesViewModelProtocol?
    
    var dataSize: Int {
        return fetchedData?.count ?? 0
    }
    
    override init() {
        manager = Manager.shared
        super.init()
        manager.delegate = self
    }
    
    func run() {
        manager.fetchVenues()
    }
}

extension VenuesViewModel {
    
    func name(atIndex index: Int)->String? {
        return venue(atIndex: index)?.name
    }
    
    func address(atIndex index: Int)->String?{
        return venue(atIndex: index)?.address
    }
    
    func category(atIndex index: Int)->String?{
        return venue(atIndex: index)?.category
    }
    
    private func venue(atIndex index: Int)->Venue? {
        return fetchedData?[index]
    }
}

extension VenuesViewModel: ManagerProtocol {
    func managerDidFetch(venues:[Venue]?) {
        DispatchQueue.main.async {
            self.fetchedData = venues
            self.delegate?.venuesViewModelDidFinishDataLoading()
        }
        
//        if let vs = venues {
//            vs.forEach { (v) in
//                print("v: \(v.fsqId!), \(v.name!), \(v.category!), \(v.timestamp!.timeIntervalSince1970)")
//            }
//        }
//        else {
//            print("No venues")
//        }
    }
}
