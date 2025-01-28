//
//  LogTable.swift
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
	let appDel: AppDelegate
	let dbm: DatabaseManager
	var entries: [LogEntry]?
	
	override init() {
		appDel = UIApplication.shared.delegate as! AppDelegate
		dbm = appDel.dbm
		entries = dbm.fetchAllLogEntries()
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
		
		cell.textLabel?.text = entries![indexPath.row].string(df: appDel.dfFullDate)
		return cell
	}
	
}
