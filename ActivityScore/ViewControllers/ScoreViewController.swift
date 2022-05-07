//
//  ScoreViewController.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 13/3/18.
//  Copyright © 2018 Tobias Ruano. All rights reserved.
//

import UIKit
import HealthKit
import GoogleMobileAds
import ProgressHUD

class ScoreViewController: UIViewController, GADBannerViewDelegate {

    @IBOutlet weak var adBanner: GADBannerView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var cheeringLable: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!

    let scoreViewModel = ScoreViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        scoreViewModel.delegate = self
        self.navigationItem.title = "Your Daily Score"
		setRightNavigationButton()
		configurePullToRefresh()
    }

    override func viewWillAppear(_ animated: Bool) {
		ProgressHUD.animationType = .multipleCirclePulse
		ProgressHUD.colorAnimation = .systemPink
		ProgressHUD.show()
        labelStyle()
        configureAdBanner()
        healthData()
    }

	func configurePullToRefresh() {
		scrollView.refreshControl = UIRefreshControl()
		scrollView.refreshControl?.addTarget(self, action: #selector(refreshHealthData), for: .valueChanged)
	}

	@objc func refreshHealthData() {
		ProgressHUD.show()
		DispatchQueue.main.async {
			self.scrollView.refreshControl?.endRefreshing()
		}
		healthData()
	}

	func setRightNavigationButton() {
		let buttonImage = UIImage(systemName: "calendar")
		let action = #selector(changeAmountDays(sender:))
		let navigationBarButton = UIBarButtonItem(image: buttonImage,
												  style: .done,
												  target: self,
												  action: action)
		self.navigationItem.rightBarButtonItem = navigationBarButton
	}

	@objc func changeAmountDays(sender: UIBarButtonItem) {
//		let alert = UIAlertController(title: titleString, message: "View Last...", preferredStyle: .actionSheet)
		let alert = UIAlertController()

		if let popoverController = alert.popoverPresentationController {
			popoverController.barButtonItem = sender as UIBarButtonItem
		}

		alert.addAction(UIAlertAction(title: "Last 7 days", style: .default, handler: { (_) in
			ProgressHUD.show()
			self.scoreViewModel.changeDateAmount(newAmount: 7)
		}))
		alert.addAction(UIAlertAction(title: "Last 14 days", style: .default, handler: { (_) in
			ProgressHUD.show()
			self.scoreViewModel.changeDateAmount(newAmount: 14)
		}))
		alert.addAction(UIAlertAction(title: "Last 30 days", style: .default, handler: { (_) in
			ProgressHUD.show()
			self.scoreViewModel.changeDateAmount(newAmount: 30)
		}))
		alert.addAction(UIAlertAction(title: "Last 60 days", style: .default, handler: { (_) in
			ProgressHUD.show()
			self.scoreViewModel.changeDateAmount(newAmount: 60)
		}))
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		self.present(alert, animated: true)
	}

    func healthData() {
        scoreViewModel.authorizeHealthKit { status in
            if status {
                self.retrieveData()
            } else {
                // presentar error de autorizacion
            }
        }
    }

    func retrieveData() {
        scoreViewModel.retrieveHealthData()
    }

    func labelStyle() {
        let shadowColor = UIColor.systemPink
        scoreLabel.layer.shadowColor = shadowColor.cgColor
        scoreLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
		scoreLabel.layer.shadowOpacity = 0.7
        scoreLabel.layer.shadowRadius = 5
    }

    func setScoreText(score: String, description: String) {
		if let score = Int(score) {
			var startNumber = 0
			if let labelText = self.scoreLabel.text, let currentScoreInLabel = Int(labelText) {
				startNumber = currentScoreInLabel
			}
			self.scoreLabel.incrementLabel(from: startNumber, to: score, in: 1.5)
		}
        self.cheeringLable.text = description
    }

    func setCardView() {
        let children = self.children
        for element in children where element is CardViewDataCollectionViewController {
			guard let vc = element as? CardViewDataCollectionViewController else { return }
			vc.weekData = self.scoreViewModel.getFitnessDataInOrder().reversed()
			vc.collectionView.reloadData()
			vc.collectionView.selectItem(at: IndexPath(item: 0, section: 0),
										 animated: true,
										 scrollPosition: .centeredHorizontally)
        }
    }

    func setLineGraph() {
        let children = self.children
        for element in children where element is LineGraphViewController {
			guard let vc = element as? LineGraphViewController else { return }
			vc.data = self.scoreViewModel.getFitnessDataInOrder()
			vc.lineChartUpdate()
        }
    }

    func configureAdBanner() {
        scoreViewModel.checkPurchaseStatus { status in
            switch status {
            case true:
                self.setAdBanner()
                self.adBanner.isHidden = false
            case false:
                self.adBanner.rootViewController = nil
                self.adBanner.isHidden = true
            }
        }
    }

    func setAdBanner() {
        if adBanner.adUnitID == nil {
            adBanner.adUnitID = "ca-app-pub-6561467960639972/8227758207"
            adBanner.rootViewController = self
            adBanner.delegate = self
            adBanner.load(GADRequest())
        }
    }
}

extension ScoreViewController: ScoreViewModelProtocol {
    func setView(scoreText: String, descriptionText: String) {
		ProgressHUD.dismiss()
		setLineGraph()
        setScoreText(score: scoreText, description: descriptionText)
        setCardView()
    }
}
