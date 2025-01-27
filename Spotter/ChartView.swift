//
//  ChartView.swift
//  Spotter
//

import Foundation
import SwiftUI
import Charts

class ChartHostingController : UIHostingController<ChartView> {
	var cv = ChartView()
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder, rootView: cv)
	}
	
	func updateCharts(timeOfDay: [ChartData], timeOfYear: [ChartData]) {
		cv.dataToD = timeOfDay
		cv.dataToY = timeOfYear
	}
	
	override func viewWillAppear(_ animated: Bool) {
		updateCharts(timeOfDay: [], timeOfYear: [])
		super.viewWillAppear(animated)
	}
	
}

class ChartData: Identifiable {
	let category: String
	let count: Int
	let id = UUID()
	init(category: String, count: Int) {
		self.category = category
		self.count = count
	}
}

struct ChartView : View {
	var dataToD: [ChartData] = []
	var dataToY: [ChartData] = []

	var body: some View {
		Label("Time of Day", systemImage: "clock")
		if dataToD.count == 0 {
			ProgressView()
		} else {
			Chart {
				ForEach(dataToD) { ToD in
					BarMark(
						x: .value("Time of Day", ToD.category),
						y: .value("Total Count", ToD.count)
					)
				}
			}
		}
		Label("Time of Year", systemImage: "calendar")
		if dataToY.count == 0 {
			ProgressView()
		} else {
			Chart {
				ForEach(dataToY) { ToY in
					BarMark(
						x: .value("Time of Day", ToY.category),
						y: .value("Total Count", ToY.count)
					)
				}
			}
		}
	}
}
