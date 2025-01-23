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
		ds.tableView = self
	}
	
}

class SessionTableDataSource: NSObject, UITableViewDataSource {
	private let appDel = UIApplication.shared.delegate as! AppDelegate
	var entries: [Session] = []
	let dcf = DateComponentsFormatter()
	var tableView: UITableView!

	override init() {
		entries = appDel.fetchAllSessions() ?? []
		dcf.unitsStyle = .abbreviated
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return entries.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "sessionTableCell")!
		cell.textLabel?.lineBreakMode = .byWordWrapping
		cell.textLabel?.numberOfLines = 3
		
		
		cell.textLabel?.text = entries[indexPath.row].string(df: appDel.briefDF, dcf: dcf)
//		cell.detailTextLabel?.text = "\(entries?[indexPath.row].logEntries?.count ?? 0)"
		cell.detailTextLabel?.text = "\(String(format: "%.2f", entries[indexPath.row].avgPerMinuite))/min"
		return cell
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			appDel.persistentContainer.viewContext.delete(entries[indexPath.row])
			entries.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .automatic)
		}
	}
	
	
	func appendSession(_ session: Session) {
		entries.append(session)
		tableView.insertRows(at: [IndexPath.init(row: entries.count - 1, section: 0)], with: .automatic)
	}
	
}
