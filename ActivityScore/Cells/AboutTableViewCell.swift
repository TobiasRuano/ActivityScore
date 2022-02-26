//
//  AboutTableViewCell.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 26/02/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import UIKit

class AboutTableViewCell: UITableViewCell {
    
    static let cellID = "AboutCell"

    @IBOutlet weak var cellPrimaryText: UILabel!
    @IBOutlet weak var cellSecondaryText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
