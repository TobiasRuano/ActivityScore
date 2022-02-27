//
//  OnboardingViewModel.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 27/02/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import Foundation

class OnboardingViewModel: ObjectivesViewModel {
    
    let healthManager = HealthKitManager.shared
    
    func getUserObjectivesFromFitnessApp(completed: @escaping (Result<(Int, Int), Error>) -> Void) {
        healthManager.getUserGoal { result in
            switch result {
            case .success(let fitnessObjectives):
                let calories = fitnessObjectives.0
                let minutesExe = fitnessObjectives.1
                self.setObjectivesFromHealth(newCalories: calories, newMinutesExe: minutesExe)
                DispatchQueue.main.async {
                    completed(.success((calories, minutesExe)))
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    completed(.failure(error))
                }
            }
        }
    }
}
