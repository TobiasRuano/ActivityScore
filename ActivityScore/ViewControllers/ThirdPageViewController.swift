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
    
    var userData = Objectives()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleButton()
        styleView()
    }
    @IBAction func didEndEditingTextField(_ sender: Any) {
    }
    
    @IBAction func ExitToRootViewController(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "OnboardingScreen")
        var activityValue = Int(caloriesTextField.text!)
        var exerciseValue = Int(exerciseTextField.text!)
        if activityValue == nil {
            activityValue = 400
        }
        if exerciseValue == nil {
            exerciseValue = 30
        }
        userData.calories = activityValue!
        userData.minutesEx = exerciseValue!
        UserDefaults.standard.set(try? PropertyListEncoder().encode(userData.self), forKey: "objectives")
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
    

}
