//
//  Exercise+CoreDataProperties.swift
//  exercise-tracker
//
//  Created by Dawid Niedźwiecki on 09/06/2024.
//
//

import Foundation
import CoreData


extension Exercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }

    @NSManaged public var date: Date?
    @NSManaged public var duration: Int16
    @NSManaged public var activity: Activity?

}

extension Exercise : Identifiable {

}
