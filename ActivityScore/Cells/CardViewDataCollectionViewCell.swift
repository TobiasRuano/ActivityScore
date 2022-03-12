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
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(steps: Int?, calories: Int?, excercise: Int?, distance: Int?, date: Date?) {
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
            let value = Double(distance) / 1000.0
            distanceLabel.text = "\(String(format: "%.01f", value)) KM Walked/Runned"
        }
        if let date = date {
            configureDateLabel(date: date)
        }
    }

    func configureDateLabel(date: Date) {
		dateLabel.text = date.getDayOfWeekName()
    }
}
