//
//  AppActivity+CoreDataProperties.swift
//  exercise-tracker
//
//  Created by Dawid Niedźwiecki on 09/06/2024.
//
//

import Foundation
import CoreData


extension AppActivity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppActivity> {
        return NSFetchRequest<AppActivity>(entityName: "AppActivity")
    }

    @NSManaged public var name: String?
    @NSManaged public var app_exercises: NSSet?

}

// MARK: Generated accessors for app_exercises
extension AppActivity {

    @objc(addApp_exercisesObject:)
    @NSManaged public func addToApp_exercises(_ value: AppExercise)

    @objc(removeApp_exercisesObject:)
    @NSManaged public func removeFromApp_exercises(_ value: AppExercise)

    @objc(addApp_exercises:)
    @NSManaged public func addToApp_exercises(_ values: NSSet)

    @objc(removeApp_exercises:)
    @NSManaged public func removeFromApp_exercises(_ values: NSSet)

}

extension AppActivity : Identifiable {

}
