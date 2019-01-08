//
//  Planet+CoreDataProperties.swift
//  Planets
//
//  Created by Uttarakawatam, Santosh on 07/01/19.
//  Copyright © 2019 Uttarakawatam, Santosh. All rights reserved.
//
//

import Foundation
import CoreData


extension Planet {

    @nonobjc public class func fetchPlanetRequest() -> NSFetchRequest<Planet> {
        return NSFetchRequest<Planet>(entityName: "Planet")
    }

    @NSManaged public var name: String?
    
}

