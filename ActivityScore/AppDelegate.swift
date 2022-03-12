//
//  AppDelegate.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 13/3/18.
//  Copyright © 2018 Tobias Ruano. All rights reserved.
//

import UIKit
import GoogleMobileAds
import SwiftyStoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

	// swiftlint:disable:next line_length
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                default:
                    break
                }
            }
        }

		self.window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = getViewControllerToPresent()
		window?.makeKeyAndVisible()

        UITabBar.appearance().tintColor = UIColor(displayP3Red: 245/255, green: 81/255, blue: 95/255, alpha: 1.0)

        let gadMobileAds = GADMobileAds.sharedInstance()
        gadMobileAds.start(completionHandler: nil)
        gadMobileAds.requestConfiguration.testDeviceIdentifiers = ["ca-app-pub-6561467960639972~9751628834"]
        return true
    }

	func getViewControllerToPresent() -> UIViewController {
		if let value = UserDefaults.standard.value(forKey: "OnboardingScreen"),
		   let booleanValue = value as? Bool, booleanValue {
			let storyBoard = UIStoryboard(name: "Main", bundle: nil)
			let tabBarController = storyBoard.instantiateViewController(withIdentifier: "tabBarController")
			return tabBarController
		} else {
			let storyBoard = UIStoryboard(name: "Onboarding", bundle: nil)
			let OnboardingPageViewController = storyBoard.instantiateViewController(withIdentifier: "welcome")
			return OnboardingPageViewController
		}
	}

    func applicationWillResignActive(_ application: UIApplication) { }

    func applicationDidEnterBackground(_ application: UIApplication) { }

    func applicationWillEnterForeground(_ application: UIApplication) { }

    func applicationDidBecomeActive(_ application: UIApplication) { }

    func applicationWillTerminate(_ application: UIApplication) { }

}
