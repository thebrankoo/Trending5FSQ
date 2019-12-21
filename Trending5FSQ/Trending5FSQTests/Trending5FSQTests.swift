//
//  Trending5FSQTests.swift
//  Trending5FSQTests
//
//  Created by Branko Popovic on 12/21/19.
//  Copyright © 2019 Branko Popovic. All rights reserved.
//

import XCTest
import UIKit

class Trending5FSQTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDataRequest() {
        let lat = 35.6762
        let long = 139.6503
        var fetchedVenues:[Venue]? = nil
        
        let exp = expectation(description: "Fetch next page callback")
        
        let requester = FSQRequester()
        requester.requestTrendingVenues(longitude: long, latitude: lat, limit: 1, completion: { venues in
            fetchedVenues = venues
            exp.fulfill()
        })
        
        waitForExpectations(timeout: 2) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
        
        guard let _ = fetchedVenues else {
            XCTFail("Venues fetching error or slow network")
            return
        }
    }

    func testVenueFactory() {
        let id = "id"
        let name = "name"
        let category = "cat"
        let address = "address"
        let distance:Int64 = 1234
        
        let created = Manager.shared.makeVenue(fqId: id, name: name, address: address, category: category, distance: distance)
        
        var isValid = false
        
        
        if let fqId = created.fsqId,
            let n = created.name,
            let c = created.category,
            let a = created.address,
            id == fqId,
            n == name,
            c == category,
            a == address,
            distance == created.distance {
            isValid = true
        }
        
        XCTAssertTrue(isValid, "Venue creation fail")
    }
    
    
}
