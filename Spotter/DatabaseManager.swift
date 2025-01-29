//
//  DatabaseManager.swift
//  Spotter
//

import CoreData

class DatabaseManager {
	let appDel: AppDelegate
	let fetchLogEntries = NSFetchRequest<LogEntry>(entityName: "LogEntry")
	let fetchSessions = NSFetchRequest<Session>(entityName: "Session")
		
	private var persistentContainer: NSPersistentContainer
	var context: NSManagedObjectContext
	var bgContext: NSManagedObjectContext
	init(_ ad: AppDelegate) {
		appDel = ad
		persistentContainer = {
			let container = NSPersistentContainer(name: "Spotter")
			container.loadPersistentStores(completionHandler: { (storeDescription, error) in
				if let error = error as NSError? {
					/*
					 Typical reasons for an error here include:
					 * The parent directory does not exist, cannot be created, or disallows writing.
					 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
					 * The device is out of space.
					 * The store could not be migrated to the current model version.
					 Check the error message to determine what the actual problem was.
					 */
					NSLog("Error opening database: \(error)")
					ad.viewCon.alert(title: "An error occured trying to load the database.", msg: "The database may be corrupted.\nError: \(error.localizedDescription)", style: .alert)
//					fatalError("Unresolved error \(error), \(error.userInfo)")
				}
			})
			return container
		}()
		
		context = persistentContainer.viewContext
		bgContext = persistentContainer.newBackgroundContext()
		bgContext.automaticallyMergesChangesFromParent = true
		
		fetchLogEntries.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
		fetchSessions.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: true)]
	}
		
	func object(from url: URL) -> NSManagedObject? {
		if let objID = bgContext.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: url) {
			return bgContext.object(with: objID)
		} else {
			return nil
		}
	}
	
	func newSession() -> Session {
		return Session(context: context)
	}
	
	func newLogEntry() -> LogEntry {
		LogEntry(context: context)
	}
	
	func delete(_ obj: NSManagedObject) {
		self.bgContext.delete(obj)
	}
	
	
	func fetchAllLogEntries() -> [LogEntry]? {
		do {
			return try context.fetch(fetchLogEntries)
		} catch {
			NSLog("Failed to fetch entries from Core Data: \(error)")
			appDel.viewCon.alert(title: "Failed to fetch data", msg: "Unable to fetch log entries from the database.", style: .alert)
		}
		return nil
	}
	
	func fetchAllSessions() -> [Session]? {
		do {
			return try context.fetch(fetchSessions)
		} catch {
			NSLog("Failed to fetch entries from Core Data: \(error)")
			appDel.viewCon.alert(title: "Failed to fetch data", msg: "Unable to fetch log entries from the database.", style: .alert)
		}
		return nil
	}
	
	// MARK: - Core Data Saving support
	
	@objc private func saveContext() {
		if context.hasChanges {
			do {
				try context.save()
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
