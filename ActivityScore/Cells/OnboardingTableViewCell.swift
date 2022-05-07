//
//  OnboardingTableViewCell.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 12/03/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import UIKit

class OnboardingTableViewCell: UITableViewCell {

	@IBOutlet weak var title: UILabel!
	@IBOutlet weak var unit: UILabel!
	@IBOutlet weak var textField: UITextField!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
