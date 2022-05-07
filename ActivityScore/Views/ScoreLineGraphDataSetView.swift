//
//  ScoreLineGraphDataSetView.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 09/03/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import UIKit
import Charts

class ScoreLineGraphDataSetView: LineChartDataSet {

	override init(entries: [ChartDataEntry]?, label: String?) {
		super.init(entries: entries, label: label)
		styleDataSet()
	}

	required init() {
		fatalError("init() has not been implemented")
	}

	private func styleDataSet() {
		self.valueTextColor = .clear
		self.mode = .horizontalBezier

		self.drawCirclesEnabled = false
//		self.setCircleColor(.white)

		self.lineWidth = 3
		self.circleRadius = 1.5
		self.drawFilledEnabled = true

		self.highlightColor = UIColor(named: "pink")!

		self.drawCircleHoleEnabled = false
		self.drawHorizontalHighlightIndicatorEnabled = false
		self.lineCapType = .round

		let firstPink = UIColor(red: 255/255, green: 150/255, blue: 170/255, alpha: 0.05)
		self.colors = [.systemPink]
		let gradientColors = [firstPink.cgColor,
							  UIColor.systemPink.cgColor]
		let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!

		self.fillAlpha = 1
		self.fill = Fill(linearGradient: gradient, angle: 90)
	}
}
