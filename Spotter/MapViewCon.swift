//
//  MapViewCon.swift
//  Spotter
//

import UIKit
import MapKit

class MapViewCon: UIViewController {
	let appDel = UIApplication.shared.delegate as! AppDelegate
	@IBOutlet weak var mapView: MKMapView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		if let loc = LocationController.shared.locationManager.location {
			mapView.showsUserLocation = true
			mapView.region = .init(center: loc.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
		}
	}
	
	func gatherPoints() -> [MKAnnotation] {
		if let entries = appDel.fetchAllLogEntries() {
			return entries.map { le in
				return LogEntryPoint(le: le, df: appDel.displayDF)
			}
		} else {
			return []
		}
	}
	
	func displayPoints(_ list: [MKAnnotation]) {
		mapView.addAnnotations(list)
	}
	
	@IBAction func refreshDisplay(_ sender: Any) {
		displayPoints(gatherPoints())
	}
	
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destination.
		// Pass the selected object to the new view controller.
	}
	
}

class LogEntryPoint: NSObject, MKAnnotation {
	var title: String?
	var coordinate: CLLocationCoordinate2D
	init(le: LogEntry, df: DateFormatter) {
		title = le.dateString(df: df)
		coordinate = .init(latitude: le.lat, longitude: le.lon)
	}
}
