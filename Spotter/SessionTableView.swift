//
//  LogTableView.swift
//  Spotter
//

import UIKit
import CoreData

class SessionTableView: UITableView {
	let ds = SessionTableDataSource()
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.dataSource = ds
	}
	
}

class SessionTableDataSource: NSObject, UITableViewDataSource {
	let appDel = UIApplication.shared.delegate as! AppDelegate
	var entries: [Session]?
	let dcf = DateComponentsFormatter()

	override init() {
		entries = appDel.fetchAllSessions()
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return entries?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell")!
		cell.textLabel?.lineBreakMode = .byWordWrapping
		cell.textLabel?.numberOfLines = 3
		
		cell.textLabel?.text = entries![indexPath.row].string(df: appDel.briefDF, dcf: dcf)
		return cell
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			appDel.persistentContainer.viewContext.delete(entries![indexPath.row])
			entries?.remove(at: indexPath.row)
			tableView.reloadData()
		}
	}

}
