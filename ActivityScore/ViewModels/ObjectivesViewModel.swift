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
    let healthManager = HealthKitManager.shared

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
    
    func setDefaultFitnessGoals() {
        getUserObjectivesFromFitnessApp()
    }
    
    private func getUserObjectivesFromFitnessApp() {
        healthManager.getUserGoal { result in
            switch result {
            case .success(let fitnessObjectives):
                self.setObjectives(newCalories: fitnessObjectives.0, newMinutesExe: fitnessObjectives.1)
            case .failure(let error):
                print(error)
                self.setObjectives(newCalories: 0, newMinutesExe: 0)
            }
        }
    }
	
    func getUserObjectivesFromFitnessApp(completed: @escaping (Result<(Int, Int), Error>) -> Void) {
        healthManager.getUserGoal { result in
            switch result {
            case .success(let fitnessObjectives):
                self.setObjectives(newCalories: fitnessObjectives.0, newMinutesExe: fitnessObjectives.1)
                DispatchQueue.main.async {
                    completed(.success((fitnessObjectives.0, fitnessObjectives.1)))
                }
            case .failure(let error):
                self.setObjectives(newCalories: 0, newMinutesExe: 0)
                DispatchQueue.main.async {
                    completed(.failure(error))
                }
            }
        }
    }
    
    func changeUsesCustomObjectives(value: Bool) {
        userObjectives.usesCustomObjectives = value
        if !value {
            getUserObjectivesFromFitnessApp()
        }
    }
    
    func setObjectives(newCalories: Int, newMinutesExe: Int) {
        userObjectives.calories = newCalories
        userObjectives.minutesEx = newMinutesExe
        saveObjectives()
    }
    
    func setCustomObjectives(newCalories: Int, newMinutesExe: Int) {
        if let usesCustomObjectives = userObjectives.usesCustomObjectives, usesCustomObjectives {
            setObjectives(newCalories: newCalories, newMinutesExe: newMinutesExe)
        } else {
            getUserObjectivesFromFitnessApp()
        }
    }
    
}
