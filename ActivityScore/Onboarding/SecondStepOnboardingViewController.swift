//
//  SecondStepOnboardingViewController.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 11/03/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import UIKit
import ProgressHUD

protocol SecondStepOnboardingViewControllerProtocol {
	func setDefaultGoals(activity: Int, exercise: Int)
}

class SecondStepOnboardingViewController: UIViewController {

	@IBOutlet weak var healthAuthorizeButton: UIButton!
	@IBOutlet weak var healthAppIconImageView: UIImageView!
	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var nextButton: UIButton!

	let healthManager = HealthKitManager.shared
	let viewModel = OnboardingViewModel.shared
	var delegate: SecondStepOnboardingViewControllerProtocol?

	override func viewDidLoad() {
        super.viewDidLoad()
		styleHealthButtonView()
		styleHealthAppIcon()
		healthAuthorizeButton.setTitle("", for: .normal)
		nextButton.isEnabled = false
    }

	func styleHealthButtonView() {
		containerView.layer.cornerRadius = 15
		containerView.backgroundColor = .secondarySystemBackground
	}

	@IBAction func actionButtonTapped(_ sender: Any) {
		if let pageController = parent as? MainPageOnboardingViewController {
			pageController.pushNext()
		}
	}

	func styleHealthAppIcon() {
		let outerView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
		outerView.clipsToBounds = false
		outerView.layer.shadowColor = UIColor.black.cgColor
		outerView.layer.shadowOpacity = 1
		outerView.layer.shadowOffset = CGSize.zero
		outerView.layer.shadowRadius = 10
		outerView.layer.shadowPath = UIBezierPath(roundedRect: outerView.bounds, cornerRadius: 10).cgPath

		healthAppIconImageView.frame = outerView.frame
		healthAppIconImageView.clipsToBounds = true
		healthAppIconImageView.layer.cornerRadius = 10

		healthAppIconImageView.layer.borderColor = UIColor.black.cgColor
	}

	@IBAction func healthauthorizationButtonFinishedTapping(_ sender: Any) {
		animateContainerBackgroundColor(with: .secondarySystemBackground)
		viewModel.authorizeHealthKit {
			self.viewModel.getUserGoalsFromFitnessApp { result in
				switch result {
				case .success(let goals):
					DispatchQueue.main.async {
						self.nextButton.isEnabled = true
						self.containerView.isHidden = true
						self.healthAuthorizeButton.isHidden = true
						ProgressHUD.showSucceed()
						TapticEffectsService.performFeedbackNotification(type: .success)
						self.delegate?.setDefaultGoals(activity: goals.0, exercise: goals.1)
					}
				case .failure(let error):
					let alert = UIAlertController(title: "Uppss, we encounter an issue",
												  message: "While trying to get your activity goals from the Activity App this happened: \(error)",
												  preferredStyle: .alert)
					let action = UIAlertAction(title: "OK", style: .default)
					alert.addAction(action)
					self.present(alert, animated: true)
				}
			}
		}
	}

	@IBAction func healthAutorizationButtonDragged(_ sender: Any) {
		animateContainerBackgroundColor(with: .secondarySystemBackground)
	}

	@IBAction func healthAuthorizationButtonTapped(_ sender: Any) {
		animateContainerBackgroundColor(with: .separator)
	}

	func animateContainerBackgroundColor(with color: UIColor) {
		UIView.animate(withDuration: 0.1) {
			self.containerView.backgroundColor = color
		}
	}

}
