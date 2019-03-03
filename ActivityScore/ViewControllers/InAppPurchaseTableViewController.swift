//
//  InAppPurchaseViewController.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 03/03/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit

class InAppPurchaseTableViewController: UITableViewController {
    var buttonIsEnabled = true
    let inAppPurchaseKey = "purchase"
    
    @IBOutlet weak var fullVersionButton: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let value = UserDefaults.standard.value(forKey: inAppPurchaseKey) as? Bool {
            if value == true {
                buttonIsEnabled = value
                lockCell()
            }
        }
    }
    
    
    // MARK: - table view Data Source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            //Buying the full app
            lockCell()
            
            //Taptic feedback
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
            tableView.deselectRow(at: indexPath, animated: true)
        }else if indexPath.section == 1 && indexPath.row == 0 {
            let result = restorePurchase()
            if result == true {
                
                lockCell()
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func lockCell() {
        fullVersionButton.accessoryType = .checkmark
        fullVersionButton.detailTextLabel?.text = ""
        
        buttonIsEnabled = false
        UserDefaults.standard.set(!buttonIsEnabled, forKey: inAppPurchaseKey)
        fullVersionButton.isUserInteractionEnabled = false
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 0 && indexPath.row == 0 {
            if buttonIsEnabled == false {
                return nil
            }
        }
        return indexPath
    }
    
    func restorePurchase() -> Bool {
        if buttonIsEnabled == true {
            restoreAlert(title: "Purchase Restored!", message: "Your purchase has been restored", buttonText: "Great!")
            //Taptic feedback
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
            return true
        }else {
            restoreAlert(title: "Opps!", message: "It seems there's nothing to restore", buttonText: "Ok")
            //Taptic feedback
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            
            return false
        }
    }
    
    func restoreAlert (title: String, message: String, buttonText: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: buttonText, style: .default, handler: { alert -> Void in
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
}
