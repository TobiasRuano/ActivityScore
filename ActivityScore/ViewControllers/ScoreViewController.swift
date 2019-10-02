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

struct Objectives: Codable {
    var calories    = Int()
    //var minutesEx   = Int()
}

let healthKitStore: HKHealthStore = HKHealthStore()

class ScoreViewController: UIViewController, GADBannerViewDelegate {
    
    let hour = Calendar.current.component(.hour, from: Date())
    let weekDay = Calendar.current.component(.day, from: Date())

    var succesFlag = true
    
    @IBOutlet weak var LineGraphView: LineChartView!
    
    //Card View Items
    @IBOutlet weak var cardViewStepsLabel: UILabel!
    @IBOutlet weak var cardViewCaloriesLabel: UILabel!
    @IBOutlet weak var cardViewExerciseLabel: UILabel!
    @IBOutlet weak var cardViewWalkrunLabel: UILabel!
    
    //User objetives variable
    var userData = Objectives()
    
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
    
    var weeklyScore = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    var arrayScore = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0] {
        didSet {
            for i in 0..<arrayScore.count {
                UserDefaults.standard.set(Int(arrayScore[i]), forKey: "arrayScore\(i)")
            }
            DispatchQueue.main.async {
                self.lineChartUpdate()
            }
        }
    }
    var arraySteps = [0, 0, 0, 0, 0, 0, 0] {
        didSet {
            DispatchQueue.main.async {
                self.obtainScoreNumber()
            }
        }
    }
    var arrayDistance = [0, 0, 0, 0, 0, 0, 0] {
        didSet{
            DispatchQueue.main.async {
                self.obtainScoreNumber()
            }
        }
    }
    var arrayCalories = [0, 0, 0, 0, 0, 0, 0] {
        didSet{
            self.obtainScoreNumber()
        }
    }
    var arrayExercise = [0, 0, 0, 0, 0, 0, 0] {
        didSet{
            self.obtainScoreNumber()
        }
    }
    
    //TODO: change to false
    var inAppPurchase = false
    
    @IBOutlet weak var adBanner: GADBannerView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var CheeringLable: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationItem.title = "Your Daily Score"
        //self.tabBarItem.title = "Score"
        
        checkOnboardingStatus()
        
        //TODO: borrar
        print("Hoy es el dia: \(weekDay)")
        
        //authorizeHealthKit()
        self.getLast7daysSteps()
        self.getLast7daysCalories()
        self.getLast7daysExercise()
        self.getLast7daysDistance()
        styleChart()
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
    
    override func viewWillAppear(_ animated: Bool) {
        labelStyle()
        colorStyle()
        
        /*
        getLast7daysExercise()
        getLast7daysDistance()
        getLast7daysCalories()
        getLast7daysSteps()*/
        
        checkPurchaseStatus()
        checkObjectives()
        obtainScoreNumber()
    }
    
    func colorStyle() {
        view.backgroundColor = UIColor(named: "BackgroundGeneral")
        self.navigationController?.navigationBar.backgroundColor = UIColor(named: "BackgroundGeneral")
        cardView.backgroundColor = UIColor(named: "BackgroundGeneral")
        scrollView.backgroundColor = UIColor(named: "BackgroundGeneral")
        contentView.backgroundColor = UIColor(named: "BackgroundGeneral")
    }
    
    //MARK: - Check initial status
    func checkObjectives() {
        if let data = UserDefaults.standard.value(forKey: "objectives") as? Data {
            let copy = try? PropertyListDecoder().decode(Objectives.self, from: data)
            userData = copy!
        } else {
            //Default numbers
            userData.calories = 400
            //userData.minutesEx = 30
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
        
        HealthKitSetupAssistant.authorizeHealthKit { (authorized, error) in
            
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
            self.getLast7daysSteps()
            self.getLast7daysCalories()
            self.getLast7daysExercise()
            self.getLast7daysDistance()
        }
    }
    
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
        LineGraphView.leftAxis.axisMinimum = -10
        
        LineGraphView.backgroundColor = .white
        //LineGraphView.gridBackgroundColor = .white
        LineGraphView.drawGridBackgroundEnabled = false
        
        LineGraphView.layer.cornerRadius = 15
        LineGraphView.clipsToBounds = false
        
    }
    
    func lineChartUpdate () {
        let entry1 = ChartDataEntry(x: 1.0, y: Double(arrayScore[0]))
        let entry2 = ChartDataEntry(x: 2.0, y: Double(arrayScore[1]))
        let entry3 = ChartDataEntry(x: 3.0, y: Double(arrayScore[2]))
        let entry4 = ChartDataEntry(x: 4.0, y: Double(arrayScore[3]))
        let entry5 = ChartDataEntry(x: 5.0, y: Double(arrayScore[4]))
        let entry6 = ChartDataEntry(x: 6.0, y: Double(arrayScore[5]))
        let entry7 = ChartDataEntry(x: 7.0, y: Double(arrayScore[6]))
        print(arrayScore[6])
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
        dataSet.drawHorizontalHighlightIndicatorEnabled = true // cahnge to false
        
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
        
        //This must stay at end of function
        LineGraphView.notifyDataSetChanged()
    }
    
    // Gets last 7 days of steps
    func getLast7daysSteps() {
        let calendar = NSCalendar.current
        let interval = NSDateComponents()
        interval.day = 1
        let indicator = 0
        
        let stepsCount = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        var anchorComponents = calendar.dateComponents([.day, .month, .year], from: NSDate() as Date)
        anchorComponents.hour = 0
        let anchorDate = calendar.date(from: anchorComponents)
        
        // Define 1-day intervals starting from 0:00
        let stepsQuery = HKStatisticsCollectionQuery(quantityType: stepsCount, quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: anchorDate!, intervalComponents: interval as DateComponents)
        
        // Set the results handler
        stepsQuery.initialResultsHandler = {query, results, error in
            let endDate = NSDate()
            let startDate = calendar.date(byAdding: .day, value: -6, to: endDate as Date, wrappingComponents: false)
            if let myResults = results{
                myResults.enumerateStatistics(from: startDate!, to: endDate as Date) { statistics, stop in
                    if let quantity = statistics.sumQuantity(){
                        let date = statistics.startDate
                        let steps = quantity.doubleValue(for: HKUnit.count())
                        print("\(date): steps = \(steps)")
                        self.addToArray(item: steps, indicator: indicator)
                        
//                        //NOTE: If you are going to update the UI do it in the main thread
//                        DispatchQueue.main.async {
//                            //update UI components
//                        }
                        
                    }
                }
            }
        }
        healthKitStore.execute(stepsQuery)
    }
    
    // Gets last 7 days of Calories Burned
    func getLast7daysCalories() {
        let calendar = NSCalendar.current
        let interval = NSDateComponents()
        interval.day = 1
        let indicator = 1
        
        let caloriesCount = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        
        var anchorComponents = calendar.dateComponents([.day, .month, .year], from: NSDate() as Date)
        anchorComponents.hour = 0
        let anchorDate = calendar.date(from: anchorComponents)
        
        // Define 1-day intervals starting from 0:00
        let stepsQuery = HKStatisticsCollectionQuery(quantityType: caloriesCount, quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: anchorDate!, intervalComponents: interval as DateComponents)
        
        // Set the results handler
        stepsQuery.initialResultsHandler = {query, results, error in
            let endDate = NSDate()
            let startDate = calendar.date(byAdding: .day, value: -6, to: endDate as Date, wrappingComponents: false)
            if let myResults = results{
                myResults.enumerateStatistics(from: startDate!, to: endDate as Date) { statistics, stop in
                    if let quantity = statistics.sumQuantity(){
                        let date = statistics.startDate
                        let calories = quantity.doubleValue(for: HKUnit.kilocalorie())
                        print("\(date): Calories = \(calories)")
                        self.addToArray(item: calories, indicator: indicator)
                        
//                        //NOTE: If you are going to update the UI do it in the main thread
//                        DispatchQueue.main.async {
//                            //update UI components
//                        }
                        
                    }
                } //end block
            } //end if let
        }
        healthKitStore.execute(stepsQuery)
    }
    
    // Gets last 7 days of Exercise Time
    func getLast7daysExercise() {
        let calendar = NSCalendar.current
        let interval = NSDateComponents()
        interval.day = 1
        let indicator = 2
        
        let ExerciseCount = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime)!
        
        var anchorComponents = calendar.dateComponents([.day, .month, .year], from: NSDate() as Date)
        anchorComponents.hour = 0
        let anchorDate = calendar.date(from: anchorComponents)
        
        // Define 1-day intervals starting from 0:00
        let stepsQuery = HKStatisticsCollectionQuery(quantityType: ExerciseCount, quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: anchorDate!, intervalComponents: interval as DateComponents)
        
        // Set the results handler
        stepsQuery.initialResultsHandler = {query, results, error in
            let endDate = NSDate()
            let startDate = calendar.date(byAdding: .day, value: -6, to: endDate as Date, wrappingComponents: false)
            if let myResults = results{
                myResults.enumerateStatistics(from: startDate!, to: endDate as Date) { statistics, stop in
                    if let quantity = statistics.sumQuantity(){
                        let date = statistics.startDate
                        let exercise = quantity.doubleValue(for: HKUnit.minute())
                        print("\(date): Exercise = \(exercise)")
                        self.addToArray(item: exercise, indicator: indicator)
                        
//                        //NOTE: If you are going to update the UI do it in the main thread
//                        DispatchQueue.main.async {
//                            //update UI components
//                        }
                        
                    }
                } //end block
            } //end if let
        }
        healthKitStore.execute(stepsQuery)
    }
    
    // Gets last 7 days of Distance
    func getLast7daysDistance() {
        let calendar = NSCalendar.current
        let interval = NSDateComponents()
        interval.day = 1
        let indicator = 3
        
        let DistanceCount = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
        
        var anchorComponents = calendar.dateComponents([.day, .month, .year], from: NSDate() as Date)
        anchorComponents.hour = 0
        let anchorDate = calendar.date(from: anchorComponents)
        
        // Define 1-day intervals starting from 0:00
        let stepsQuery = HKStatisticsCollectionQuery(quantityType: DistanceCount, quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: anchorDate!, intervalComponents: interval as DateComponents)
        
        // Set the results handler
        stepsQuery.initialResultsHandler = {query, results, error in
            let endDate = NSDate()
            let startDate = calendar.date(byAdding: .day, value: -6, to: endDate as Date, wrappingComponents: false)
            if let myResults = results{
                myResults.enumerateStatistics(from: startDate!, to: endDate as Date) { statistics, stop in
                    if let quantity = statistics.sumQuantity(){
                        let date = statistics.startDate
                        let distance = quantity.doubleValue(for: HKUnit.meter())
                        print("\(date): Distance = \(distance)")
                        self.addToArray(item: distance, indicator: indicator)
                        
//                        //NOTE: If you are going to update the UI do it in the main thread
//                        DispatchQueue.main.async {
//                            //update UI components
//                        }
                        
                    }
                } //end block
            } //end if let
        }
        healthKitStore.execute(stepsQuery)
    }
    
    //TODO: index out of range
    func addToArray(item: Double, indicator: Int) {
        switch indicator {
        case 0:
            arraySteps[indiceSteps] = Int(item)
            if indiceSteps == 6 {
                cardSteps = Int(item)
            }
            indiceSteps += 1
            print("Added to the Step Array")
        case 1:
            arrayCalories[indiceCal] = Int(item)
            if indiceCal == 6 {
                cardCal = Int(item)
            }
            indiceCal += 1
            print("Added to the Calories Array")
        case 2:
            arrayExercise[indiceExe] = Int(item)
            if indiceExe == 6 {
                cardExe = Int(item)
            }
            indiceExe += 1
            print("Added to the Exercise Array")
        case 3:
            arrayDistance[indiceDis] = Int(item)
            if indiceDis == 6 {
                cardKm = item
            }
            indiceDis += 1
            print("Added to the Distance Array")
        default:
            break
        }
    }
    
    
    func obtainScoreNumber() {
//        for index in (0..<arraySteps.count) {
//            while arraySteps[index] > 300 {
//                arraySteps[index] = arraySteps[index] - 300
//                arrayScore[index] += 0.5
//            }
//        }
//
//        for index in (0..<arrayCalories.count) {
//            while arrayCalories[index] > 40 {
//                arrayCalories[index] = arrayCalories[index] - 40
//                arrayScore[index] += 1
//            }
//        }
//
//        for index in (0..<arrayDistance.count) {
//            while arrayDistance[index] > 400 {
//                arrayDistance[index] = arrayDistance[index] - 400
//                arrayScore[index] += 1
//            }
//        }
//
//        for index in (0..<arrayExercise.count) {
//            while arrayExercise[index] > 10 {
//                arrayExercise[index] = arrayExercise[index] - 10
//                arrayScore[index] += 5
//            }
//        }
        
        print(arrayCalories)
        
        for index in (0..<arrayCalories.count) {
            print(arrayCalories[index])
            if arrayCalories[index] == userData.calories {
                arrayScore[index] = 70
            } else if arrayCalories[index] < userData.calories {
                let valueCopy: Double = Double(arrayCalories[index]) / Double(userData.calories)
                arrayScore[index] = valueCopy * 70.0
            } else {
                let valueCopy = Double(arrayCalories[index] - userData.calories)
                arrayScore[index] = 70.0 + (0.10 * valueCopy)
            }
            
            if arrayScore[index] > 100 {
                arrayScore[index] = 100
            }
        }
        
        
        DispatchQueue.main.async {
            self.scoreLabel.text = String(Int(self.arrayScore[6]))
            self.lineChartUpdate()
            
            
            if self.arrayScore[6] < 20 {
                if self.hour < 10 {
                    self.CheeringLable.text = "Let's own the day! 💪"
                }else if self.hour < 17 {
                    self.CheeringLable.text = "Let's go for a walk! 🚶‍♂️"
                }else {
                    self.CheeringLable.text = "SO LAZY! 😡"
                }
            }else if self.arrayScore[6] > 19 && self.arrayScore[6] < 40 {
                if self.hour < 10 {
                    self.CheeringLable.text = "Let's own the day! 💪"
                }else if self.hour < 17 {
                    self.CheeringLable.text = "Not bad, but you could do better. 🤷‍♂️"
                }else if self.hour < 19 {
                    self.CheeringLable.text = "Let's get out there and work out! 😃"
                }else {
                    self.CheeringLable.text = "You'll do better tomorrow! 😔"
                }
            }else if self.arrayScore[6] > 39 && self.arrayScore[6] < 70 {
                if self.hour < 10 {
                    self.CheeringLable.text = "What a way to start the day. 👏"
                }else if self.hour < 17 {
                    self.CheeringLable.text = "Great Job! 💪"
                }else {
                    self.CheeringLable.text = "Great Job! 💪"
                }
            }else if self.arrayScore[6] > 69 {
                if self.hour < 10 {
                    self.CheeringLable.text = "Excelent way to start the Day! 👍"
                }else if self.hour < 17 {
                    self.CheeringLable.text = "KEEP IT UP! 🏆"
                }else {
                    self.CheeringLable.text = "WOW, WHAT A DAY!! 👏"
                }
            }
            
            //Display CardView Data
            self.cardViewStepsLabel.text = "\(self.cardSteps) Steps"
            self.cardViewCaloriesLabel.text = "\(self.cardCal) Calories"
            self.cardViewExerciseLabel.text = "\(self.cardExe) Minutes of Exercise"
            self.cardViewWalkrunLabel.text = "\(String(format:"%.01f", self.cardKm / 1000)) Km Walk/Run"
            //Check if theres data. If there is, health label should be ENABLED
            if self.cardCal != 0 {
                UserDefaults.standard.set(true, forKey: "Flag")
            }
        }
    }
    
    func addAd() {
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

