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

let healthKitStore: HKHealthStore = HKHealthStore()

class ScoreViewController: UIViewController, GADBannerViewDelegate {
    
    let hour = Calendar.current.component(.hour, from: Date())
    let weekDay = Calendar.current.component(.day, from: Date())

    var succesFlag = true
    
    @IBOutlet weak var LineGraphView: LineView!
    
    //Card View Items
    @IBOutlet weak var cardViewStepsLabel: UILabel!
    @IBOutlet weak var cardViewCaloriesLabel: UILabel!
    @IBOutlet weak var cardViewExerciseLabel: UILabel!
    @IBOutlet weak var cardViewWalkrunLabel: UILabel!
    
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
                self.LineGraphView.setNeedsDisplay()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationItem.title = "Your Daily Score"
        self.tabBarItem.title = "Score"
        
        //TODO: borrar
        print("Hoy es el dia: \(weekDay)")
        
        //TODO: put it in the onboarding screen
        authorizeHealthKit()

        
        if inAppPurchase == false {
            addAd()
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
        
        /*
        getLast7daysExercise()
        getLast7daysDistance()
        getLast7daysCalories()
        getLast7daysSteps()*/
    }
    
    
    
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
                        
                        //NOTE: If you are going to update the UI do it in the main thread
                        DispatchQueue.main.async {
                            //update UI components
                        }
                        
                    }
                } //end block
            } //end if let
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
                        
                        //NOTE: If you are going to update the UI do it in the main thread
                        DispatchQueue.main.async {
                            //update UI components
                        }
                        
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
                        
                        //NOTE: If you are going to update the UI do it in the main thread
                        DispatchQueue.main.async {
                            //update UI components
                        }
                        
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
                        
                        //NOTE: If you are going to update the UI do it in the main thread
                        DispatchQueue.main.async {
                            //update UI components
                        }
                        
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
        
        //TODO: crear una variable para guardar y operar en vez de la propia array
        for index in (0..<arraySteps.count) {
            while arraySteps[index] > 100 {
                arraySteps[index] = arraySteps[index] - 100
                arrayScore[index] += 0.5
            }
        }
        
        for index in (0..<arrayCalories.count) {
            while arrayCalories[index] > 10 {
                arrayCalories[index] = arrayCalories[index] - 10
                arrayScore[index] += 1
            }
        }
        
        for index in (0..<arrayDistance.count) {
            while arrayDistance[index] > 200 {
                arrayDistance[index] = arrayDistance[index] - 200
                arrayScore[index] += 1
            }
        }
        
        for index in (0..<arrayExercise.count) {
            while arrayExercise[index] > 10 {
                arrayExercise[index] = arrayExercise[index] - 10
                arrayScore[index] += 10
            }
        }
        
        
        DispatchQueue.main.async {
            self.scoreLabel.text = String(Int(self.arrayScore[6]))
            self.LineGraphView.setNeedsDisplay()
            
            
            if self.arrayScore[6] < 40 {
                if self.hour < 10 {
                    self.CheeringLable.text = "Let's own the day! 💪"
                }else if self.hour < 17 {
                    self.CheeringLable.text = "Let's go for a walk! 🚶‍♂️"
                }else {
                    self.CheeringLable.text = "SO LAZY! 😡"
                }
            }else if self.arrayScore[6] > 39 && self.arrayScore[6] < 90 {
                if self.hour < 10 {
                    self.CheeringLable.text = "Let's own the day! 💪"
                }else if self.hour < 17 {
                    self.CheeringLable.text = "Not bad, but you could do better. 🤷‍♂️"
                }else if self.hour < 19 {
                    self.CheeringLable.text = "Let's get out there and work out! 😃"
                }else {
                    self.CheeringLable.text = "You'll do better tomorrow! 😔"
                }
            }else if self.arrayScore[6] > 89 && self.arrayScore[6] < 150 {
                if self.hour < 10 {
                    self.CheeringLable.text = "What a way to start the day. 👏"
                }else if self.hour < 17 {
                    self.CheeringLable.text = "Great Job! 💪"
                }else {
                    self.CheeringLable.text = "Great Job! 💪"
                }
            }else if self.arrayScore[6] > 149{
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

