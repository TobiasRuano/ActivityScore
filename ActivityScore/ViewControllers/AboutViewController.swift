//
//  AboutViewController.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 25/02/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "About"
        navigationItem.largeTitleDisplayMode = .never
        scrollView.alwaysBounceVertical = true
        styleIconView()
        configureTableView()
    }
    
    func styleIconView() {
        iconImageView.image = UIImage(named: "onboardingLogo")
        iconImageView.layer.cornerRadius = 25
        iconImageView.layer.shadowColor = UIColor.gray.cgColor
        iconImageView.layer.shadowRadius = 25
        iconImageView.layer.shadowOpacity = 10
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "AboutTableViewCell", bundle: nil), forCellReuseIdentifier: AboutTableViewCell.cellID)
    }
}

extension AboutViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AboutTableViewCell.cellID) as! AboutTableViewCell
        if indexPath.row == 0 {
            let versionNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            cell.cellPrimaryText.text = "Version: "
            cell.cellSecondaryText.text = versionNumber
        } else {
            let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
            cell.cellPrimaryText.text = "Build: "
            cell.cellSecondaryText.text = buildNumber
        }
        return cell
    }
    
}
