//
//  ThirdPageViewController.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 03/03/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit

class ThirdPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func ExitToRootViewController(_ sender: UIButton) {
        print("testeando")
        UserDefaults.standard.set(true, forKey: "OnboardingScreen")
        
        performSegue(withIdentifier: "ExitOnboarding", sender: self)
    }
    

}
