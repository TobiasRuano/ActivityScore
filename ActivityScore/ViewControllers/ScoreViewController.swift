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
    let healthManager = HealthKitManager.shared
    let hour = Calendar.current.component(.hour, from: Date())
    let weekDay = Calendar.current.component(.day, from: Date())
    var succesFlag = true
    var inAppPurchase = false
    var user = UserData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Your Daily Score"
        checkOnboardingStatus()
        authorizeHealthKit()
        styleChart()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        labelStyle()
        checkPurchaseStatus()
        checkObjectives()
        retrieveUserGoals()
        retrieveHealthData()
    }
    
    func retrieveUserGoals() {
        healthManager.getUserGoal { result in
            switch result {
            case .success(let goals):
                let exerciseGoal = goals.1
                let activityGoal = goals.0
                self.user.setUserGoals(activityGoal: activityGoal, exerciseGoal: exerciseGoal)
            case .failure(_):
                break
            }
        }
    }
    
    func retrieveHealthData() {
        healthManager.getData(type: .stepCount, unit: .count(), days: 7) { result in
            switch result {
            case .success(let steps):
                self.user.setItemInDailyData(amounts: steps, type: .steps)
                self.user.obtainScoreNumber()
            case .failure(_):
                break
            }
        }
        
        healthManager.getData(type: .activeEnergyBurned, unit: .kilocalorie(), days: 7) { result in
            switch result {
            case .success(let calories):
                self.user.setItemInDailyData(amounts: calories, type: .calories)
                self.user.obtainScoreNumber()
            case .failure(_):
                break
            }
        }
        
        healthManager.getData(type: .appleExerciseTime, unit: .minute(), days: 7) { result in
            switch result {
            case .success(let exercice):
                self.user.setItemInDailyData(amounts: exercice, type: .exercise)
                self.user.obtainScoreNumber()
            case .failure(_):
                break
            }
        }
        
        healthManager.getData(type: .distanceWalkingRunning, unit: .meter(), days: 7) { result in
            switch result {
            case .success(let distance):
                self.user.setItemInDailyData(amounts: distance, type: .distance)
                self.user.obtainScoreNumber()
            case .failure(_):
                break
            }
        }
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
    
    //MARK: - Check initial status
    func checkObjectives() {
        if let data = UserDefaults.standard.value(forKey: "objectives") as? Data {
            let copy = try? PropertyListDecoder().decode(Objectives.self, from: data)
            user.userData = copy!
        } else {
            user.userData.calories = 400
            user.userData.minutesEx = 30
        }
    }
    
    func checkPurchaseStatus() {
        if let inAppKeyValue = UserDefaults.standard.value(forKey: "purchase") as? Bool {
            inAppPurchase = inAppKeyValue
        }
        if inAppPurchase == false {
            addAd()
            adBanner.isHidden = false
        } else {
            adBanner.rootViewController = nil
            adBanner.isHidden = true
        }
    }
    
    //MARK: - Authorize healthKit
    private func authorizeHealthKit() {
        healthManager.authorizeHealthKit { (authorized, error) in
            guard authorized else {
                let baseMessage = "HealthKit Authorization Failed"
                self.succesFlag = false
                UserDefaults.standard.set(self.succesFlag, forKey: "Flag")
                if let error = error {
                    print("\(baseMessage). Reason: \(error.localizedDescription)")
                } else {
                    print(baseMessage)
                }
                return
            }
            print("HealthKit Successfully Authorized.")
            self.succesFlag = true
            UserDefaults.standard.set(self.succesFlag, forKey: "Flag")
            self.retrieveHealthData()
        }
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
        let entry1 = ChartDataEntry(x: 1.0, y: Double(user.weekData.score?[0] ?? 0))
        let entry2 = ChartDataEntry(x: 2.0, y: Double(user.weekData.score?[1] ?? 0))
        let entry3 = ChartDataEntry(x: 3.0, y: Double(user.weekData.score?[2] ?? 0))
        let entry4 = ChartDataEntry(x: 4.0, y: Double(user.weekData.score?[3] ?? 0))
        let entry5 = ChartDataEntry(x: 5.0, y: Double(user.weekData.score?[4] ?? 0))
        let entry6 = ChartDataEntry(x: 6.0, y: Double(user.weekData.score?[5] ?? 0))
        let entry7 = ChartDataEntry(x: 7.0, y: Double(user.weekData.score?[6] ?? 0))
        let dataSet = LineChartDataSet(entries: [entry1, entry2, entry3, entry4, entry5, entry6, entry7], label: "Widgets Type")
        
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
    
//    func obtainScoreNumber() {
//        user.obtainScoreNumber()
//        DispatchQueue.main.async {
//            self.scoreLabel.text = String(Int(self.user.arrayScore[6]))
//            self.lineChartUpdate()
//
//            if self.user.arrayScore[6] < 20 {
//                if self.hour < 10 {
//                    self.CheeringLable.text = "Let's own the day! 💪"
//                }else if self.hour < 17 {
//                    self.CheeringLable.text = "Let's go for a walk! 🚶‍♂️"
//                }else {
//                    self.CheeringLable.text = "SO LAZY! 😡"
//                }
//            }else if self.user.arrayScore[6] > 19 && self.user.arrayScore[6] < 40 {
//                if self.hour < 10 {
//                    self.CheeringLable.text = "Let's own the day! 💪"
//                }else if self.hour < 17 {
//                    self.CheeringLable.text = "Not bad, but you could do better. 🤷‍♂️"
//                }else if self.hour < 19 {
//                    self.CheeringLable.text = "Let's get out there and work out! 😃"
//                }else {
//                    self.CheeringLable.text = "You'll do better tomorrow! 😔"
//                }
//            }else if self.user.arrayScore[6] > 39 && self.user.arrayScore[6] < 70 {
//                if self.hour < 10 {
//                    self.CheeringLable.text = "What a way to start the day. 👏"
//                }else if self.hour < 17 {
//                    self.CheeringLable.text = "Great Job! 💪"
//                }else {
//                    self.CheeringLable.text = "Great Job! 💪"
//                }
//            }else if self.user.arrayScore[6] > 69 {
//                if self.hour < 10 {
//                    self.CheeringLable.text = "Excelent way to start the Day! 👍"
//                }else if self.hour < 17 {
//                    self.CheeringLable.text = "KEEP IT UP! 🏆"
//                }else {
//                    self.CheeringLable.text = "WOW, WHAT A DAY!! 👏"
//                }
//            }
//
//            //Display CardView Data
//            self.cardViewStepsLabel.text = "\(self.user.cardSteps) Steps"
//            self.cardViewCaloriesLabel.text = "\(self.user.cardCal) Calories"
//            self.cardViewExerciseLabel.text = "\(self.user.cardExe) Minutes of Exercise"
//            self.cardViewWalkrunLabel.text = "\(String(format:"%.01f", self.user.cardKm / 1000)) Km Walk/Run"
//            //Check if theres data. If there is, health label should be ENABLED
//            if self.user.cardCal != 0 {
//                UserDefaults.standard.set(true, forKey: "Flag")
//            }
//        }
//    }
    
    func setCardView() {
        cardViewController = CardViewDataCollectionViewController(nibName: nil, bundle: .main)
        cardViewController.weekData = user.weekData
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

