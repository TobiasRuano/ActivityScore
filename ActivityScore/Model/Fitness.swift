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

    var dailyData: [Date: DailyData] = [:]
    private var userGoals: Goals!

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

			if dailyData[element.key]!.score > 100 {
                dailyData[element.key]?.score = 100
            }
        }
    }

    func getGoals() {
        if let data = UserDefaults.standard.data(forKey: "objectives") {
            let decoder = JSONDecoder()
            do {
                let object = try decoder.decode(Goals.self, from: data)
                userGoals = object
            } catch {
                userGoals = Goals()
            }
        } else {
            userGoals = Goals()
        }
    }
}
