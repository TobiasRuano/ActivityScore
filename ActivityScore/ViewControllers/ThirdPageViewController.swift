//
//  ThirdPageViewController.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 03/03/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit

class ThirdPageViewController: UIViewController {

    @IBOutlet weak var letsGoButton: UIButton!
    @IBOutlet weak var caloriesView: UIView!
    @IBOutlet weak var exerciseView: UIView!
    @IBOutlet weak var caloriesTextField: UITextField!
    @IBOutlet weak var exerciseTextField: UITextField!
    @IBOutlet weak var customGoalsSwitch: UISwitch!
    
    let healthManager = HealthKitManager.shared
    var userObjectives = Objectives()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleButton()
        styleView()
        getUserObjectivesFromFitnessApp()
    }
    
    func getUserObjectivesFromFitnessApp() {
        healthManager.getUserGoal { result in
            switch result {
            case .success(let fitnessObjectives):
                let calories = fitnessObjectives.0
                let minutesExe = fitnessObjectives.1
                self.userObjectives.setObjectivesFromHealth(newCalories: calories, newMinutesExe: minutesExe)
                DispatchQueue.main.async {
                    self.caloriesTextField.placeholder = "\(calories) cal"
                    self.exerciseTextField.placeholder = "\(minutesExe) min"
                }
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    
    @IBAction func didEndEditingTextField(_ sender: Any) {
    }
    
    @IBAction func ExitToRootViewController(_ sender: UIButton) {
        if customGoalsSwitch.isOn {
            var calories = userObjectives.getCalories()
            var exercise = userObjectives.getMinutesExe()
            if let caloriesText = caloriesTextField.text {
                if let value = Int(caloriesText) {
                    userObjectives.setUserDefaultsFlag(flag: true)
                    calories = value
                }
            }
            if let exerciseText = exerciseTextField.text {
                if let value = Int(exerciseText) {
                    userObjectives.setUserDefaultsFlag(flag: true)
                    exercise = value
                }
            }
            userObjectives.setCustomObjectives(newCalories: calories, newMinutesExe: exercise)
        }
        
        UserDefaults.standard.set(true, forKey: "OnboardingScreen")
        self.dismiss(animated: true, completion: nil)
    }
    
    func styleButton() {
        letsGoButton.layer.cornerRadius = 15
        letsGoButton.layer.shadowOpacity = 0.5
        letsGoButton.layer.shadowColor = UIColor.black.cgColor
        letsGoButton.layer.shadowRadius = 5
        letsGoButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        letsGoButton.setTitle(" Let's Go! ", for: .normal)
    }
    
    func styleView() {
        caloriesView.layer.cornerRadius = 10
        caloriesView.layer.shadowRadius = 10
        caloriesView.layer.shadowColor = UIColor.lightGray.cgColor
        caloriesView.layer.masksToBounds = false
        caloriesView.layer.shadowOpacity = 0.5
        
        exerciseView.layer.cornerRadius = 10
        exerciseView.layer.shadowRadius = 10
        exerciseView.layer.shadowColor = UIColor.lightGray.cgColor
        exerciseView.layer.masksToBounds = false
        exerciseView.layer.shadowOpacity = 0.5
    }
    
    @IBAction func selectGoalInput(_ sender: Any) {
        if customGoalsSwitch.isOn {
            userObjectives.setUserDefaultsFlag(flag: true)
            caloriesTextField.isEnabled = true
            exerciseTextField.isEnabled = true
        } else {
            // correjir placeholder con health data
            userObjectives.setUserDefaultsFlag(flag: false)
            caloriesTextField.isEnabled = false
            exerciseTextField.isEnabled = false
        }
    }
    
}
