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
    @IBOutlet weak var textLabelView: UIView!
    @IBOutlet weak var caloriesLabel: UITextField!
    
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
        var value = Int(caloriesLabel.text!)
        if value == nil {
            value = 400
        }
        userData.calories = value!
        print(userData.calories)
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
        textLabelView.layer.cornerRadius = 10
        textLabelView.layer.shadowRadius = 10
        textLabelView.layer.shadowColor = UIColor.lightGray.cgColor
        textLabelView.layer.masksToBounds = false
        textLabelView.layer.shadowOpacity = 0.5
    }
    

}
