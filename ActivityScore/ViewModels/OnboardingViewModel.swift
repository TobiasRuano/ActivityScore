//
//  OnboardingViewModel.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 27/02/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import Foundation

class OnboardingViewModel: GoalsViewModel {

    var succesFlag = true
    private var caloriesHealth: Int?
    private var minuteExe: Int?
    static let shared = OnboardingViewModel()

    private override init() { }

	func authorizeHealthKit(completed: @escaping (() -> Void)) {
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
			completed()
        }
    }

//    func getUserGoalsFromFitnessApp(completed: @escaping (Result<(Int, Int), Error>) -> Void) {
//        healthManager.getUserGoal { result in
//            switch result {
//            case .success(let fitnessGoals):
//                self.caloriesHealth = fitnessGoals.0
//                self.minuteExe = fitnessGoals.1
//                self.setGoals(newCalories: self.caloriesHealth!, newMinutesExe: self.minuteExe!)
//                DispatchQueue.main.async {
//                    completed(.success((self.caloriesHealth!, self.minuteExe!)))
//                }
//            case .failure(let error):
//                self.setGoals(newCalories: 0, newMinutesExe: 0)
//                DispatchQueue.main.async {
//                    completed(.failure(error))
//                }
//            }
//        }
//    }
}
