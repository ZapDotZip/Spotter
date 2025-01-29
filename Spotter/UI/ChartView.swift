//
//  ChartView.swift
//  Spotter
//

import Foundation
import SwiftUI
import Charts

class ChartHostingController : UIHostingController<ChartView> {
	var cv: ChartView
	let appDel = UIApplication.shared.delegate as! AppDelegate
	required init?(coder aDecoder: NSCoder) {
		cv = ChartView(appDel: appDel)
		super.init(coder: aDecoder, rootView: cv)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	
}

class ChartData: Identifiable {
	let category: String
	var count: Int
	let id = UUID()
	init(category: String, count: Int) {
		self.category = category
		self.count = count
	}
}



struct ChartView : View {
	var appDel: AppDelegate
	@State private var dataIsReady: Bool = false
	@State var dataToD: [ChartData] = []
	@State var dataToY: [ChartData] = []
		
	mutating func updateCharts(timeOfDay: [ChartData], timeOfYear: [ChartData]) {
		dataToD = timeOfDay
		dataToY = timeOfYear
	}
	var body: some View {
		if dataIsReady {
			Label("Time of Day", systemImage: "clock")
			Chart {
				ForEach(dataToD) { ToD in
					BarMark(
						x: .value("Time of Day", ToD.category),
						y: .value("Total Count", ToD.count)
					)
				}
			}.chartXAxis {
				AxisMarks(
					values: ["12 am" , "3 am", "6 am", "9 am", "12 pm", "3 pm", "6 pm", "9 pm"]
				)
			}
			Label("Time of Year", systemImage: "calendar")
			Chart {
				ForEach(dataToY) { ToY in
					BarMark(
						x: .value("Time of Year", ToY.category),
						y: .value("Total Count", ToY.count)
					)
				}
			}

		} else {
			ProgressView().onAppear(perform: load)
		}
	}
	
	let dcf = DateComponentsFormatter()
	func load() {
		dataToD = [ChartData]()
		for i in 1...12 {
			dataToD.append(.init(category: "\(i) am", count: 0))
		}
		for i in 1...12 {
			dataToD.append(.init(category: "\(i) pm", count: 0))
		}
		let sessions = appDel.dbm.fetchAllSessions()
		for session in sessions ?? [] {
			for entry in session.logEntries ?? [] {
				let hr = Calendar.current.dateComponents([.hour], from: (entry as! LogEntry).date!).hour! - 1
				dataToD[hr].count += 1
			}
		}
		
		dataToY = [ChartData]()
		for i in 1...52 {
			dataToY.append(.init(category: "\(i)", count: 0))
		}
		for session in sessions ?? [] {
			for entry in session.logEntries ?? [] {
				let week = Calendar.current.dateComponents([.weekOfYear], from: (entry as! LogEntry).date!)
				dataToY[week.weekOfYear!].count += 1
			}
		}

		
		dataIsReady = true
	}

}
