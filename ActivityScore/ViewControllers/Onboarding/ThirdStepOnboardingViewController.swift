//
//  ThirdStepOnboardingViewController.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 11/03/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import UIKit

// swiftlint:disable force_cast line_length
class ThirdStepOnboardingViewController: UIViewController {

	let viewModel = OnboardingViewModel.shared
	@IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

		self.tableView.delegate = self
		let tableViewCellNib = UINib(nibName: "OnboardingTableViewCell", bundle: nil)
		let customGoalsTableViewCellNib = UINib(nibName: "CustomGoalsSwitchTableViewCell", bundle: nil)
		self.tableView.register(tableViewCellNib, forCellReuseIdentifier: "onboardingCell")
		self.tableView.register(customGoalsTableViewCellNib, forCellReuseIdentifier: "CustomGoalsSwitchTableViewCell")
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "toHome" {
			checkCustomGoalsSwitchStatus()
			UserDefaults.standard.set(true, forKey: "OnboardingScreen")
		}
    }

	func checkCustomGoalsSwitchStatus() {
		let customGoalsIndexPath = IndexPath(row: 2, section: 0)
		let customGoalsCell = tableView.cellForRow(at: customGoalsIndexPath) as! CustomGoalsSwitchTableViewCell
		let customGoalsSwitch = customGoalsCell.customGoalsSwitch!

		if customGoalsSwitch.isOn {
			var calories = viewModel.userGoals.calories
			var exercise = viewModel.userGoals.minutesEx

			let activityCellIndexPath = IndexPath(row: 0, section: 0)
			let activityCell = tableView.cellForRow(at: activityCellIndexPath) as! OnboardingTableViewCell

			let exerciseCellIndexPath = IndexPath(row: 1, section: 0)
			let exerciseCell = tableView.cellForRow(at: exerciseCellIndexPath) as! OnboardingTableViewCell

			if let caloriesText = activityCell.textField.text {
				if let value = Int(caloriesText) {
					viewModel.changeUsesCustomGoals(value: true)
					calories = value
				}
			}
			if let exerciseText = exerciseCell.textField.text {
				if let value = Int(exerciseText) {
					viewModel.changeUsesCustomGoals(value: true)
					exercise = value
				}
			}
			viewModel.setCustomGoals(newCalories: calories, newMinutesExe: exercise)
		}
	}

	func defaultGoals() {
		let cal = viewModel.userGoals.calories
		let min = viewModel.userGoals.minutesEx

		let activityCellIndexPath = IndexPath(row: 0, section: 0)
		let activityCell = tableView.cellForRow(at: activityCellIndexPath) as! OnboardingTableViewCell
		activityCell.textField.isEnabled = false
		activityCell.textField.placeholder = "\(cal)"

		let exerciseCellIndexPath = IndexPath(row: 1, section: 0)
		let exerciseCell = tableView.cellForRow(at: exerciseCellIndexPath) as! OnboardingTableViewCell
		exerciseCell.textField.isEnabled = false
		exerciseCell.textField.placeholder = "\(min)"
	}

}

extension ThirdStepOnboardingViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 3
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "onboardingCell") as! OnboardingTableViewCell
			cell.title.text = "Active Energy"
			cell.unit.text = "cal"
			cell.textField.placeholder = "\(viewModel.userGoals.calories)"
			return cell
		} else if indexPath.row == 1 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "onboardingCell") as! OnboardingTableViewCell
			cell.title.text = "Exercise Minutes"
			cell.unit.text = "min"
			cell.textField.placeholder = "\(viewModel.userGoals.minutesEx)"
			return cell
		} else {
			let cell = tableView.dequeueReusableCell(withIdentifier: "CustomGoalsSwitchTableViewCell") as! CustomGoalsSwitchTableViewCell
			cell.delegate = self
			return cell
		}
	}

}

extension ThirdStepOnboardingViewController: CustomGoalsSwitchTableViewCellProtocol {
	func switchValueChanged(value: Bool) {
		if value {
			let activityCellIndexPath = IndexPath(row: 0, section: 0)
			let activityCell = tableView.cellForRow(at: activityCellIndexPath) as! OnboardingTableViewCell
			activityCell.textField.isEnabled = true
			activityCell.textField.placeholder = ""
			activityCell.textField.text = ""

			let exerciseCellIndexPath = IndexPath(row: 1, section: 0)
			let exerciseCell = tableView.cellForRow(at: exerciseCellIndexPath) as! OnboardingTableViewCell
			exerciseCell.textField.isEnabled = true
			exerciseCell.textField.placeholder = ""
			exerciseCell.textField.text = ""
		} else {
			defaultGoals()
		}
	}
}

extension ThirdStepOnboardingViewController: SecondStepOnboardingViewControllerProtocol {
	func setDefaultGoals(activity: Int, exercise: Int) {
		// defaultGoals()
	}
}
