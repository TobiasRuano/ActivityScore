//
//  CardViewDataCollectionViewCell.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 24/02/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import UIKit

class CardViewDataCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var excerciseLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(steps: Int?, calories: Int?, excercise: Int?, distance: Int?) {
        if let steps = steps {
            stepsLabel.text = "\(steps) Steps"
        }
        if let calories = calories {
            caloriesLabel.text = "\(calories) Calories"
        }
        if let excercise = excercise {
            excerciseLabel.text = "\(excercise) Excercise Minutes"
        }
        if let distance = distance {
            distanceLabel.text = "\(String(format:"%.01f", distance / 1000)) KM Walked/Runned"
        }
    }

}
