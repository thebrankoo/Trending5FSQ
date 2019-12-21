//
//  Venue+CoreDataClass.swift
//  Trending5FSQ
//
//  Created by Branko Popovic on 12/20/19.
//  Copyright © 2019 Branko Popovic. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Venue)
public class Venue: NSManagedObject {
    static let entityName = "Venue"
    
    static func make(withManagedObjectContext managedCtx: NSManagedObjectContext) -> Venue {
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedCtx)!
        let venue = Venue(entity: entity, insertInto: managedCtx)
        return venue
    }
}
