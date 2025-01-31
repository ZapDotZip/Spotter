//
//  WCDelegate.swift
//  SpotterWatch Watch App
//

import UIKit
import WatchConnectivity

class WCDelegate: NSObject, WCSessionDelegate {
	let wcs: WCSession
	
	static let shared = WCDelegate()
	override init() {
		wcs = WCSession.default
		super.init()
		wcs.delegate = self
		wcs.activate()
	}
	
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
		if let err = error {
			NSLog("Error connecting via WCDelegate: \(err)")
		}
	}
	
}
