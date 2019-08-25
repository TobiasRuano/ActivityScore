//
//  Score.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 28/07/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import Foundation

public class Score {
    var arrayCal: [Double]
    var arraySteps: [Double]
    var arrayExe: [Double]
    var arrayDis: [Double]
    var userData: Objectives
    var arrayData: [HealthDataModel]
    var hKManager: HealthKitManager
    var succesFlag: Bool
    var inAppPurchase: Bool //TODO: change to false
    public static let shared = Score()
    
    init() {
        succesFlag = true
        inAppPurchase = false
        hKManager = HealthKitManager.shared
        arrayCal = [Double]()
        arraySteps = [Double]()
        arrayExe = [Double]()
        arrayDis = [Double]()
        userData = Objectives()
        arrayData = [HealthDataModel]()
    }
    
    //MARK: - Check initial status
    func checkObjectives() {
        if let data = UserDefaults.standard.value(forKey: "objectives") as? Data {
            let copy = try? PropertyListDecoder().decode(Objectives.self, from: data)
            userData = copy!
        } else {
            userData.calories = 400
        }
    }
    
    func checkPurchaseStatus() -> Bool {
        if let inAppKeyValue = UserDefaults.standard.value(forKey: "purchase") as? Bool {
            inAppPurchase = inAppKeyValue
        }
        if inAppPurchase == false {
            return true
        } else {
            return false
        }
        //adBanner.isHidden = true
    }
    //MARK: - Authorize healthKit
    func authorizeHealthKit() {
        hKManager.authorizeHealthKit { (authorized, error) in
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
            self.obtainScoreNumber()
            //            if let data = self.HKManager.arrayData {
            //                self.arrayData = data
            //            }
        }
    }
    
    func getData(completion: (Bool) -> ()) {
        self.arraySteps = self.hKManager.getLast7daysSteps()
        self.arrayCal = self.hKManager.getLast7daysCalories()
        self.arrayExe = self.hKManager.getLast7daysExercise()
        self.arrayDis = self.hKManager.getLast7daysDistance()
        var flag = false
        for element in 0..<self.arrayCal.count {
            let steps = Int(self.arraySteps[element])
            let cal = Int(self.arrayCal[element])
            let exe = Int(self.arrayExe[element])
            let dis = self.arrayDis[element]
            let data = HealthDataModel(cardSteps: steps, cardCal: cal, cardExe: exe, cardKm: dis, points: 0, motivationText: "", objective: self.userData)
            self.arrayData.append(data)
        }
        print("La array tiene : \(self.arrayData.count) elementos")
        flag = true
        completion(flag)
    }
    
    //MARK: - Score algorithm
    func obtainScoreNumber() {
        print(arrayData)
        for index in (0..<arrayData.count) {
            print(arrayData[index].getCalories())
            if arrayData[index].getCalories() == userData.calories {
                arrayData[index].setScore(points: 70)
            } else if arrayData[index].getCalories() < userData.calories {
                let valueCopy: Double = Double(arrayData[index].getCalories()) / Double(userData.calories)
                let copy = Int(valueCopy * 70.0)
                arrayData[index].setScore(points: copy)
            } else {
                let valueCopy = Double(arrayData[index].getCalories() - userData.calories)
                let copy = Int(70.0 + (0.10 * valueCopy))
                arrayData[index].setScore(points: copy)
            }
            if arrayData[index].getScore() > 100 {
                arrayData[index].setScore(points: 100)
            }
        }
        if arrayData.count == 7 {
            DispatchQueue.main.async {
//                self.lineChartUpdate()
//                self.updateLabels()
            }
        }
    }
    
    func getArrayData() -> [HealthDataModel] {
        return arrayData
    }
    
    func getArrayDataAtIndex(index: Int) -> HealthDataModel {
        return arrayData[index]
    }
}
