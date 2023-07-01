//
//  AboutViewController.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 25/02/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    let descriptionString: String = "Designed and Developed by Tobias Ruano. With ❤️ from Buenos Aires, Argentina."
    let myNameString: String = "Tobias Ruano"

    @IBOutlet weak var descriptionLabel: UILabel!
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
        configDescriptionText()
    }

    private func styleIconView() {
        iconImageView.image = UIImage(named: "onboardingLogo")
        iconImageView.layer.cornerRadius = 25
        iconImageView.layer.shadowColor = UIColor.gray.cgColor
        iconImageView.layer.shadowRadius = 25
        iconImageView.layer.shadowOpacity = 10
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "AboutTableViewCell",
								 bundle: nil),
						   forCellReuseIdentifier: AboutTableViewCell.cellID)
    }

    private func configDescriptionText() {
        let mainAttributes = [NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel,
                               NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .subheadline)]
        let attributedString = NSMutableAttributedString(string: descriptionString, attributes: mainAttributes)

        let range = (descriptionString as NSString).range(of: myNameString)
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.link,
                                        NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue],
                                       range: range)

        descriptionLabel.attributedText = attributedString

        let gesture = UITapGestureRecognizer(target: self, action: #selector(descriptionLabelTapped))
        descriptionLabel.isUserInteractionEnabled = true
        descriptionLabel.addGestureRecognizer(gesture)
    }

    @objc private func descriptionLabelTapped(sender: UITapGestureRecognizer) {
        guard let url = URL(string: "http://www.tobiasruano.com") else { return }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}

extension AboutViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		// swiftlint:disable:next force_cast
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
