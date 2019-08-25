//
//  ScoreViewController.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 13/3/18.
//  Copyright © 2018 Tobias Ruano. All rights reserved.
//

import UIKit
import HealthKit
import GoogleMobileAds
import Charts

private class CubicLineSampleFillFormatter: IFillFormatter {
    func getFillLinePosition(dataSet: ILineChartDataSet, dataProvider: LineChartDataProvider) -> CGFloat {
        return -10
    }
}

class ScoreViewController: UIViewController, GADBannerViewDelegate {
    
    //    var arrayData = [HealthDataModel]()
    //
    //    var HKManager = HealthKitManager.shared
    //    var succesFlag = true
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var cardViewStepsLabel: UILabel!
    @IBOutlet weak var cardViewCaloriesLabel: UILabel!
    @IBOutlet weak var cardViewExerciseLabel: UILabel!
    @IBOutlet weak var cardViewWalkrunLabel: UILabel!
    
    @IBOutlet weak var adBanner: GADBannerView!
    @IBOutlet weak var cheeringLable: UILabel!
    @IBOutlet weak var LineGraphView: LineChartView!
    
    //User objetives variable
    //    var userData = Objectives()
    
    // Variables para obtener los datos de cardView
    var cardSteps = 0
    var cardCal = 0
    var cardExe = 0
    var cardKm = 0.0
    
    //Indexes for array access
    var indiceSteps = 0
    var indiceCal = 0
    var indiceExe = 0
    var indiceDis = 0
    let controlador = Score.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Your Daily Score"
        styleChart()
    }
    
    
    func labelStyle() {
        scoreLabel.layer.shadowColor = UIColor.white.cgColor
        scoreLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        scoreLabel.layer.shadowOpacity = 1
        scoreLabel.layer.shadowRadius = 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        labelStyle()
        //Se tiene que ejecutar cada vez que aparece la ventana
        controlador.authorizeHealthKit()
        let status = controlador.checkPurchaseStatus()
        if status {
            loadAd()
            adBanner.isHidden = false
        } else {
            adBanner.rootViewController = nil
            adBanner.isHidden = true
        }
        controlador.checkObjectives()
        //        obtainScoreNumber()
    }
    
    //    func getData(completion: (Bool) -> ()) {
    //        self.arraySteps = self.HKManager.getLast7daysSteps()
    //        self.arrayCal = self.HKManager.getLast7daysCalories()
    //        self.arrayExe = self.HKManager.getLast7daysExercise()
    //        self.arrayDis = self.HKManager.getLast7daysDistance()
    //        var flag = false
    //        for element in 0..<self.arrayCal.count {
    //            let steps = Int(self.arraySteps[element])
    //            let cal = Int(self.arrayCal[element])
    //            let exe = Int(self.arrayExe[element])
    //            let dis = self.arrayDis[element]
    //            let data = HealthDataModel(cardSteps: steps, cardCal: cal, cardExe: exe, cardKm: dis, points: 0, motivationText: "", objective: self.userData)
    //            self.arrayData.append(data)
    //        }
    //        print("La array tiene : \(self.arrayData.count) elementos")
    //        flag = true
    //        completion(flag)
    //    }
    
    //MARK: - Style LineChart
    func styleChart() {
        LineGraphView.setViewPortOffsets(left: 0, top: 0, right: 0, bottom: 0)
        LineGraphView.isUserInteractionEnabled = false
        LineGraphView.drawBordersEnabled = false
        LineGraphView.chartDescription?.enabled = false
        LineGraphView.legend.enabled = false
        LineGraphView.xAxis.enabled = false
        LineGraphView.leftAxis.enabled = false
        LineGraphView.rightAxis.enabled = false
        LineGraphView.leftAxis.axisMaximum = 110
        LineGraphView.leftAxis.axisMinimum = 0
        LineGraphView.backgroundColor = .white
        //LineGraphView.gridBackgroundColor = .white
        LineGraphView.drawGridBackgroundEnabled = false
        LineGraphView.layer.cornerRadius = 15
        LineGraphView.clipsToBounds = false
    }
    
    func lineChartUpdate () {
        let arrayData = controlador.getArrayData()
        let entry1 = ChartDataEntry(x: 1.0, y: Double(arrayData[0].getScore()))
        let entry2 = ChartDataEntry(x: 2.0, y: Double(arrayData[1].getScore()))
        let entry3 = ChartDataEntry(x: 3.0, y: Double(arrayData[2].getScore()))
        let entry4 = ChartDataEntry(x: 4.0, y: Double(arrayData[3].getScore()))
        let entry5 = ChartDataEntry(x: 5.0, y: Double(arrayData[4].getScore()))
        let entry6 = ChartDataEntry(x: 6.0, y: Double(arrayData[5].getScore()))
        let entry7 = ChartDataEntry(x: 7.0, y: Double(arrayData[6].getScore()))
        print(arrayData[6].getScore())
        let dataSet = LineChartDataSet(values: [entry1, entry2, entry3, entry4, entry5, entry6, entry7], label: "Widgets Type")
        dataSet.valueTextColor = .clear
        dataSet.mode = .cubicBezier
        dataSet.setColor(.clear)
        dataSet.drawCirclesEnabled = false
        dataSet.lineWidth = 2
        dataSet.circleRadius = 3
        dataSet.drawFilledEnabled = true
        dataSet.highlightColor = UIColor(named: "pink")!
        dataSet.drawCircleHoleEnabled = false
        dataSet.drawHorizontalHighlightIndicatorEnabled = true // change to false
        
        let gradientColors = [UIColor.white.cgColor,
                              UIColor(named: "pink")!.cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        dataSet.fillAlpha = 1
        dataSet.fill = Fill(linearGradient: gradient, angle: 90)
        dataSet.fillFormatter = CubicLineSampleFillFormatter()
        dataSet.fillFormatter = DefaultFillFormatter { _,_  -> CGFloat in
            return CGFloat(self.LineGraphView.leftAxis.axisMinimum)
        }
        
        let data = LineChartData(dataSets: [dataSet])
        data.setDrawValues(false)
        LineGraphView.data = data
        
        LineGraphView.notifyDataSetChanged()
    }
    
    func updateLabels() {
        let todayArray = controlador.getArrayDataAtIndex(index: 6)
        self.scoreLabel.text = String(Int(todayArray.getScore()))
        self.cardViewStepsLabel.text = "\(todayArray.getSteps()) Steps"
        self.cardViewCaloriesLabel.text = "\(todayArray.getCalories()) Calories"
        self.cardViewExerciseLabel.text = "\(todayArray.getExercise()) Minutes of Exercise"
        self.cardViewWalkrunLabel.text = "\(String(format:"%.01f", todayArray.getKm() / 1000)) Km Walk/Run"
        self.cheeringLable.text = todayArray.getMotivationText()
    }
    
    //MARK: - Ads
    func loadAd() {
        //Request
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        request.testDevices = [ "21df7f3d09709224a09480ff10d324aa" ]
        //Set up ad
        adBanner.adUnitID = "ca-app-pub-6561467960639972/8227758207"
        adBanner.rootViewController = self
        adBanner.delegate = self
        adBanner.load(request)
    }
}
