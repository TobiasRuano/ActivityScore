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
            calorieTextField.placeholder = "\(userData.calories)cal"
            excerciseTextField.placeholder = "\(userData.minutesEx)min"
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        if calorieTextField.text != "" {
            var activityValue = Int(calorieTextField.text!)
            if activityValue == nil {
                activityValue = 400
            }
            userData.calories = activityValue!
        }
        
        if excerciseTextField.hasText {
            var exerciseValue = Int(excerciseTextField.text!)
            if exerciseValue == nil {
                exerciseValue = 400
            }
            userData.minutesEx = exerciseValue!
        }
        UserDefaults.standard.set(try? PropertyListEncoder().encode(userData.self), forKey: "objectives")
    }
}
