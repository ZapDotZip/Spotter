//
//  LogTableView.swift
//  Spotter
//

import UIKit
import CoreData

class LogTableView: UITableView {
	let ds = LogEntryTableDataSource()
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.dataSource = ds
	}
	
}

class LogEntryTableDataSource: NSObject, UITableViewDataSource {
	let appDel = UIApplication.shared.delegate as! AppDelegate
	let df = DateFormatter()
	var entries: [LogEntry]?

	override init() {
		entries = appDel.fetchAllLogEntries()
		df.dateFormat = "yyyy-MM-dd 'at' h:mm:ss a"
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
		
		cell.textLabel?.text = entries![indexPath.row].string(df: df)
		return cell
	}

}
