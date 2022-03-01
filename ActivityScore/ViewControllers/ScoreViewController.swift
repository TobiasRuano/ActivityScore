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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ProgressHUD.show()
        labelStyle()
        configureAdBanner()
        healthData()
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
    
    func checkOnboardingStatus() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        var vc: UIViewController
        if (UserDefaults.standard.value(forKey: "OnboardingScreen") as? Bool) == nil  {
            vc = storyBoard.instantiateViewController(withIdentifier: "OnboardingRoot")
            present(vc, animated: true, completion: nil)
        }
    }
    
    func labelStyle() {
        let shadowColor = UIColor.white
        scoreLabel.layer.shadowColor = shadowColor.cgColor
        scoreLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        scoreLabel.layer.shadowOpacity = 1
        scoreLabel.layer.shadowRadius = 2
    }
    
    func setScoreText(score: String, description: String) {
        self.scoreLabel.text = score
        self.cheeringLable.text = description
    }
    
    func setCardView() {
        let children = self.children
        for element in children {
            if element is CardViewDataCollectionViewController {
                let vc = element as! CardViewDataCollectionViewController
                vc.weekData = self.scoreViewModel.getFitnessDataInOrder().reversed()
                vc.collectionView.reloadData()
            }
        }
    }
    
    func setLineGraph() {
        let children = self.children
        for element in children {
            if element is LineGraphViewController {
                let vc = element as! LineGraphViewController
                vc.data = self.scoreViewModel.getFitnessDataInOrder()
                vc.lineChartUpdate()
            }
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
        let request = GADRequest()
        request.testDevices = [(kGADSimulatorID as! String)]
        request.testDevices = [ "21df7f3d09709224a09480ff10d324aa" ]
        adBanner.adUnitID = "ca-app-pub-6561467960639972/8227758207"
        adBanner.rootViewController = self
        adBanner.delegate = self
        adBanner.load(request)
    }
    
}

extension ScoreViewController: ScoreViewModelProtocol {
    func setView(scoreText: String, descriptionText: String) {
        setLineGraph()
        setScoreText(score: scoreText, description: descriptionText)
        setCardView()
        ProgressHUD.dismiss()
    }
}

