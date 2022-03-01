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

class ScoreViewController: UIViewController, GADBannerViewDelegate {
    
    @IBOutlet weak var LineGraphView: LineChartView!
    @IBOutlet weak var adBanner: GADBannerView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var CheeringLable: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    var cardViewController: CardViewDataCollectionViewController!
    
    let scoreViewModel = ScoreViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        scoreViewModel.delegate = self
        self.navigationItem.title = "Your Daily Score"
        styleChart()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        labelStyle()
        configureAdBanner()
//        checkObjectives()
        healthData()
        lineChartUpdate()
    }
    
    func healthData() {
        scoreViewModel.authorizeHealthKit { status in
            if status {
                self.retrieveData()
            } else {
                // presentar error de autorizacion
            }
        }
    }
    
    func retrieveData() {
        scoreViewModel.retrieveHealthData()
//        scoreViewModel.obtainScoreNumber { textValues in
//            self.CheeringLable.text = textValues.0
//            self.scoreLabel.text = textValues.1
//        }
    }
    
    func checkOnboardingStatus() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        var vc: UIViewController
        if (UserDefaults.standard.value(forKey: "OnboardingScreen") as? Bool) == nil  {
            vc = storyBoard.instantiateViewController(withIdentifier: "OnboardingRoot")
            present(vc, animated: true, completion: nil)
        }
    }
    
    func labelStyle() {
        let shadowColor = UIColor.white
        scoreLabel.layer.shadowColor = shadowColor.cgColor
        scoreLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        scoreLabel.layer.shadowOpacity = 1
        scoreLabel.layer.shadowRadius = 2
    }
    
    func setScoreText(score: String, description: String) {
        self.scoreLabel.text = score
        self.CheeringLable.text = description
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
        let fitnessData = scoreViewModel.user.getFitnessData()
        guard fitnessData.count > 1 else { return }
        
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
        
//        dataSet.fillFormatter = CubicLineSampleFillFormatter() as! FillFormatter
        
        dataSet.fillFormatter = DefaultFillFormatter { _,_  -> CGFloat in
            return CGFloat(self.LineGraphView.leftAxis.axisMinimum)
        }
        
        let data = LineChartData(dataSets: [dataSet])
        data.setDrawValues(false)
        LineGraphView.data = data
        
        //This must stay at end of function
        LineGraphView.notifyDataSetChanged()
    }
    
    func setCardView() {
//        let storyboard = UIStoryboard(name: "Main", bundle: .main)
//        cardViewController = storyboard.instantiateViewController(withIdentifier: "CardViewDataCollectionViewController") as? CardViewDataCollectionViewController
//        cardViewController.weekData = scoreViewModel.user.getFitnessData()
//        cardViewController.collectionView.reloadData()
//        self.addChild(cardViewController)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cardViewSegue" {
            let vc = segue.destination as! CardViewDataCollectionViewController
            vc.weekData = scoreViewModel.user.getFitnessData()
            vc.collectionView.reloadData()
        }
    }
    
    func configureAdBanner() {
        scoreViewModel.checkPurchaseStatus { status in
            switch status {
            case true:
                self.addAd()
                self.adBanner.isHidden = false
            case false:
                self.adBanner.rootViewController = nil
                self.adBanner.isHidden = true
            }
        }
    }
    
    func addAd() {
        //Request
        let request = GADRequest()
        request.testDevices = [(kGADSimulatorID as! String)]
        request.testDevices = [ "21df7f3d09709224a09480ff10d324aa" ]
        
        //Set up ad
        adBanner.adUnitID = "ca-app-pub-6561467960639972/8227758207"
        
        adBanner.rootViewController = self
        adBanner.delegate = self
        
        adBanner.load(request)
    }
    
}

extension ScoreViewController: ScoreViewModelProtocol {
    func setView(scoreText: String, descriptionText: String) {
        lineChartUpdate()
        setScoreText(score: scoreText, description: descriptionText)
        setCardView()
    }
}

