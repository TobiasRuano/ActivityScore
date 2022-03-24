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
	@IBOutlet weak var stepsImageView: UIImageView!
	@IBOutlet weak var caloriesImageView: UIImageView!
	@IBOutlet weak var exerciseImageView: UIImageView!
	@IBOutlet weak var distanceImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpImageViews()
    }

	func setUpImageViews() {
		if let stepsImage = UIImage(systemName: "figure.walk") {
			stepsImageView.image = stepsImage
		}

		if let caloriesImage = UIImage(systemName: "flame.fill") {
			caloriesImageView.image = caloriesImage
		}

		if let exerciseImage = UIImage(named: "figure.walk") {
			exerciseImageView.image = exerciseImage
		}

		if let distanceImage = UIImage(named: "distance") {
			distanceImageView.image = distanceImage
		}
	}

    func configureCell(steps: Int?, calories: Int?, excercise: Int?, distance: Int?, date: Date?) {
        if let steps = steps {
            stepsLabel.text = "\(steps)"
        }
        if let calories = calories {
            caloriesLabel.text = "\(calories)"
        }
        if let excercise = excercise {
			excerciseLabel.text = "\(excercise)"
        }
        if let distance = distance {
            let value = Double(distance) / 1000.0
			distanceLabel.text = "\(String(format: "%.01f", value)) KM"
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
