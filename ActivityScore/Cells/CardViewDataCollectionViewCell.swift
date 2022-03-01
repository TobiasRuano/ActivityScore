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
            distanceLabel.text = "\(String(format:"%.01f", distance / 1000)) KM Walked/Runned"
        }
        if let date = date {
            configureDateLabel(date: date)
        }
    }
    
    func configureDateLabel(date: Date) {
        let today = Date()
        let interval = TimeInterval(-86400)
        let yesterday = Date(timeInterval: interval, since: today)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        
        let todayText = formatter.string(from: today)
        let yesterdayText = formatter.string(from: yesterday)
        let dateText = formatter.string(from: date)
        
        if dateText == todayText {
            dateLabel.text = "Today"
        } else if dateText == yesterdayText {
            dateLabel.text = "Yesterday"
        } else {
            dateLabel.text = dateText
        }
    }

}
