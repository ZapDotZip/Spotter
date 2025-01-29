//
//  SessionManager.swift
//  Spotter
//

import UIKit
import CoreData

class SessionManager {
	let appDel = UIApplication.shared.delegate as! AppDelegate
	lazy var dbm: DatabaseManager = appDel.dbm
	
	let bookmarkKey = "ActiveSessionBookmark"
	
	public static let shared = SessionManager()
	private init() {
		if let lastSessionBookmark = URL.init(string: UserDefaults.standard.string(forKey: bookmarkKey) ?? "") {
			if let s = dbm.object(from: lastSessionBookmark) as? Session {
					if s.endTime == nil {
						if s.logEntries?.count != 0 {
							s.endTime = (s.logEntries?.lastObject as? LogEntry)?.date
							s.recalculateAverage()
						} else {
							NSLog("Session \(s.description) did not have any entries so it will be removed from the database.")
							dbm.delete(s)
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
		session = dbm.newSession()
		session!.startTime = Date.init()
		dbm.save(now: true)
		UserDefaults.standard.set(session!.objectID.uriRepresentation().absoluteString, forKey: bookmarkKey)
		return session!
	}
	
	func endSession() {
		if let s = session {
			s.endTime = Date.init()
			s.recalculateAverage()
			dbm.save(now: true)
			UserDefaults.standard.removeObject(forKey: bookmarkKey)
		}
	}
	
	func recordEntry() {
		if session == nil {
			initSession()
		}
		
		let new = dbm.newLogEntry()
		new.date = Date.init()
		if let loc = LocationController.shared.locationManager.location {
			new.lat = loc.coordinate.latitude
			new.lon = loc.coordinate.longitude
		}
		session!.addToLogEntries(new)
		dbm.save(now: false)
	}
	
}
