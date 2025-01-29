//
//  SettingsViewController.swift
//  Spotter
//

import Foundation
import UIKit

class SettingsViewController: UITableViewController {
	private let appDel = UIApplication.shared.delegate as! AppDelegate
	public static let mapDisplayTypeKey = "MapDisplayType"

	@IBOutlet weak var mapDisplayTypeControl: UISegmentedControl!
	
	override func viewDidLoad() {
		if let mapDT = UserDefaults.standard.string(forKey: SettingsViewController.mapDisplayTypeKey) {
			if mapDT == "Static" {
				mapDisplayTypeControl.selectedSegmentIndex = 0
			} else if mapDT == "Balloons" {
				mapDisplayTypeControl.selectedSegmentIndex = 1
			}
		}
	}
	
	@IBAction func mapDisplayTypeChanged(_ sender: UISegmentedControl) {
		print(sender.selectedSegmentIndex)
		if sender.selectedSegmentIndex == 0 {
			UserDefaults.standard.set("Static", forKey: SettingsViewController.mapDisplayTypeKey)
		} else if sender.selectedSegmentIndex == 1 {
			UserDefaults.standard.set("Balloons", forKey: SettingsViewController.mapDisplayTypeKey)
		}
	}
	
	@IBAction func resetDatabaseButtonPressed(_ sender: UIButton) {
		appDel.dbm.resetDatabase()
	}
	
}
