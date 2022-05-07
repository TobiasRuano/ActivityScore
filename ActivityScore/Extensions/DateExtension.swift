//
//  DateExtension.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 05/03/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import Foundation

extension Date {
	public var removeTimeStamp: Date? {
		guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year,
																					  .month,
																					  .day], from: self)) else {
			return nil
		}
		return date
	}

	func getDayOfWeekName() -> String {
		var dayNameString = ""
		let formatter = DateFormatter()
		formatter.dateFormat = "E, d MMM yyyy"

		let today = Date()
		let interval = TimeInterval(-86400)
		let yesterday = Date(timeInterval: interval, since: today)

		let todayText = formatter.string(from: today)
		let yesterdayText = formatter.string(from: yesterday)
		let dateText = formatter.string(from: self)

		if dateText == todayText {
			return "Today"
		} else if dateText == yesterdayText {
			return "Yesterday"
		}

		dayNameString = formatter.string(from: self)
		dayNameString.capitalizeFirstLetter()

		return dayNameString
	}
}
