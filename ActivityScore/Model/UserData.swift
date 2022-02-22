//
//  HealthData.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 20/02/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import Foundation

struct Objectives: Codable {
    var calories    = Int()
    //var minutesEx   = Int()
}

class UserData {
    let healthManager = HealthKitManager.shared
    var userData = Objectives()
    var cardSteps = 0
    var cardCal = 0
    var cardExe = 0
    var cardKm = 0.0
    var weeklyScore = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    var arrayScore = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    var arraySteps = [0, 0, 0, 0, 0, 0, 0] {
        didSet {
            self.obtainScoreNumber()
        }
    }
    var arrayDistance = [0, 0, 0, 0, 0, 0, 0] {
        didSet{
            self.obtainScoreNumber()
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
    
    func obtainScoreNumber() {
        for index in (0..<arrayCalories.count) {
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
    }
}
