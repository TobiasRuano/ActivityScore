//
//  SecondOnboardingViewController.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 03/03/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit

class SecondOnboardingViewController: UIViewController {
    
    var succesFlag = true
    let healthManager = HealthKitManager.shared
    @IBOutlet weak var authorizeHealthButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleButton()
    }
    
    @IBAction func authorizeHealthButton(_ sender: UIButton) {
        authorizeHealthKit()
    }
    
    func styleButton() {
        authorizeHealthButton.layer.cornerRadius = 15
        authorizeHealthButton.layer.shadowOpacity = 0.5
        authorizeHealthButton.layer.shadowColor = UIColor.black.cgColor
        authorizeHealthButton.layer.shadowRadius = 5
        authorizeHealthButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        authorizeHealthButton.setTitle(" Health Access ", for: .normal)
    }
    
    private func authorizeHealthKit() {
        healthManager.authorizeHealthKit { (authorized, error) in
            guard authorized else {
                let baseMessage = "HealthKit Authorization Failed"
                self.succesFlag = false
                UserDefaults.standard.set(self.succesFlag, forKey: "Flag")
                
                if let error = error {
                    print("\(baseMessage). Reason: \(error.localizedDescription)")
                } else {
                    print(baseMessage)
                }
                return
            }
            print("HealthKit Successfully Authorized.")
            self.succesFlag = true
            UserDefaults.standard.set(self.succesFlag, forKey: "Flag")
        }
    }

}
