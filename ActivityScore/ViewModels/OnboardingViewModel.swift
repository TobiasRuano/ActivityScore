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
    var succesFlag = true
    
    static let shared = OnboardingViewModel()
    
    private override init() { }
    
    func authorizeHealthKit() {
        healthManager.authorizeHealthKit { authorized, error in
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
        }
    }
    
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
