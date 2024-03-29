//
//  Place+CoreDataProperties.swift
//  Assignment1_Attempt2
//
//  Created by Shahrooq Pathan on 3/9/19.
//  Copyright © 2019 Shahrooq Pathan. All rights reserved.
//
//

import Foundation
import CoreData


extension Place {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Place> {
        return NSFetchRequest<Place>(entityName: "Place")
    }

    @NSManaged public var name: String?
    @NSManaged public var desc: String?
    @NSManaged public var icon: String?
    @NSManaged public var photo: String?
    @NSManaged public var lat: Double
    @NSManaged public var long: Double
    @NSManaged public var shortdesc: String?
    
}
