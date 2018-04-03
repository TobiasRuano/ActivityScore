//
//  InAppTableViewController.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 3/4/18.
//  Copyright © 2018 Tobias Ruano. All rights reserved.
//

import UIKit

class InAppTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationController?.navigationBar.prefersLargeTitles = false
        title = "In App Purchase"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 && indexPath.row == 0 {
            print("Buy full app")
            noAds()
        }else if indexPath.section == 1 && indexPath.row == 0 {
            print("Restore Purchase")
            restorePurchase()
        }
    }
    //TODO: Complete
    func noAds(){
        
    }
    //TODO: Complete
    func restorePurchase(){
        
    }

}
