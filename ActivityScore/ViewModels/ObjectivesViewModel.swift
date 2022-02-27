//
//  ObjectivesViewModel.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 27/02/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import Foundation

class ObjectivesViewModel {
    
    var userObjectives: Objectives!
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "objectives") {
            let decoder = JSONDecoder()
            do {
                let object = try decoder.decode(Objectives.self, from: data)
                userObjectives = object
            } catch {
                userObjectives = Objectives()
            }
        } else {
            userObjectives = Objectives()
        }
    }
    
    private func saveObjectives() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(userObjectives)
            UserDefaults.standard.set(data, forKey: "objectives")
        } catch {
            print("No se guardo nada!")
        }
    }
    
    func changeUsesCustomObjectives(value: Bool) {
        userObjectives.usesCustomObjectives = value
        saveObjectives()
    }
    
    func setCustomObjectives(newCalories: Int, newMinutesExe: Int) {
        if let usesCustomObjectives = userObjectives.usesCustomObjectives, usesCustomObjectives {
            userObjectives.calories = newCalories
            userObjectives.minutesEx = newMinutesExe
            saveObjectives()
        }
    }
    
    func setObjectivesFromHealth(newCalories: Int, newMinutesExe: Int) {
        if let usesCustomObjectives = userObjectives.usesCustomObjectives, !usesCustomObjectives {
            userObjectives.calories = newCalories
            userObjectives.minutesEx = newMinutesExe
            saveObjectives()
        }
    }
    
}
