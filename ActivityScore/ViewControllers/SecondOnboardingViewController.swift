//
//  SecondOnboardingViewController.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 03/03/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit

class SecondOnboardingViewController: UIViewController {
    
    let onboardingViewModel = OnboardingViewModel.shared
    @IBOutlet weak var authorizeHealthButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleButton()
    }
    
    @IBAction func authorizeHealthButton(_ sender: UIButton) {
        onboardingViewModel.authorizeHealthKit()
    }
    
    func styleButton() {
        authorizeHealthButton.layer.cornerRadius = 15
        authorizeHealthButton.layer.shadowOpacity = 0.5
        authorizeHealthButton.layer.shadowColor = UIColor.black.cgColor
        authorizeHealthButton.layer.shadowRadius = 5
        authorizeHealthButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        authorizeHealthButton.setTitle(" Health Access ", for: .normal)
    }

}
