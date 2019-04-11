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


class SettingsViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    var flag: Bool = false
    
    @IBOutlet weak var healthLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Settings"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        flag = UserDefaults.standard.bool(forKey: "Flag")
        print("\(flag)")
        
        if flag == true {
            healthLabel.text = "Enabled"
        }else {
            healthLabel.text = "Disabled"
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 2 && indexPath.row == 2 {
            share()
        }else if indexPath.section == 2 && indexPath.row == 1 {
            //let appDelegate = AppDelegate()
            //appDelegate.requestReview()
            rate()
        }else if indexPath.section == 2 && indexPath.row == 0 {
            support()
        }
    }
    
    func rate() {
        guard let url = URL(string: "itms-apps://itunes.apple.com/app/idYOUR_APP_ID") else {
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func share() {
        let activityVC = UIActivityViewController(activityItems: ["hola"], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func support() {
        if MFMailComposeViewController.canSendMail() {
            let emailTitle = "[ACTIVITY SCORE] Feedback"
            let toRecipents = ["ruano.t10@gmail.com"]
            let mc: MFMailComposeViewController = MFMailComposeViewController()
            mc.mailComposeDelegate = self
            mc.setSubject(emailTitle)
            mc.setToRecipients(toRecipents)
            
            self.present(mc, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Couldn't Access Mail App", message: "Please report this error", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller:MFMailComposeViewController, didFinishWith result:MFMailComposeResult, error:Error?) {
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
        controller.dismiss(animated: true, completion: nil)
    }
    
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
