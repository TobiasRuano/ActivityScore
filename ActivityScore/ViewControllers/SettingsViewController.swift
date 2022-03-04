//
//  SettingsViewController.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 13/3/18.
//  Copyright © 2018 Tobias Ruano. All rights reserved.
//

import UIKit
import StoreKit
import MessageUI
import SafariServices

class SettingsViewController: UITableViewController,
							  MFMailComposeViewControllerDelegate,
							  SFSafariViewControllerDelegate {

	var flag: Bool = false
    @IBOutlet weak var healthLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Settings"
    }

    override func viewWillAppear(_ animated: Bool) {
        flag = UserDefaults.standard.bool(forKey: "Flag")
        if flag == true {
            healthLabel.text = "Enabled"
        } else {
            healthLabel.text = "Disabled"
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.section == 3 && indexPath.row == 3 {
            share()
        } else if indexPath.section == 3 && indexPath.row == 1 {
            rate()
        } else if indexPath.section == 3 && indexPath.row == 0 {
            support()
        } else if indexPath.section == 3 && indexPath.row == 2 {
            openSafariVC(self)
        } else if indexPath.section == 3 && indexPath.row == 4 {
            openAboutVC()
        }
    }

    func rate() {
        guard let url = URL(string: "itms-apps://itunes.apple.com/app/id1459688285?mt=8&action=write-review") else {
			return
		}
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:])
        } else {
            UIApplication.shared.openURL(url)
        }
    }

    func share() {
        let activityVC = UIActivityViewController(activityItems: ["https://itunes.apple.com/app/id1459688285"],
												  applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true)
    }

    func support() {
        if MFMailComposeViewController.canSendMail() {
            let emailTitle = "[ACTIVITY SCORE] Feedback"
            let toRecipents = ["ruano.t10@gmail.com"]
            let mc: MFMailComposeViewController = MFMailComposeViewController()
            mc.mailComposeDelegate = self
            mc.setSubject(emailTitle)
            mc.setToRecipients(toRecipents)
            
            self.present(mc, animated: true)
        } else {
            let alert = UIAlertController(title: "Couldn't Access Mail App",
										  message: "Please report this error",
										  preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true)
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("Mail cancelled")
        case .saved:
            print("Mail saved")
        case .sent:
            print("Mail sent")
        case .failed:
            print("Mail sent failure: \(String(describing: error?.localizedDescription))")
        @unknown default:
            fatalError()
        }
        controller.dismiss(animated: true)
    }

    func openSafariVC(_ sender: Any) {
        let url = URL(string: "https://activityscore.tobiasruano.com/privacy")
        let safari = SFSafariViewController(url: url!)
        self.present(safari, animated: true)
        safari.delegate = self
    }

    func safariVCDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true)
    }

    func openAboutVC() {
        let aboutVC = AboutViewController(nibName: "AboutViewController", bundle: nil)
        navigationController?.pushViewController(aboutVC, animated: true)
    }
}
