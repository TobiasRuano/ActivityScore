//
//  SecondViewController.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 13/3/18.
//  Copyright © 2018 Tobias Ruano. All rights reserved.
//

import UIKit
import StoreKit
import MessageUI


class SettingsViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    var flag = UserDefaults.standard.bool(forKey: "Flag")
    
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
        }else if flag == false {
            healthLabel.text = "Disabled"
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        print(indexPath.section)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 && indexPath.row == 4 {
            share()
        }else if indexPath.section == 1 && indexPath.row == 3 {
            let appDelegate = AppDelegate()
            appDelegate.requestReview()
        }else if indexPath.section == 1 && indexPath.row == 2 {
            support()
        }
    }
    
    func share() {
        let activityVC = UIActivityViewController(activityItems: ["hola"], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func support() {
        if MFMailComposeViewController.canSendMail() {
            let emailTitle = "Feedback"
            let toRecipents = ["ruano.t10@gmail.com"]
            let mc: MFMailComposeViewController = MFMailComposeViewController()
            mc.mailComposeDelegate = self
            mc.setSubject(emailTitle)
            mc.setToRecipients(toRecipents)
            
            self.present(mc, animated: true, completion: nil)
        } else {
            // show failure alert
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
            print("Mail sent failure: \(error?.localizedDescription)")
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
}

