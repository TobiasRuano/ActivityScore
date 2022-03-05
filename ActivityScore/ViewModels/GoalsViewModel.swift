//
//  GoalsViewModel.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 27/02/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import Foundation

class GoalsViewModel {

    var userGoals: Goals!
    let healthManager = HealthKitManager.shared

    init() {
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

    private func saveGoals() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(userGoals)
            UserDefaults.standard.set(data, forKey: "objectives")
        } catch {
            print("No se guardo nada!")
        }
    }

    func setDefaultFitnessGoals() {
        getUserGoalsFromFitnessApp()
    }

    private func getUserGoalsFromFitnessApp() {
        healthManager.getUserGoal { result in
            switch result {
            case .success(let fitnessGoals):
                self.setGoals(newCalories: fitnessGoals.0, newMinutesExe: fitnessGoals.1)
            case .failure(let error):
                print(error)
                self.setGoals(newCalories: 0, newMinutesExe: 0)
            }
        }
    }

    func getUserGoalsFromFitnessApp(completed: @escaping (Result<(Int, Int), Error>) -> Void) {
        healthManager.getUserGoal { result in
            switch result {
            case .success(let fitnessGoals):
                self.setGoals(newCalories: fitnessGoals.0, newMinutesExe: fitnessGoals.1)
                DispatchQueue.main.async {
                    completed(.success((fitnessGoals.0, fitnessGoals.1)))
                }
            case .failure(let error):
                self.setGoals(newCalories: 0, newMinutesExe: 0)
                DispatchQueue.main.async {
                    completed(.failure(error))
                }
            }
        }
    }

    func changeUsesCustomGoals(value: Bool) {
        userGoals.usesCustomGoals = value
        if !value {
            getUserGoalsFromFitnessApp()
        }
    }

    func setGoals(newCalories: Int, newMinutesExe: Int) {
        userGoals.calories = newCalories
        userGoals.minutesEx = newMinutesExe
        saveGoals()
    }

    func setCustomGoals(newCalories: Int, newMinutesExe: Int) {
        if let usesCustomGoals = userGoals.usesCustomGoals, usesCustomGoals {
            setGoals(newCalories: newCalories, newMinutesExe: newMinutesExe)
        } else {
            getUserGoalsFromFitnessApp()
        }
    }
}
