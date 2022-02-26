//
//  HealthData.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 20/02/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import Foundation

struct Objectives: Codable {
    var calories = 0
    var minutesEx = 0
}

enum DailyDataType {
    case steps
    case distance
    case calories
    case exercise
}

struct WeekData {
    var score: [Int]?
    var steps: [Int]?
    var distance: [Int]?
    var calories: [Int]?
    var exercise: [Int]?
}

class UserData {
    let healthManager = HealthKitManager.shared
    var userData = Objectives()
    var weekData = WeekData()
    
    func setUserGoals(activityGoal: Int, exerciseGoal: Int) {
        if activityGoal != userData.calories {
            userData.calories = activityGoal
        }
        if exerciseGoal != userData.minutesEx {
            userData.minutesEx = exerciseGoal
        }
        UserDefaults.standard.set(try? PropertyListEncoder().encode(userData.self), forKey: "objectives")
    }
    
    func setItemInDailyData(amounts: [Int], type: DailyDataType) {
        switch type {
        case .steps:
            weekData.steps?.removeAll()
            weekData.steps = amounts
        case .distance:
            weekData.distance?.removeAll()
            weekData.distance = amounts
        case .calories:
            weekData.calories?.removeAll()
            weekData.calories = amounts
        case .exercise:
            weekData.exercise?.removeAll()
            weekData.exercise = amounts
        }
    }
    
    func obtainScoreNumber() {
        guard let weeklyCalories = weekData.calories else { return }
        
        weekData.score?.removeAll()
        var scoreArray = [Int]()
        for index in (0..<weeklyCalories.count) {
            if weeklyCalories[index] == userData.calories {
                scoreArray.append(70)
            } else if weeklyCalories[index] < userData.calories {
                let valueCopy: Int = weeklyCalories[index] / userData.calories
                scoreArray.append(valueCopy * 70)
            } else {
                let valueCopy = weeklyCalories[index] - userData.calories
                scoreArray.append(Int(70.0 + (0.10 * Double(valueCopy))))
            }
            
            if scoreArray[index] > 100 {
                scoreArray.append(100)
            }
        }
        
        weekData.score = scoreArray
    }
}
