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


class InAppPurchaseTableViewController: UITableViewController {
    var buttonIsEnabled = true
    let inAppPurchaseKey = "purchase"
    
    let bundleID = "com.Tobiasruano.ActivityScore"
    
    let removeAdID = "RemoveAds"
    var sharedSecret = "d83163c37d8648de8d98be311b928361"
    
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
    
    func alert (title: String, message: String, buttonText: String) {
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
                        
                        TapticEffectsService.performFeedbackNotification(type: .success)
                        
                        print("Purchase Success: \(product.productId)")
                    case .error(let error):
                        switch error.code {
                        case .unknown:
                            print("Unknown error. Please contact support")
                            self.alert(title: "Unknown error", message: "Please contact support", buttonText: "Ok")
                        case .clientInvalid: print("Not allowed to make the payment")
                        case .paymentCancelled: break
                        case .paymentInvalid:
                            print("The purchase identifier was invalid")
                            self.alert(title: "The purchase identifier was invalid", message: "Please contact the developer", buttonText: "Ok")
                        case .paymentNotAllowed: print("The device is not allowed to make the payment")
                        case .storeProductNotAvailable:
                            print("The product is not available in the current storefront")
                            self.alert(title: "Product not available", message: "The product is not available in the current storefront", buttonText: "Ok")
                        case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                        case .cloudServiceNetworkConnectionFailed:
                            print("Could not connect to the network")
                            self.alert(title: "Could not connect to the network", message: "Please try again later", buttonText: "Ok")
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
                self.alert(title: "Opps!", message: "It seems there's a problem restoring your purchase. Please contact the developer", buttonText: "Ok")
                TapticEffectsService.performFeedbackNotification(type: .error)
            }
            else if results.restoredPurchases.count > 0 {
                print("Restore Success: \(results.restoredPurchases)")
                self.alert(title: "Purchase Restored!", message: "Your purchase has been restored", buttonText: "Great!")
                TapticEffectsService.performFeedbackNotification(type: .success)
                self.lockCell()
            }
            else {
                print("Nothing to Restore")
                self.alert(title: "Opps!", message: "It seems there's nothing to restore", buttonText: "Ok")
                TapticEffectsService.performFeedbackNotification(type: .error)
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
                self.alert(title: "There is a problem validating your inApp Purchase", message: "Please verify that you have an active internet connection. If the problem persist, contact the developer", buttonText: "Ok")
            }
        }
        NetworkActivityIndicationManager.networkOperationFinished()
    }
}
