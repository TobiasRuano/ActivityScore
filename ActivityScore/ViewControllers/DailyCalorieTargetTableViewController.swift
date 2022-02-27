//
//  DailyCalorieTargetTableViewController.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 12/04/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit

class DailyCalorieTargetTableViewController: UITableViewController {
    
    @IBOutlet weak var calorieTextField: UITextField!
    @IBOutlet weak var excerciseTextField: UITextField!
    
    var userData = Objectives()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.keyboardDismissMode = .interactive
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let data = UserDefaults.standard.value(forKey: "objectives") as? Data {
            let copy = try? PropertyListDecoder().decode(Objectives.self, from: data)
            userData = copy!
            calorieTextField.placeholder = "\(userData.getCalories())cal"
            excerciseTextField.placeholder = "\(userData.getMinutesExe())min"
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        handleObjectivesTextFields()
    }
    
    func handleObjectivesTextFields() {
        var activityValue = userData.getCalories()
        var exerciseValue = userData.getMinutesExe()
        
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
        userData.setCustomObjectives(newCalories: activityValue, newMinutesExe: exerciseValue)
    }
}
