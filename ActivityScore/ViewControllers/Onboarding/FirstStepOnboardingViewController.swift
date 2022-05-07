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
	@IBOutlet weak var thirdIcon: UIImageView!

	override func viewDidLoad() {
        super.viewDidLoad()
		configureIcons()
    }

	func configureIcons() {

		self.firstIcon.image = UIImage(systemName: "flame.fill")
//		self.secondIcon.image = UIImage(systemName: "figure.walk")
		let gymImage = UIImage(named: "gym")!
		let trophyImage = UIImage(named: "award")!

		self.firstIcon.tintColor = .orange
		self.secondIcon.tintColor = .systemGreen

		let gymTintedImage = gymImage.withRenderingMode(.alwaysTemplate)
		self.secondIcon.image = gymTintedImage
		self.secondIcon.tintColor = .systemGreen

		let tintedImage = trophyImage.withRenderingMode(.alwaysTemplate)
		self.thirdIcon.image = tintedImage
		self.thirdIcon.tintColor = UIColor(red: 255/255, green: 215/255, blue: 0, alpha: 1.0)
	}

	// MARK: - Actions
	@IBAction func actionButtonTapped(_ sender: UIButton) {
		if let pageController = parent as? MainPageOnboardingViewController {
			pageController.pushNext()
		}
	}
}
