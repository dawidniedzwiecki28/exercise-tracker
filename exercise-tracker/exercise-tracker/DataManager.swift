import Foundation
import CoreData

class DataManager {
    static let shared = DataManager()

    let persistentContainer: NSPersistentContainer

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private init() {
        persistentContainer = NSPersistentContainer(name: "exercise_tracker")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func getAllActivities() -> [Activity] {
        let fetchRequest: NSFetchRequest<Activity> = Activity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "orderIndex", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching activities: \(error)")
            return []
        }
    }

    func createActivity(name: String) {
        let activity = Activity(context: context)
        activity.name = name
        activity.orderIndex = Int16(getAllActivities().count)
        saveContext()
    }

    func deleteActivity(activity: Activity) {
        context.delete(activity)
        saveContext()
        updateOrderIndices()
    }

    func updateOrderIndices() {
        let activities = getAllActivities()
        for (index, activity) in activities.enumerated() {
            activity.orderIndex = Int16(index)
        }
        saveContext()
    }

    func getAllExercises() -> [Exercise] {
        let fetchRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching exercises: \(error)")
            return []
        }
    }

    func getAllExercisesWith(activity: Activity) -> [Exercise] {
        let fetchRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "activity == %@", activity)
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching exercises for activity: \(error)")
            return []
        }
    }


    func createExercise(date: Date, duration: Int, activity: Activity) {
        let exercise = Exercise(context: context)
        exercise.date = date
        exercise.duration = Int16(duration)
        exercise.activity = activity
        saveContext()
    }

    func updateExercise(exercise: Exercise, date: Date, duration: Int, activity: Activity) {
        exercise.date = date
        exercise.duration = Int16(duration)
        exercise.activity = activity
        saveContext()
    }

    func deleteExercise(exercise: Exercise) {
        context.delete(exercise)
        saveContext()
    }
}

