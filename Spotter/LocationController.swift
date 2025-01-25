//
//  LocationController.swift
//  Spotter
//

import UIKit
import CoreLocation

class LocationController: NSObject, CLLocationManagerDelegate {
	let locationManager = CLLocationManager()
	
	static let shared = LocationController()
	private override init() {
		super.init()
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestWhenInUseAuthorization()
	}
	
	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		NSLog("LocationController: auth status: \(manager.authorizationStatus)")
		switch manager.authorizationStatus {
		case .notDetermined:
			NSLog("LocationController: user probably hasn't been prompted.")
		case .denied, .restricted:
			NSLog("LocationController: user denied access")
		case .authorizedWhenInUse, .authorizedAlways:
			NSLog("LocationController: authorized, requesting location...")
			locationManager.requestLocation()
			locationManager.startUpdatingLocation()
		default:
			NSLog("LocationController: unkown auth status")
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
		NSLog("LocationController failed with: \(error)")
	}
	
}
