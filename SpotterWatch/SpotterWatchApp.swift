//
//  SpotterWatchApp.swift
//  SpotterWatch Watch App
//

import SwiftUI

@main
struct SpotterWatch_App: App {
	let wcd: WCDelegate
	init() {
		wcd = WCDelegate.shared
	}
	
	var body: some Scene {
		WindowGroup {
			ContentView()
		}
	}
	
}
