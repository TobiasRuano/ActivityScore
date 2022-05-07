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
	@IBOutlet weak var caloriesImageCircularView: UIView!
	@IBOutlet weak var exerciseImageCircularView: UIView!
	@IBOutlet weak var stepsImageCircularView: UIView!
	@IBOutlet weak var distanceImageCircularView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpImageViews()
		configCircularViews()
    }

	private func configCircularViews() {
		caloriesImageCircularView.layer.cornerRadius = caloriesImageCircularView.frame.width / 2
		exerciseImageCircularView.layer.cornerRadius = exerciseImageCircularView.frame.width / 2
		stepsImageCircularView.layer.cornerRadius = stepsImageCircularView.frame.width / 2
		distanceImageCircularView.layer.cornerRadius = distanceImageCircularView.frame.width / 2
	}

	private func setUpImageViews() {
		if let stepsImage = UIImage(systemName: "figure.walk") {
			stepsImage.withTintColor(.systemYellow, renderingMode: .alwaysTemplate)
			stepsImageView.image = stepsImage
		}

		if let caloriesImage = UIImage(systemName: "flame.fill") {
			caloriesImage.withTintColor(.systemPink, renderingMode: .alwaysTemplate)
			caloriesImageView.image = caloriesImage
		}

		if let exerciseImage = UIImage(systemName: "clock.fill") {
			exerciseImage.withTintColor(.systemGreen, renderingMode: .alwaysTemplate)
			exerciseImageView.image = exerciseImage
		}

		if let distanceImage = UIImage(systemName: "figure.stand.line.dotted.figure.stand") {
			distanceImage.withTintColor(.systemTeal, renderingMode: .alwaysTemplate)
			distanceImageView.image = distanceImage
		}
	}

    func configureCell(steps: Int?, calories: Int?, excercise: Int?, distance: Int?, date: Date?) {
		// TODO: tener en cuenta las unidades
        if let steps = steps {
            stepsLabel.text = "\(steps)"
        }
        if let calories = calories {
            caloriesLabel.text = "\(calories) cal"
        }
        if let excercise = excercise {
			excerciseLabel.text = "\(excercise) min"
        }
        if let distance = distance {
            let value = Double(distance) / 1000.0
			distanceLabel.text = "\(String(format: "%.01f", value)) Km"
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
