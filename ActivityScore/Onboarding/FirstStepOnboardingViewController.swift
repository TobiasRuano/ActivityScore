//
//  FirstStepOnboardingViewController.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 11/03/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import UIKit

class FirstStepOnboardingViewController: UIViewController {

	@IBOutlet weak var firstIcon: UIImageView!
	@IBOutlet weak var secondIcon: UIImageView!
	@IBOutlet weak var appIconImageView: UIImageView!
	@IBOutlet weak var thirdIcon: UIImageView!

	override func viewDidLoad() {
        super.viewDidLoad()
		configureIcons()
    }

	func configureIcons() {
		self.appIconImageView.image = UIImage(named: "AppIcon60x60")
		self.appIconImageView.layer.cornerRadius = 15
		self.appIconImageView.layer.shadowColor = UIColor.black.cgColor
		self.appIconImageView.layer.shadowOpacity = 0.5

		self.firstIcon.image = UIImage(systemName: "flame.fill")
		self.secondIcon.image = UIImage(systemName: "figure.walk")
		self.thirdIcon.image = UIImage(named: "combo_chart")

		self.firstIcon.tintColor = .systemRed
		self.secondIcon.tintColor = .systemGreen
		self.thirdIcon.tintColor = .systemPink
	}

	// MARK: - Actions
	@IBAction func actionButtonTapped(_ sender: UIButton) {
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
