//
//  ScoreViewModel.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 26/02/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import Foundation

protocol ScoreViewModelProtocol: Any {
    func setView(scoreText: String, descriptionText: String)
}

class ScoreViewModel {

    let healthManager = HealthKitManager.shared
    private var succesFlag = true
    private var inAppPurchase = false
    private var user = Fitness()
    var delegate: ScoreViewModelProtocol?

    func retrieveHealthData() {
        user.getGoals()
        var check = 0
        healthManager.getData(type: .stepCount, unit: .count(), days: 7) { result in
            switch result {
            case .success(let steps):
                self.user.setItemInDailyData(amounts: steps, type: .steps)
                check += 1
                if check == 4 {
                    self.obtainScoreNumber { values in
                        self.delegate?.setView(scoreText: values.1, descriptionText: values.0)
                    }
                }
            case .failure(_):
                break
            }
        }

        healthManager.getData(type: .activeEnergyBurned, unit: .kilocalorie(), days: 7) { result in
            switch result {
            case .success(let calories):
                self.user.setItemInDailyData(amounts: calories, type: .calories)
                check += 1
                if check == 4 {
                    self.obtainScoreNumber { values in
                        self.delegate?.setView(scoreText: values.1, descriptionText: values.0)
                    }
                }
            case .failure(_):
                break
            }
        }

        healthManager.getData(type: .appleExerciseTime, unit: .minute(), days: 7) { result in
            switch result {
            case .success(let exercice):
                self.user.setItemInDailyData(amounts: exercice, type: .exercise)
                check += 1
                if check == 4 {
                    self.obtainScoreNumber { values in
                        self.delegate?.setView(scoreText: values.1, descriptionText: values.0)
                    }
                }
            case .failure(_):
                break
            }
        }

        healthManager.getData(type: .distanceWalkingRunning, unit: .meter(), days: 7) { result in
            switch result {
            case .success(let distance):
                self.user.setItemInDailyData(amounts: distance, type: .distance)
                check += 1
                if check == 4 {
                    self.obtainScoreNumber { values in
                        self.delegate?.setView(scoreText: values.1, descriptionText: values.0)
                    }
                }
            case .failure(_):
                break
            }
        }
    }

    func checkPurchaseStatus(completed: @escaping(Bool) -> Void) {
        if let inAppKeyValue = UserDefaults.standard.value(forKey: "purchase") as? Bool {
            inAppPurchase = inAppKeyValue
        }
        #if DEBUG
        inAppPurchase = false
        #endif
        if inAppPurchase == false {
            completed(true)
        } else {
            completed(false)
        }
    }

    func getFitnessDataInOrder() -> [Dictionary<Date, DailyData>.Element] {
        return user.getFitnessData().sorted(by: { $0.0 < $1.0 })
    }

    // MARK: - Authorize healthKit
    func authorizeHealthKit(completed: @escaping(Bool) -> Void) {
        healthManager.authorizeHealthKit { (authorized, error) in
            guard authorized else {
                let baseMessage = "HealthKit Authorization Failed"
                self.succesFlag = false
                UserDefaults.standard.set(self.succesFlag, forKey: "Flag")
                if let error = error {
                    print("\(baseMessage). Reason: \(error.localizedDescription)")
                } else {
                    print(baseMessage)
                }
                completed(false)
                return
            }
            print("HealthKit Successfully Authorized.")
            self.succesFlag = true
            UserDefaults.standard.set(self.succesFlag, forKey: "Flag")
            completed(true)
        }
    }

    func obtainScoreNumber(completed: @escaping((String, String)) -> Void) {
        // TODO: tener en cuenta los objetivos del usuario para el calculo
        user.obtainScoreNumber()
        var cheeringText = ""
        var scoreText = ""
        let hour = Calendar.current.component(.hour, from: Date())
        let weekData = user.getFitnessData().sorted(by: { $0.0 < $1.0 })
        if let today = weekData.last {
            scoreText = String(today.value.score)

            if today.value.score < 20 {
                if hour < 10 {
                    cheeringText = "Let's own the day! 💪"
                } else if hour < 17 {
                    cheeringText = "Let's go for a walk! 🚶‍♂️"
                } else {
                    cheeringText = "SO LAZY! 😡"
                }
            } else if today.value.score > 19 && today.value.score < 40 {
                if hour < 10 {
                    cheeringText = "Let's own the day! 💪"
                } else if hour < 17 {
                    cheeringText = "Not bad, but you could do better. 🤷‍♂️"
                } else if hour < 19 {
                    cheeringText = "Let's get out there and work out! 😃"
                } else {
                    cheeringText = "You'll do better tomorrow! 😔"
                }
            } else if today.value.score > 39 && today.value.score < 70 {
                if hour < 10 {
                    cheeringText = "What a way to start the day. 👏"
                } else if hour < 17 {
                    cheeringText = "Great Job! 💪"
                } else {
                    cheeringText = "Great Job! 💪"
                }
            } else if today.value.score > 69 {
                if hour < 10 {
                    cheeringText = "Excelent way to start the Day! 👍"
                } else if hour < 17 {
                    cheeringText = "KEEP IT UP! 🏆"
                } else {
                    cheeringText = "WOW, WHAT A DAY!! 👏"
                }
            }
        }

        // Check if theres data. If there is, health label should be ENABLED
        if !scoreText.isEmpty {
            UserDefaults.standard.set(true, forKey: "Flag")
        }
		
        DispatchQueue.main.async {
            completed((cheeringText, scoreText))
        }
    }
}
