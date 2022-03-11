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
			let endNumber = endValue
			if startValue < endValue {
				startNumber = startValue

				DispatchQueue.global().async {
					for i in startNumber ..< (endNumber + 1) {
						var sleepNum: Double = Double(endNumber - i)
						if sleepNum == 0 {
							sleepNum = Double(endNumber - i + 1) * 0.9
						} else if sleepNum < 10 {
							sleepNum = Double(endNumber - i) * 0.9
						}

						let sleepTime = UInt32(duration/Double(sleepNum) * 200000.0)
						usleep(sleepTime)
						DispatchQueue.main.async {
							self.text = "\(i)"
						}
					}
				}
			} else {
				startNumber = startValue

				DispatchQueue.global().async {
					for i in endNumber ..< (startNumber + 1) {
						var sleepNum: Double = Double(startNumber - i)
						if sleepNum == 0 {
							sleepNum = Double(startNumber - i + 1) * 0.9
						} else if sleepNum < 10 {
							sleepNum = Double(startNumber - i) * 0.9
						}

						let sleepTime = UInt32(duration/Double(sleepNum) * 200000.0)
						usleep(sleepTime)
						DispatchQueue.main.async {
							self.text = "\(startNumber - i)"
						}
					}
				}
			}
		} else {
			self.text = "\(startValue)"
		}
	}

}
