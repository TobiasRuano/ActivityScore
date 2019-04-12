//
//  DailyCalorieTargetTableViewController.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 12/04/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit

class DailyCalorieTargetTableViewController: UITableViewController {
    
    @IBOutlet weak var calorieTextLabel: UITextField!
    
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
            calorieTextLabel.placeholder = "\(userData.calories)cal"
        }
        
//        if let data = UserDefaults.standard.value(forKey: "objectives") as? Data {
//            let copy = try? PropertyListDecoder().decode(Objectives.self, from: data)
//            calorieTextLabel.placeholder = "\(copy!)cal"
//        } else {
//            calorieTextLabel.placeholder = "400cal"
//        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        if calorieTextLabel.text != "" {
            
            var value = Int(calorieTextLabel.text!)
            if value == nil {
                value = 400
            }
            userData.calories = value!
            UserDefaults.standard.set(try? PropertyListEncoder().encode(userData.self), forKey: "objectives")
        }
    }
}
