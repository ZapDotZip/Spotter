//
//  AppDelegate.swift
//  Spotter
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	var viewCon: TabViewController!
	var dfFullDate = DateFormatter()
	var dfTimeOnly = DateFormatter()
	var briefDF = DateFormatter()
	var dbm: DatabaseManager!

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		dbm = DatabaseManager(self)
		dfFullDate.dateFormat = "yyyy-MM-dd 'at' h:mm:ss a"
		dfTimeOnly.dateStyle = .none
		dfTimeOnly.timeStyle = .medium
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
		dbm.save(now: true)
	}
	
	func applicationDidEnterBackground(_ application: UIApplication) {
		dbm.save(now: true)
	}
	
	func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
		dbm.save(now: true)
	}
	
}

