//
//  CountViewCon.swift
//  Spotter
//

import UIKit

class CountViewCon: UIViewController {
	@IBOutlet weak var addButton: UIButton!
	@IBOutlet weak var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	@IBAction func addButtonPressed(_ sender: UIButton) {
		print("add button pressed")
	}
	
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destination.
		// Pass the selected object to the new view controller.
	}
	
	
}
