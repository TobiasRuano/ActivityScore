//
//  CardViewDataCollectionViewController.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 24/02/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import UIKit

// swiftlint:disable force_cast line_length
class CardViewDataCollectionViewController: UICollectionViewController {

    private let reuseIdentifier = "CardViewDataCollectionViewCell"

    var weekData: [Dictionary<Date, DailyData>.Element]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        let nibName = UINib(nibName: "CardViewDataCollectionViewCell", bundle: nil)
        self.collectionView.register(nibName, forCellWithReuseIdentifier: reuseIdentifier)
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let userData = weekData {
            return userData.count
        } else {
            return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
													  for: indexPath) as! CardViewDataCollectionViewCell
        if let weekData = weekData {
            let value = weekData[indexPath.row].value
            cell.configureCell(steps: value.steps,
							   calories: value.calories,
							   excercise: value.exercise,
							   distance: value.distance,
							   date: weekData[indexPath.row].key)
        }
        return cell
    }
}

extension CardViewDataCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let value = collectionView.frame.height - 30
		return CGSize(width: value, height: value)
    }
}
