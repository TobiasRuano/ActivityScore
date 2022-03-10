//
//  LineGraphViewController.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 01/03/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import UIKit
import Charts

class LineGraphViewController: UIViewController {

    var data: [Dictionary<Date, DailyData>.Element]?
    @IBOutlet weak var lineGraphView: ScoreLineGraphView!
	@IBOutlet weak var averageScoreLabel: UILabel!
	@IBOutlet weak var cardView: CardView!

    override func viewDidLoad() {
        super.viewDidLoad()
		averageScoreLabel.text = "0"
    }

    func lineChartUpdate () {
        guard let fitnessData = data, fitnessData.count > 1 else { return }

        var entries: [ChartDataEntry] = []
        var xValue = 0.0
		var totalScore = 0
		var xLabels: [String] = []
		let df = DateFormatter()
		df.dateFormat = "d/M"
        for element in fitnessData {
            xValue += 1
            let yValue = element.value.score
			let now = df.string(from: element.key)
			xLabels.append(now)
			let entrie = ChartDataEntry(x: xValue, y: Double(yValue))
            entries.append(entrie)
			totalScore += yValue
        }

		let avg: Double = Double(totalScore) / Double(fitnessData.count)
		averageScoreLabel.text = String(format: "%.1f", avg)

        let dataSet = ScoreLineGraphDataSetView(entries: entries, label: "Score")

		lineGraphView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xLabels)
		lineGraphView.xAxis.granularity = 1

		dataSet.fillFormatter = DefaultFillFormatter {_, _  -> CGFloat in
			return CGFloat(self.lineGraphView.leftAxis.axisMinimum)
		}
        let data = LineChartData(dataSets: [dataSet])
        data.setDrawValues(false)

		lineGraphView.animate(xAxisDuration: 0, yAxisDuration: 1.5, easingOption: .easeOutQuart)

        lineGraphView.data = data
        lineGraphView.notifyDataSetChanged()
    }

}
