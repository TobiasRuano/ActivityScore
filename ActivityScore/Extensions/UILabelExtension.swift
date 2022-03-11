//
//  UILabelExtension.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 10/03/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import UIKit

extension UILabel {

	func incrementLabel(from startValue: Int, to endValue: Int, in seconds: Double) {
		if startValue != endValue {
			let duration: Double = seconds
			var startNumber = 0
			var endNumber = endValue
			if startValue < endValue {
				startNumber = startValue

				DispatchQueue.global().async {
					for i in startNumber ..< (endNumber + 1) {
						let sleepTime = UInt32(duration/Double(endNumber) * 1000000.0)
						usleep(sleepTime)
						DispatchQueue.main.async {
							self.text = "\(i)"
						}
					}
				}
			} else {
				startNumber = endValue
				endNumber = startValue

				DispatchQueue.global().async {
					for i in (startNumber ..< (endNumber)).reversed() {
						let sleepTime = UInt32(duration/Double(endNumber) * 1000000.0)
						usleep(sleepTime)
						DispatchQueue.main.async {
							self.text = "\(i)"
						}
					}
				}
			}
		} else {
			self.text = "\(startValue)"
		}
	}

}
