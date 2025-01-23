//
//  CountViewCon.swift
//  Spotter
//

import UIKit

class CountViewCon: UIViewController {
	
	@IBOutlet weak var addButton: UIButton!
	@IBOutlet weak var tableView: SessionTableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	@IBAction func addButtonPressed(_ sender: UIButton) {
		endSessionButton.isEnabled = true
		SessionManager.shared.recordEntry()
		updateRate(SessionManager.shared.session?.recalculateAverage() ?? 0.0)
	}
	
	
	@IBOutlet weak var startSessionButton: UIButton!
	@IBAction func startSessionButtonPressed(_ sender: UIButton) {
		endSessionButton.isEnabled = true
		tableView.ds.appendSession(SessionManager.shared.startNewSession())
	}
	
	
	@IBOutlet weak var endSessionButton: UIButton!
	@IBAction func endSessionButtonPressed(_ sender: UIButton) {
		SessionManager.shared.endSession()
		endSessionButton.isEnabled = false
	}
	
	@IBOutlet weak var rateLabel: UILabel!
	func updateRate(_ rate: Double) {
		rateLabel.text = "\(String(format: "%.2f", rate))/min"
	}
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destination.
		// Pass the selected object to the new view controller.
	}
	
}
