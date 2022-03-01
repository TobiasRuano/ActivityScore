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
    @IBOutlet weak var LineGraphView: LineChartView!

    override func viewDidLoad() {
        super.viewDidLoad()
        styleChart()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lineChartUpdate()
    }
    
    func styleChart() {
        LineGraphView.backgroundColor = .systemBackground
        LineGraphView.dragEnabled = true
        LineGraphView.setScaleEnabled(false)
        LineGraphView.pinchZoomEnabled = false
        LineGraphView.setViewPortOffsets(left: 0, top: 0, right: 0, bottom: 0)
        LineGraphView.isUserInteractionEnabled = false
        LineGraphView.drawBordersEnabled = false
        LineGraphView.chartDescription?.enabled = false
        LineGraphView.legend.enabled = false
        LineGraphView.xAxis.enabled = false
        LineGraphView.leftAxis.enabled = false
        LineGraphView.rightAxis.enabled = false
        LineGraphView.leftAxis.axisMaximum = 110
        LineGraphView.leftAxis.axisMinimum = -10
        LineGraphView.drawGridBackgroundEnabled = false
        LineGraphView.layer.cornerRadius = 15
        LineGraphView.clipsToBounds = false
    }
    
    func lineChartUpdate () {
        guard let fitnessData = data, fitnessData.count > 1 else { return }
        
        var entries: [ChartDataEntry] = []
        var xValue = 0.0
        for element in fitnessData {
            xValue += 1
            let yValue = element.value.score
            let entrie = ChartDataEntry(x: xValue, y: Double(yValue))
            entries.append(entrie)
        }
        
        let dataSet = LineChartDataSet(entries: entries, label: "Widgets Type")
        dataSet.valueTextColor = .clear
        dataSet.mode = .cubicBezier
        dataSet.drawCirclesEnabled = false
        dataSet.lineWidth = 4
        dataSet.circleRadius = 3
        dataSet.drawFilledEnabled = true
        dataSet.highlightColor = UIColor(named: "pink")!
        dataSet.drawCircleHoleEnabled = false
        dataSet.drawHorizontalHighlightIndicatorEnabled = false
        
        let firstPink = UIColor(red: 247/255, green: 191/255, blue: 190/255, alpha: 0)
        dataSet.colors = [UIColor(named: "pink")!]
        let gradientColors = [firstPink.cgColor,
                              UIColor.systemPink.cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        dataSet.fillAlpha = 1
        dataSet.fill = Fill(linearGradient: gradient, angle: 90)
        dataSet.fillFormatter = DefaultFillFormatter { _,_  -> CGFloat in
            return CGFloat(self.LineGraphView.leftAxis.axisMinimum)
        }
        
        let data = LineChartData(dataSets: [dataSet])
        data.setDrawValues(false)
        LineGraphView.data = data
        LineGraphView.notifyDataSetChanged()
    }

}
