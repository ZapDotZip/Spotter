//
//  SessionManager.swift
//  Spotter
//

import UIKit
import CoreData

class SessionManager {
	let appDel = UIApplication.shared.delegate as! AppDelegate
	lazy var context = appDel.persistentContainer.viewContext
	
	let bookmarkKey = "ActiveSessionBookmark"
	
	public static let shared = SessionManager()
	private init() {
		if let lastSessionBookmark = URL.init(string: UserDefaults.standard.string(forKey: bookmarkKey) ?? "") {
			if let objID = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: lastSessionBookmark), let s = context.object(with: objID) as? Session {
					if s.endTime == nil {
						if s.logEntries?.count != 0 {
							s.endTime = (s.logEntries?.lastObject as? LogEntry)?.date
							s.recalculateAverage()
						} else {
							NSLog("Session \(s.description) did not have any entries so it will be removed from the database.")
							appDel.persistentContainer.viewContext.delete(s)
						}
					}
			} else {
				NSLog("last session exists but was doesn't exist in the database! (\(lastSessionBookmark))")
			}
			UserDefaults.standard.removeObject(forKey: bookmarkKey)
		}
	}
	
	var session: Session?
	
	@discardableResult
	func startNewSession() -> Session {
		endSession()
		return initSession()
	}
	
	@discardableResult
	private func initSession() -> Session {
		session = Session(context: context)
		session!.startTime = Date.init()
		appDel.save(now: true)
		UserDefaults.standard.set(session!.objectID.uriRepresentation().absoluteString, forKey: bookmarkKey)
		return session!
	}
	
	func endSession() {
		if let s = session {
			s.endTime = Date.init()
			s.recalculateAverage()
			appDel.save(now: false)
			UserDefaults.standard.removeObject(forKey: bookmarkKey)
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
		session!.addToLogEntries(new)
		appDel.save(now: false)
	}
	
}
