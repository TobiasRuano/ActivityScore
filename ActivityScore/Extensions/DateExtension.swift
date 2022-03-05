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
}
