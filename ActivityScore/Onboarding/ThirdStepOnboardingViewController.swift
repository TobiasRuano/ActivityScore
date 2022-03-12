//
//  ThirdStepOnboardingViewController.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 11/03/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import UIKit

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
//			UserDefaults.standard.set(true, forKey: "OnboardingScreen")
		}
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
			cell.textField.placeholder = "400"
			return cell
		} else if indexPath.row == 1 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "onboardingCell") as! OnboardingTableViewCell
			cell.title.text = "Exercise Minutes"
			cell.unit.text = "min"
			cell.textField.placeholder = "30"
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
		print(value)
	}
}
