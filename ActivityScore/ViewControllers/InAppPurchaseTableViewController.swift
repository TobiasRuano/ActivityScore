//
//  InAppPurchaseViewController.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 03/03/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import StoreKit

var sharedSecret = "d83163c37d8648de8d98be311b928361"

class InAppPurchaseTableViewController: UITableViewController {
    var buttonIsEnabled = true
    let inAppPurchaseKey = "purchase"
    
    let bundleID = "com.Tobiasruano.ActivityScore"
    
    let removeAdID = "RemoveAds"
    
    @IBOutlet weak var fullVersionButton: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getInfo()
        verifyRecipt()
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
            purchase()
            
            //Taptic feedback
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
            tableView.deselectRow(at: indexPath, animated: true)
        }else if indexPath.section == 1 && indexPath.row == 0 {
            restorePurchase()
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
    
//    func restorePurchase() -> Bool {
//
//        if buttonIsEnabled == true {
//            restoreAlert(title: "Purchase Restored!", message: "Your purchase has been restored", buttonText: "Great!")
//            //Taptic feedback
//            let generator = UINotificationFeedbackGenerator()
//            generator.notificationOccurred(.success)
//
//            return true
//        }else {
//            restoreAlert(title: "Opps!", message: "It seems there's nothing to restore", buttonText: "Ok")
//            //Taptic feedback
//            let generator = UINotificationFeedbackGenerator()
//            generator.notificationOccurred(.error)
//
//            return false
//        }
//    }
    
    func restoreAlert (title: String, message: String, buttonText: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: buttonText, style: .default, handler: { alert -> Void in
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func getInfo() {
        NetworkActivityIndicationManager.networkOperationStarted()
        
        SwiftyStoreKit.retrieveProductsInfo([bundleID + "." + removeAdID], completion: {
            result in
            NetworkActivityIndicationManager.networkOperationFinished()
            
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!
                print("Product: \(product.localizedDescription), price: \(priceString)")
            }
            else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            }
            else {
                print("Error: \(String(describing: result.error))")
            }
        })
    }
    
    func purchase() {
        NetworkActivityIndicationManager.networkOperationStarted()
        
        SwiftyStoreKit.retrieveProductsInfo([bundleID + "." + removeAdID]) { result in
            if let product = result.retrievedProducts.first {
                SwiftyStoreKit.purchaseProduct(product, quantity: 1, atomically: true) { result in
                    switch result {
                    case .success(let product):
                        // fetch content from your server, then:
                        if product.needsFinishTransaction {
                            SwiftyStoreKit.finishTransaction(product.transaction)
                        }
                        self.lockCell()
                        print("Purchase Success: \(product.productId)")
                    case .error(let error):
                        switch error.code {
                        case .unknown: print("Unknown error. Please contact support")
                        case .clientInvalid: print("Not allowed to make the payment")
                        case .paymentCancelled: break
                        case .paymentInvalid: print("The purchase identifier was invalid")
                        case .paymentNotAllowed: print("The device is not allowed to make the payment")
                        case .storeProductNotAvailable: print("The product is not available in the current storefront")
                        case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                        case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                        case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                        default: print((error as NSError).localizedDescription)
                        }
                    }
                }
            }
            NetworkActivityIndicationManager.networkOperationFinished()
        }
    }
    
    func restorePurchase() {
        NetworkActivityIndicationManager.networkOperationStarted()
        
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
                self.restoreAlert(title: "Opps!", message: "It seems there's a problem restoring your purchase. Please contact the developer", buttonText: "Ok")
                //Taptic feedback
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)
            }
            else if results.restoredPurchases.count > 0 {
                print("Restore Success: \(results.restoredPurchases)")
                self.restoreAlert(title: "Purchase Restored!", message: "Your purchase has been restored", buttonText: "Great!")
                //Taptic feedback
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
                self.lockCell()
            }
            else {
                print("Nothing to Restore")
                self.restoreAlert(title: "Opps!", message: "It seems there's nothing to restore", buttonText: "Ok")
                //Taptic feedback
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)
            }
            NetworkActivityIndicationManager.networkOperationFinished()
        }
    }
    
    func verifyRecipt() {
        NetworkActivityIndicationManager.networkOperationStarted()
        
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: sharedSecret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                let productId = "\(self.bundleID).\(self.removeAdID)"
                // Verify the purchase of Consumable or NonConsumable
                let purchaseResult = SwiftyStoreKit.verifyPurchase(
                    productId: productId,
                    inReceipt: receipt)
                
                switch purchaseResult {
                case .purchased(let receiptItem):
                    print("\(productId) is purchased: \(receiptItem)")
                case .notPurchased:
                    print("The user has never purchased \(productId)")
                }
            case .error(let error):
                print("Receipt verification failed: \(error)")
            }
        }
        NetworkActivityIndicationManager.networkOperationFinished()
    }
}
