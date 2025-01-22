//
//  SessionManager.swift
//  Spotter
//

import UIKit

class SessionManager {
	let appDel = UIApplication.shared.delegate as! AppDelegate
	lazy var context = appDel.persistentContainer.viewContext
	
	public static let shared = SessionManager()
	private init() {
		if let lastSessionTime = UserDefaults.standard.set(session!.startTime, forKey: "LastSessionStartTime") as? Date {
			context.persistentStoreCoordinator.persis
		}
	}
	
	private var session: Session?
	
	func startNewSession() {
		endSession()
		initSession()
		UserDefaults.standard.set(session!.objectID, forKey: "ActiveSessionBookmark")
	}
	
	private func initSession() {
		session = Session(context: context)
		session!.startTime = Date.init()
	}
	
	func endSession() {
		if let s = session {
			s.endTime = Date.init()
			UserDefaults.standard.set(nil, forKey: "LastSessionStartTime")
		}
	}
	
	func recordEntry() {
		if session == nil {
			initSession()
		}
		
		let new = LogEntry(context: context)
		new.date = Date.init()
		if let loc = LocationController.shared.locationManager.location {
			new.lat = loc.coordinate.latitude
			new.lon = loc.coordinate.longitude
		}
		session!.addToEntries(new)
		dump(session)
	}
	
}
