//
//  MapViewCon.swift
//  Spotter
//

import UIKit
import MapKit

class MapViewCon: UIViewController {
	private let mvd = CustomMapViewDelegate()
	
	let appDel = UIApplication.shared.delegate as! AppDelegate
	lazy var dbm = appDel.dbm!
	@IBOutlet weak var mapView: MKMapView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setDisplayModePref()
		UserDefaults.standard.addObserver(self, forKeyPath: SettingsViewController.mapDisplayTypeKey, options: .new, context: nil)
		if let loc = LocationController.shared.locationManager.location {
			mapView.showsUserLocation = true
			if #available(iOS 17.0, *) {
				mapView.showsUserTrackingButton = true
			}
			mapView.region = .init(center: loc.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
		}
	}
	
	func setDisplayModePref() {
		if UserDefaults.standard.string(forKey: SettingsViewController.mapDisplayTypeKey) == "Static" {
			mapView.delegate = mvd
		} else {
			mapView.delegate = nil
		}
	}
	
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if keyPath == SettingsViewController.mapDisplayTypeKey {
			setDisplayModePref()
			displayPoints(lastDisplayedPoints)
		}
	}
	
	func gatherPoints(from entries: [LogEntry]) -> [MKAnnotation] {
		return entries.map { le in
			return LogEntryPoint(le: le, df: appDel.dfFullDate)
		}
	}
	
	private var lastDisplayedPoints: [MKAnnotation] = []
	func displayPoints(_ list: [MKAnnotation]) {
		lastDisplayedPoints = list
		mapView.removeAnnotations(mapView.annotations)
		mapView.addAnnotations(list)
		
	}
	
	
	@IBOutlet weak var refreshDisplayButton: UIButton!
	@IBAction func refreshDisplay(_ sender: UIButton) {
		if let entries = dbm.fetchAllLogEntries() {
			displayPoints(gatherPoints(from: entries))
		} else {
			displayPoints([])
		}
	}
	
	func showEntries(from s: Session) {
		if let entries = s.logEntries {
			displayPoints(entries.map { le in
				LogEntryPoint(le: le as! LogEntry, df: appDel.dfTimeOnly)
			})
		}
	}
	
	func LogEntryPoint(le: LogEntry, df: DateFormatter) -> MKPointAnnotation {
		let pa = MKPointAnnotation.init()
		pa.coordinate = .init(latitude: le.lat, longitude: le.lon)
		pa.title = le.dateString(df: df)
		return pa
	}
	
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destination.
		// Pass the selected object to the new view controller.
	}
	
}

//class LogEntryPoint: NSObject, MKAnnotation {
//	var title: String?
//	var coordinate: CLLocationCoordinate2D
//	init(le: LogEntry, df: DateFormatter) {
//		title = le.dateString(df: df)
//		coordinate = .init(latitude: le.lat, longitude: le.lon)
//	}
//}
