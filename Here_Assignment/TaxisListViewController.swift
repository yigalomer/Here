//
//  ViewController.swift
//  Here_Assignment
//
//  Created by Yigal Omer on 02/04/2019.
//  Copyright © 2019 Yigal Omer. All rights reserved.
//

import UIKit

class TaxisListViewController: UIViewController,UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    let taxisDataSource: TaxisDataSource = TaxisDataSource()
    var refreshTimer: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshTimer = Timer.scheduledTimer(timeInterval: TimeInterval(Constants.refreshRateInMinutes),
                                                 target: self,
                                                 selector: #selector(refreshTable),
                                                 userInfo: nil,
                                                 repeats: true)
    }
   

    @objc func refreshTable() {
        taxisDataSource.reloadData() { (result) -> () in
            if (result) {
                // Reload the table view after data source was reloaded
                tableView.reloadData()
            }
        }
    }
    
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create a new cell with the reuse identifier of our prototype cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "taxiCell") as! TaxiTableViewCell
     
        // get the taxi model from our data source according to the index
        let taxi:Taxi = taxisDataSource[indexPath.row]
        
        // fill the cell with the model values
        cell.taxiLogoImage.image = UIImage(named: taxi.logoImage)
        cell.station.text = taxi.currentStation
        cell.ETA.text = "\(taxi.ETA)m"
        
        // Return our new cell for display
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taxisDataSource.getCount()
    }
    

    


    //refreshTimer.invalidate() TODO TODO
  
}

