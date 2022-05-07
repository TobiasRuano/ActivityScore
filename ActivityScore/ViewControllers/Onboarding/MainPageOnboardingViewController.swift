//
//  MainPageOnboardingViewController.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 11/03/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import UIKit

// swiftlint:disable force_cast line_length
class MainPageOnboardingViewController: UIPageViewController {

	// MARK: - UI Elements
	private var viewControllerList: [UIViewController] = {
		let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
		let firstVC = storyboard.instantiateViewController(withIdentifier: "FirstStepOnboardingVC") as! FirstStepOnboardingViewController
		let secondVC = storyboard.instantiateViewController(withIdentifier: "SecondStepOnboardingVC") as! SecondStepOnboardingViewController
		let thirdVC = storyboard.instantiateViewController(withIdentifier: "ThirdStepOnboardingVC") as! ThirdStepOnboardingViewController

		secondVC.delegate = thirdVC
		return [firstVC, secondVC, thirdVC]
	}()

	// MARK: - Properties
	private var currentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
		self.setViewControllers([viewControllerList[0]], direction: .forward, animated: false, completion: nil)
    }

	// MARK: - Functions
	func pushNext() {
		if currentIndex + 1 < viewControllerList.count {
			self.setViewControllers([self.viewControllerList[self.currentIndex + 1]],
									direction: .forward,
									animated: true,
									completion: nil)
			currentIndex += 1
		}
	}

	func pushBack() {
		if currentIndex > 0 {
			self.setViewControllers([self.viewControllerList[self.currentIndex - 1]],
									direction: .reverse,
									animated: true,
									completion: nil)
			currentIndex -= 1
		}
	}

	func updateThirdViewControllerGoals() {

	}

}
