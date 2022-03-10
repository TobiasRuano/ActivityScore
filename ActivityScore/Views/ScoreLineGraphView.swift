//
//  ScoreLineGraphView.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 09/03/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import UIKit
import Charts

class ScoreLineGraphView: LineChartView {

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		styleChart()
	}

	func styleChart() {
		self.dragEnabled = false
		self.pinchZoomEnabled = false
		self.isUserInteractionEnabled = false
		self.autoScaleMinMaxEnabled = false
		self.setScaleEnabled(false)

		self.setExtraOffsets(left: 10, top: 10, right: 20, bottom: 20)
		self.drawBordersEnabled = false
		self.chartDescription?.enabled = false
		self.legend.enabled = false

		self.xAxis.enabled = true
		self.xAxis.drawGridLinesEnabled = false
		self.xAxis.axisLineColor = .systemGray4
		self.xAxis.axisLineWidth = 1
		self.xAxis.gridColor = .systemGray4
		self.xAxis.labelTextColor = .systemGray4
		self.xAxis.gridLineWidth = 1
		self.xAxis.gridLineDashLengths = [5, 10]
		self.xAxis.labelPosition = .bottom
		self.xAxis.labelCount = 7

		self.xAxis.labelFont = .systemFont(ofSize: 15, weight: .semibold)

		self.leftAxis.enabled = true
		self.leftAxis.axisLineWidth = 1
		self.leftAxis.axisLineColor = .systemGray4
		self.leftAxis.labelTextColor = .systemGray4
		self.leftAxis.gridColor = .systemGray4
		self.leftAxis.drawGridLinesEnabled = false
		self.leftAxis.gridLineWidth = 1
		self.leftAxis.gridLineDashLengths = [5, 10]
		self.leftAxis.labelCount = 5

		self.leftAxis.axisMinimum = 0

		self.leftAxis.labelFont = .systemFont(ofSize: 15, weight: .semibold)

		self.rightAxis.enabled = false

		self.drawGridBackgroundEnabled = false
		self.layer.cornerRadius = 15
		self.clipsToBounds = false
		self.layer.masksToBounds = true
		self.noDataFont = UIFont.systemFont(ofSize: 15, weight: .semibold)
		self.noDataText = ""
	}
}
