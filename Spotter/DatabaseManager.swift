//
//  DatabaseManager.swift
//  Spotter
//

import CoreData

class DatabaseManager {
	let appDel: AppDelegate
	let fetchLogEntries = NSFetchRequest<NSManagedObject>(entityName: "LogEntry")
	let fetchSessions = NSFetchRequest<NSManagedObject>(entityName: "Session")
	
	let dq: DispatchQueue
	
	var persistentContainer: NSPersistentContainer
	init(_ ad: AppDelegate) {
		appDel = ad
		persistentContainer = {
			let container = NSPersistentContainer(name: "Spotter")
			container.loadPersistentStores(completionHandler: { (storeDescription, error) in
				if let error = error as NSError? {
					// Replace this implementation with code to handle the error appropriately.
					// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
					/*
					 Typical reasons for an error here include:
					 * The parent directory does not exist, cannot be created, or disallows writing.
					 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
					 * The device is out of space.
					 * The store could not be migrated to the current model version.
					 Check the error message to determine what the actual problem was.
					 */
					fatalError("Unresolved error \(error), \(error.userInfo)")
				}
			})
			return container
		}()
		fetchLogEntries.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
		fetchSessions.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: true)]
		
		dq = DispatchQueue(label: "CoreData", qos: .utility)
	}
	
	func fetchAllLogEntries() -> [LogEntry]? {
		do {
			if let entries = try persistentContainer.viewContext.fetch(fetchLogEntries) as? [LogEntry] {
				return entries
			}
		} catch {
			NSLog("Failed to fetch entries from Core Data: \(error)")
			appDel.viewCon.alert(title: "Failed to fetch data", msg: "Unable to fetch log entries from the database.", style: .alert)
		}
		return nil
	}
	
	func fetchAllSessions() -> [Session]? {
		do {
			if let entries = try persistentContainer.viewContext.fetch(fetchSessions) as? [Session] {
				return entries
			}
		} catch {
			NSLog("Failed to fetch entries from Core Data: \(error)")
			appDel.viewCon.alert(title: "Failed to fetch data", msg: "Unable to fetch log entries from the database.", style: .alert)
		}
		return nil
	}
	
	// MARK: - Core Data Saving support
	
	@objc private func saveContext() {
		if persistentContainer.viewContext.hasChanges {
			do {
				try persistentContainer.viewContext.save()
				NSLog("Saved Core Data.")
			} catch {
				// Replace this implementation with code to handle the error appropriately.
				// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
	
	var timer: Timer?
	/// Saves the Core Data DB now or after a timer elapses.
	/// - Parameter now: Saves data now if set to true, or sets a timer to wait for additional changes.
	func save(now: Bool) {
		if now {
			timer?.invalidate()
			saveContext()
		} else {
			if timer == nil || timer?.timeInterval ?? 0 < 3 {
				timer = Timer.scheduledTimer(timeInterval: 25, target: self, selector: #selector(saveContext), userInfo: nil, repeats: false)
			}
		}
	}
	
}
