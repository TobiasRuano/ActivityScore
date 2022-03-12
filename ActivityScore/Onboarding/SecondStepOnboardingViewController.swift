//
//  SecondStepOnboardingViewController.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 11/03/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import UIKit

class SecondStepOnboardingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

	@IBAction func actionButtonTapped(_ sender: Any) {
		if let pageController = parent as? MainPageOnboardingViewController {
			pageController.pushNext()
		}
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
