//
//  Fitness+CoreDataProperties.swift
//  HealthyLife
//
//  Created by Victor Melcon Diez on 26/5/22.
//
//

import Foundation
import CoreData


extension Fitness {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Fitness> {
        return NSFetchRequest<Fitness>(entityName: "Fitness")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var type: FitnessType
    @NSManaged public var modifDate: Date?
    @NSManaged public var reps: Int16
    @NSManaged public var weight: Int16
    @NSManaged public var time: Int16
}

extension Fitness : Identifiable {

}
