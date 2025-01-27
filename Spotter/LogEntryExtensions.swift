//
//  LogEntryExtensions.swift
//  Spotter
//

import Foundation

extension LogEntry {
	func string(df: DateFormatter) -> String {
		return df.string(from: date!) + " at " + String(format: "%.5f", lat) + ", " + String(format: "%.5f", lon)
	}
	
	func dateString(df: DateFormatter) -> String {
		return df.string(from: date!)
	}
}

extension Session {
	func duration() -> TimeInterval {
		return startTime!.distance(to: endTime ?? Date.init())
	}
	
	/// Returns duration as a string
	/// - Parameter dcf: The format to use for the duration.
	/// - Returns: The formatted string.
	func string(_ dcf: DateComponentsFormatter) -> String {
		return dcf.string(from: duration()) ?? "Unknown duration"
	}
	
	/// Returns a string containing the start time and duration.
	/// - Parameters:
	///   - df: The format for the start time.
	///   - dcf: The format for the duration.
	/// - Returns: The formatted string.
	func string(df: DateFormatter, dcf: DateComponentsFormatter) -> String {
		return "\(df.string(from: startTime!)), lasting \(dcf.string(from: duration()) ?? "unkown")"
	}
	
	/// Returns a string containing the start time.
	/// - Parameter df: The format for the start time.
	/// - Returns: The formatted string.
	func string(df: DateFormatter) -> String {
		return df.string(from: startTime!)
	}
	
	@discardableResult
	func recalculateAverage() -> Double {
		let duration = startTime!.distance(to: endTime ?? Date.init())
		avgPerMinuite = ((Double(logEntries?.count ?? 0)) / duration) * 60
		return avgPerMinuite
	}
}
