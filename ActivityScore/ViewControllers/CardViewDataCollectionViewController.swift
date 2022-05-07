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
	// Velocity is measured in points per millisecond.
	private var snapToMostVisibleColumnVelocityThreshold: CGFloat { return 0.3 }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        let nibName = UINib(nibName: "CardViewDataCollectionViewCell", bundle: nil)
        self.collectionView.register(nibName, forCellWithReuseIdentifier: reuseIdentifier)
    }
  
	// MARK: ScrollViewDelegate
	override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		let layout = collectionViewLayout as! UICollectionViewFlowLayout
		let bounds = scrollView.bounds
		let xTarget = targetContentOffset.pointee.x

		// This is the max contentOffset.x to allow. With this as contentOffset.x, the right edge of the last column of cells is at the right edge of the collection view's frame.
		let xMax = scrollView.contentSize.width - scrollView.bounds.width

		if abs(velocity.x) <= snapToMostVisibleColumnVelocityThreshold {
			let xCenter = scrollView.bounds.midX
			let poses = layout.layoutAttributesForElements(in: bounds) ?? []
			// Find the column whose center is closest to the collection view's visible rect's center.
			let x = poses.min(by: { abs($0.center.x - xCenter) < abs($1.center.x - xCenter) })?.frame.origin.x ?? 0
			targetContentOffset.pointee.x = x
		} else if velocity.x > 0 {
			let poses = layout.layoutAttributesForElements(in: CGRect(x: xTarget, y: 0, width: bounds.size.width, height: bounds.size.height)) ?? []
			// Find the leftmost column beyond the current position.
			let xCurrent = scrollView.contentOffset.x
			let x = poses.filter({ $0.frame.origin.x > xCurrent}).min(by: { $0.center.x < $1.center.x })?.frame.origin.x ?? xMax
			targetContentOffset.pointee.x = min(x, xMax)
		} else {
			let poses = layout.layoutAttributesForElements(in: CGRect(x: xTarget - bounds.size.width, y: 0, width: bounds.size.width, height: bounds.size.height)) ?? []
			// Find the rightmost column.
			let x = poses.max(by: { $0.center.x < $1.center.x })?.frame.origin.x ?? 0
			targetContentOffset.pointee.x = max(x, 0)
		}
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
		let value = collectionView.frame.height
		let width = collectionView.frame.width
		return CGSize(width: width, height: value)
    }
}
