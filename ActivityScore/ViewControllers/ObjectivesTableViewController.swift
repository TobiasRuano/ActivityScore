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
    
    var userObjectives: Objectives!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.keyboardDismissMode = .interactive
        // Do any additional setup after loading the view.
    }
    
    func setCustomObjectivesSwitch() {
        if let value = userObjectives.usesCustomObjectives {
            customGoalsSwitch.isOn = value
        } else {
            customGoalsSwitch.isOn = false
        }
        
        if customGoalsSwitch.isOn {
            calorieTextField.isEnabled = true
            excerciseTextField.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let data = UserDefaults.standard.value(forKey: "objectives") as? Data {
            let copy = try? PropertyListDecoder().decode(Objectives.self, from: data)
            userObjectives = copy!
            calorieTextField.placeholder = "\(userObjectives.getCalories())cal"
            excerciseTextField.placeholder = "\(userObjectives.getMinutesExe())min"
        } else {
            // TODO: handlear el no tener objetivos
            print("error")
        }
        setCustomObjectivesSwitch()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        handleObjectivesTextFields()
    }
    
    func handleObjectivesTextFields() {
        var activityValue = userObjectives.getCalories()
        var exerciseValue = userObjectives.getMinutesExe()
        
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
        userObjectives.setCustomObjectives(newCalories: activityValue, newMinutesExe: exerciseValue)
    }
    
    @IBAction func setCustomGoalInput(_ sender: Any) {
        if customGoalsSwitch.isOn {
            userObjectives.setUserDefaultsFlag(flag: true)
            calorieTextField.isEnabled = true
            excerciseTextField.isEnabled = true
        } else {
            userObjectives.setUserDefaultsFlag(flag: false)
            calorieTextField.isEnabled = false
            excerciseTextField.isEnabled = false
        }
    }
    
}
