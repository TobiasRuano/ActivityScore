//
//  CustomGoalsSwitchTableViewCell.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 12/03/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import UIKit

protocol CustomGoalsSwitchTableViewCellProtocol {
	func switchValueChanged(value: Bool)
}

class CustomGoalsSwitchTableViewCell: UITableViewCell {

	var delegate: CustomGoalsSwitchTableViewCellProtocol?
	@IBOutlet weak var customGoalsSwitch: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	@IBAction func switchValueChanged(_ sender: Any) {
		if customGoalsSwitch.isOn {
			delegate?.switchValueChanged(value: true)
		} else {
			delegate?.switchValueChanged(value: false)
		}
	}

}
