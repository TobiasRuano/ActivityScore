//
//  Objectives.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 26/02/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import Foundation

class Objectives: Codable {
    
    private var calories = 0
    private var minutesEx = 0
    var usesCustomObjectives: Bool? = false
    
    func getCalories() -> Int {
        return calories
    }
    
    func getMinutesExe() -> Int {
        return minutesEx
    }
    
    func changeUsesCustomObjectives(value: Bool) {
        usesCustomObjectives = value
        UserDefaults.standard.set(try? PropertyListEncoder().encode(self), forKey: "objectives")
    }
    
    func setCustomObjectives(newCalories: Int, newMinutesExe: Int) {
        getUserDefaultsFlag()
        if let usesCustomObjectives = self.usesCustomObjectives, usesCustomObjectives {
            self.calories = newCalories
            self.minutesEx = newMinutesExe
            UserDefaults.standard.set(try? PropertyListEncoder().encode(self), forKey: "objectives")
        }
    }
    
    func setObjectivesFromHealth(newCalories: Int, newMinutesExe: Int) {
        getUserDefaultsFlag()
        if let usesCustomObjectives = self.usesCustomObjectives, !usesCustomObjectives {
            self.calories = newCalories
            self.minutesEx = newMinutesExe
            UserDefaults.standard.set(try? PropertyListEncoder().encode(self), forKey: "objectives")
        }
    }
    
    func getUserDefaultsFlag() {
        if let value = UserDefaults.standard.value(forKey: "customObjectives") {
            if let booleanValue = value as? Bool {
                usesCustomObjectives = booleanValue
            } else {
                usesCustomObjectives = false
            }
        } else {
            usesCustomObjectives = false
        }
    }
    
    func setUserDefaultsFlag(flag: Bool) {
        usesCustomObjectives = flag
        UserDefaults.standard.set(flag, forKey: "customObjectives")
    }
    
}
