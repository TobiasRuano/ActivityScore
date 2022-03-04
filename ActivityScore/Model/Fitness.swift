//
//  HealthData.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 20/02/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import Foundation

enum DailyDataType {
    case steps
    case distance
    case calories
    case exercise
}

struct DailyData {
    var score: Int
    var steps: Int
    var distance: Int
    var calories: Int
    var exercise: Int
}

class Fitness {
    
    private var dailyData: [Date: DailyData] = [:]
    private var userGoals: Objectives!
    
    func setItemInDailyData(amounts: [Date: Int], type: DailyDataType) {
        for element in amounts {
            let key = element.key
            if dailyData[key] != nil {
                switch type {
                case .steps:
                    dailyData[key]?.steps = element.value
                case .distance:
                    dailyData[key]?.distance = element.value
                case .calories:
                    dailyData[key]?.calories = element.value
                case .exercise:
                    dailyData[key]?.exercise = element.value
                }
            } else {
                var newDayData: DailyData
                switch type {
                case .steps:
                    newDayData = DailyData(score: 0, steps: element.value, distance: 0, calories: 0, exercise: 0)
                case .distance:
                    newDayData = DailyData(score: 0, steps: 0, distance: element.value, calories: 0, exercise: 0)
                case .calories:
                    newDayData = DailyData(score: 0, steps: 0, distance: 0, calories: element.value, exercise: 0)
                case .exercise:
                    newDayData = DailyData(score: 0, steps: 0, distance: 0, calories: 0, exercise: element.value)
                }
                dailyData[key] = newDayData
            }
        }
    }

    func getFitnessData() -> [Date: DailyData] {
        return dailyData
    }

    func obtainScoreNumber() {
        for element in dailyData {
            if element.value.calories == userGoals.calories {
                dailyData[element.key]?.score = 70
            } else if element.value.calories < userGoals.calories {
                let valueCopy: Double = Double(element.value.calories) / Double(userGoals.calories)
                dailyData[element.key]?.score = Int(valueCopy * 70)
            } else {
                let valueCopy = element.value.calories - userGoals.calories
                dailyData[element.key]?.score = (Int(70.0 + (0.10 * Double(valueCopy))))
                
            }
			
            if element.value.score > 100 {
                dailyData[element.key]?.score = 100
            }
        }
    }
    
    func getGoals() {
        if let data = UserDefaults.standard.data(forKey: "objectives") {
            let decoder = JSONDecoder()
            do {
                let object = try decoder.decode(Objectives.self, from: data)
                userGoals = object
            } catch {
                userGoals = Objectives()
            }
        } else {
            userGoals = Objectives()
        }
    }
}
