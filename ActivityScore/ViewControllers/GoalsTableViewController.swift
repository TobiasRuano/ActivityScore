//
//  GoalsTableViewController.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 12/04/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit

class GoalsTableViewController: UITableViewController {

    @IBOutlet weak var calorieTextField: UITextField!
    @IBOutlet weak var customGoalsSwitch: UISwitch!
    @IBOutlet weak var excerciseTextField: UITextField!

    var objectivesViewModel = GoalsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.keyboardDismissMode = .interactive
        // Do any additional setup after loading the view.
    }

    func setCustomGoalsSwitch() {
        if let value = objectivesViewModel.userGoals.usesCustomGoals {
            customGoalsSwitch.isOn = value
        } else {
            customGoalsSwitch.isOn = false
            objectivesViewModel.setDefaultFitnessGoals()
        }

        if customGoalsSwitch.isOn {
            calorieTextField.isEnabled = true
            excerciseTextField.isEnabled = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        calorieTextField.placeholder = "\(objectivesViewModel.userGoals.calories)cal"
        excerciseTextField.placeholder = "\(objectivesViewModel.userGoals.minutesEx)min"
        setCustomGoalsSwitch()
    }

    override func viewWillDisappear(_ animated: Bool) {
        handleGoalsTextFields()
    }

    func handleGoalsTextFields() {
        var activityValue = objectivesViewModel.userGoals.calories
        var exerciseValue = objectivesViewModel.userGoals.minutesEx

        if let caloriesText = calorieTextField.text, !caloriesText.isEmpty {
            if let value = Int(caloriesText) {
                activityValue = value
            }
        }

        if let exerciseText = excerciseTextField.text, !exerciseText.isEmpty {
            if let value = Int(exerciseText) {
                exerciseValue = value
            }
        }
        objectivesViewModel.setCustomGoals(newCalories: activityValue, newMinutesExe: exerciseValue)
    }

    @IBAction func setCustomGoalInput(_ sender: Any) {
        if customGoalsSwitch.isOn {
            objectivesViewModel.changeUsesCustomGoals(value: true)
            calorieTextField.isEnabled = true
            excerciseTextField.isEnabled = true
        } else {
            objectivesViewModel.changeUsesCustomGoals(value: false)
            calorieTextField.isEnabled = false
            excerciseTextField.isEnabled = false
            calorieTextField.text = nil
            excerciseTextField.text = nil
            defaultGoal()
        }
    }

    func defaultGoal() {
        objectivesViewModel.getUserGoalsFromFitnessApp { result in
            switch result {
            case .success(let values):
                DispatchQueue.main.async {
                    self.calorieTextField.placeholder = "\(values.0) cal"
                    self.excerciseTextField.placeholder = "\(values.1) min"
                }
            case .failure:
                DispatchQueue.main.async {
                    self.calorieTextField.placeholder = "\(0) cal"
                    self.excerciseTextField.placeholder = "\(1) min"
                }
            }
        }
    }
}
