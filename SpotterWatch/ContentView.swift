//
//  ContentView.swift
//  SpotterWatch Watch App
//

import SwiftUI
import WatchConnectivity

struct ContentView: View {
	@State var inSession = false
	@State var avgRate = "0.0/min"
	@State var sessionStartDate = Date.init()
	let df = DateFormatter()
	let wcd = WCDelegate.shared
	init() {
		df.dateStyle = .none
		df.timeStyle = .short
	}
	var body: some View {
		if !inSession {
			Button("Start Session") {
				inSession = true
				sessionStartDate = Date.init()
			}
		} else {
			VStack {
				Text("Started at \(df.string(from: sessionStartDate))")
				HStack {
					Button("Undo") {
						/*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
					}.tint(.yellow)
					Button("End Session") {
						inSession = false
						/*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
					}.tint(.red)
				}
				Spacer()
				Text(avgRate)
				Button(action: {}) {
					Text("Spot").foregroundStyle(.green).bold()
				}.tint(.green)
				.frame(width: 192.0, height: 72.0)
				.buttonStyle(PlainButtonStyle())
				.background(Capsule().fill(.green).opacity(0.60))
			}
		}
	}
}

#Preview {
    ContentView()
}
