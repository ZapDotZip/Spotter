//
//  SessionTable.swift
//  Spotter
//

import UIKit
import CoreData

class SessionTableView: UITableView {
	let ds = SessionTableDataSource()
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.dataSource = ds
		self.delegate = ds
		ds.tableView = self
	}
	
}

class SessionTableDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
	private let appDel: AppDelegate
	private let dbm: DatabaseManager
	var entries: [Session] = []
	let dcf = DateComponentsFormatter()
	var tableView: UITableView!

	override init() {
		appDel = UIApplication.shared.delegate as! AppDelegate
		dbm = appDel.dbm
		entries = dbm.fetchAllSessions() ?? []
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
			dbm.delete(entries[indexPath.row])
			dbm.save(now: false)
			entries.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .automatic)
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		appDel.viewCon.switchToMapsView(display: entries[indexPath.row])
	}
	
	func appendSession(_ session: Session) {
		entries.append(session)
		tableView.insertRows(at: [IndexPath.init(row: entries.count - 1, section: 0)], with: .automatic)
	}
	
}
