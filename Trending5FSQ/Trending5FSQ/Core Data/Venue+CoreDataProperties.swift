//
//  Venue+CoreDataProperties.swift
//  Trending5FSQ
//
//  Created by Branko Popovic on 12/20/19.
//  Copyright © 2019 Branko Popovic. All rights reserved.
//
//

import Foundation
import CoreData


extension Venue {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Venue> {
        return NSFetchRequest<Venue>(entityName: "Venue")
    }

    @NSManaged public var fsqId: String?
    @NSManaged public var address: String?
    @NSManaged public var name: String?
    @NSManaged public var category: String?
    @NSManaged public var distance: Int64
    @NSManaged public var timestamp: Date?

}
