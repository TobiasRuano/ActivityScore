//
//  ObjectivesTableViewController.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 12/04/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit

class ObjectivesTableViewController: UITableViewController {
    
    @IBOutlet weak var calorieTextField: UITextField!
    @IBOutlet weak var customGoalsSwitch: UISwitch!
    @IBOutlet weak var excerciseTextField: UITextField!

    var objectivesViewModel = ObjectivesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.keyboardDismissMode = .interactive
        // Do any additional setup after loading the view.
    }
    
    func setCustomObjectivesSwitch() {
        if let value = objectivesViewModel.userObjectives.usesCustomObjectives {
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
        calorieTextField.placeholder = "\(objectivesViewModel.userObjectives.calories)cal"
        excerciseTextField.placeholder = "\(objectivesViewModel.userObjectives.minutesEx)min"
        setCustomObjectivesSwitch()
    }

    override func viewWillDisappear(_ animated: Bool) {
        handleObjectivesTextFields()
    }
    
    func handleObjectivesTextFields() {
        var activityValue = objectivesViewModel.userObjectives.calories
        var exerciseValue = objectivesViewModel.userObjectives.minutesEx
        
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
        objectivesViewModel.setCustomObjectives(newCalories: activityValue, newMinutesExe: exerciseValue)
    }

    @IBAction func setCustomGoalInput(_ sender: Any) {
        if customGoalsSwitch.isOn {
            objectivesViewModel.changeUsesCustomObjectives(value: true)
            calorieTextField.isEnabled = true
            excerciseTextField.isEnabled = true
        } else {
            objectivesViewModel.changeUsesCustomObjectives(value: false)
            calorieTextField.isEnabled = false
            excerciseTextField.isEnabled = false
            calorieTextField.text = nil
            excerciseTextField.text = nil
            defaultGoal()
        }
    }

    func defaultGoal() {
        objectivesViewModel.getUserObjectivesFromFitnessApp { result in
            switch result {
            case .success(let values):
                DispatchQueue.main.async {
                    self.calorieTextField.placeholder = "\(values.0) cal"
                    self.excerciseTextField.placeholder = "\(values.1) min"
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.calorieTextField.placeholder = "\(0) cal"
                    self.excerciseTextField.placeholder = "\(1) min"
                }
            }
        }
    }
}
