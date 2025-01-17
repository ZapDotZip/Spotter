//
//  CountViewCon.swift
//  Spotter
//

import UIKit

class CountViewCon: UIViewController {
	let appDel = UIApplication.shared.delegate as! AppDelegate
	lazy var context = appDel.persistentContainer.viewContext
	
	@IBOutlet weak var addButton: UIButton!
	@IBOutlet weak var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	@IBAction func addButtonPressed(_ sender: UIButton) {
		print("add button pressed")
		let new = LogEntry(context: context)
		new.date = Date.init()
		if let loc = LocationController.shared.locationManager.location {
			new.lat = loc.coordinate.latitude
			new.lon = loc.coordinate.longitude
		}
		
		dump(new)
		
	}
	
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destination.
		// Pass the selected object to the new view controller.
	}
	
}
