//
//  AppExercise+CoreDataProperties.swift
//  exercise-tracker
//
//  Created by Dawid Niedźwiecki on 09/06/2024.
//
//

import Foundation
import CoreData


extension AppExercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppExercise> {
        return NSFetchRequest<AppExercise>(entityName: "AppExercise")
    }

    @NSManaged public var date: Date?
    @NSManaged public var duration: Int32
    @NSManaged public var app_activity: AppActivity?

}

extension AppExercise : Identifiable {

}
