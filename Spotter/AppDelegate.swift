//
//  AppDelegate.swift
//  Spotter
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	var viewCon: ViewController!
	var displayDF = DateFormatter()
	var briefDF = DateFormatter()

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		fetchLogEntries.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
		fetchSessions.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: true)]
		displayDF.dateFormat = "yyyy-MM-dd 'at' h:mm:ss a"
		briefDF.dateFormat = "EEE, MMM d, h:mm a"
		_ = SessionManager.shared
		return true
	}
	
	// MARK: UISceneSession Lifecycle
	
	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		// Called when the user discards a scene session.
		// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
	}
	
	func applicationWillTerminate(_ application: UIApplication) {
		saveContext()
	}
	
	func applicationDidEnterBackground(_ application: UIApplication) {
		saveContext()
	}
	
	func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
		saveContext()
	}
	
	// MARK: - Core Data stack
	
	lazy var persistentContainer: NSPersistentContainer = {
		/*
		 The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
		*/
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
	
	let fetchLogEntries = NSFetchRequest<NSManagedObject>(entityName: "LogEntry")
	let fetchSessions = NSFetchRequest<NSManagedObject>(entityName: "Session")

	func fetchAllLogEntries() -> [LogEntry]? {
		do {
			if let entries = try persistentContainer.viewContext.fetch(fetchLogEntries) as? [LogEntry] {
				return entries
			}
		} catch {
			NSLog("Failed to fetch entries from Core Data: \(error)")
			viewCon.alert(title: "Failed to fetch data", msg: "Unable to fetch log entries from the database.", style: .alert)
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
			viewCon.alert(title: "Failed to fetch data", msg: "Unable to fetch log entries from the database.", style: .alert)
		}
		return nil
	}
	
	
	// MARK: - Core Data Saving support
	
	func saveContext () {
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
	
}

extension LogEntry {
	func string(df: DateFormatter) -> String {
		return df.string(from: date!) + " at " + String(format: "%.5f", lat) + ", " + String(format: "%.5f", lon)
	}
	
	func dateString(df: DateFormatter) -> String {
		return df.string(from: date!)
	}
}

extension Session {
	func duration() -> TimeInterval {
		return startTime!.distance(to: endTime ?? Date.init())
	}
	
	func string(_ dcf: DateComponentsFormatter) -> String {
		return dcf.string(from: duration()) ?? startTime!.description
	}
	
	func string(df: DateFormatter, dcf: DateComponentsFormatter) -> String {
		return "\(df.string(from: startTime!)), lasting \(dcf.string(from: duration()) ?? "unkown")"
	}
}
