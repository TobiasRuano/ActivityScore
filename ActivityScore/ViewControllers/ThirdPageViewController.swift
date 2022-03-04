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
    
    let onboardingViewModel = OnboardingViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleButton()
        styleView()
        onboardingViewModel.getUserObjectivesFromFitnessApp { result in
            switch result {
            case .success(let fitnessObjectives):
                self.caloriesTextField.placeholder = "\(Int(fitnessObjectives.0)) cal"
                self.exerciseTextField.placeholder = "\(Int(fitnessObjectives.1)) min"
            case .failure(_):
                self.caloriesTextField.placeholder = "0 cal"
                self.exerciseTextField.placeholder = "0 min"
            }
        }
    }
    
    @IBAction func didEndEditingTextField(_ sender: Any) {
    }

    @IBAction func ExitToRootViewController(_ sender: UIButton) {
        if customGoalsSwitch.isOn {
            var calories = onboardingViewModel.userObjectives.calories
            var exercise = onboardingViewModel.userObjectives.minutesEx
            if let caloriesText = caloriesTextField.text {
                if let value = Int(caloriesText) {
                    onboardingViewModel.changeUsesCustomObjectives(value: true)
                    calories = value
                }
            }
            if let exerciseText = exerciseTextField.text {
                if let value = Int(exerciseText) {
                    onboardingViewModel.changeUsesCustomObjectives(value: true)
                    exercise = value
                }
            }
            onboardingViewModel.setCustomObjectives(newCalories: calories, newMinutesExe: exercise)
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
            onboardingViewModel.changeUsesCustomObjectives(value: true)
            caloriesTextField.isEnabled = true
            exerciseTextField.isEnabled = true
        } else {
            onboardingViewModel.changeUsesCustomObjectives(value: false)
            caloriesTextField.isEnabled = false
            exerciseTextField.isEnabled = false
            caloriesTextField.text = nil
            exerciseTextField.text = nil
            defaultGoal()
        }
    }

    func defaultGoal() {
        onboardingViewModel.getUserObjectivesFromFitnessApp { result in
            switch result {
            case .success(let values):
                DispatchQueue.main.async {
                    self.caloriesTextField.placeholder = "\(values.0) cal"
                    self.exerciseTextField.placeholder = "\(values.1) min"
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.caloriesTextField.placeholder = "\(0) cal"
                    self.exerciseTextField.placeholder = "\(1) min"
                }
            }
        }
    }
}
