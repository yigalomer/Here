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

    // MARK: - View lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tableView.tableHeaderView = 'your_value' ;
        /// Start a timer which will invoke refreshTable() after 5 seconds and will be repeted
        self.refreshTimer = Timer.scheduledTimer(timeInterval:TimeInterval(Constants.refreshRateInSeconds),
                                                 target: self,
                                                 selector: #selector(refreshTable),
                                                 userInfo: nil,
                                                 repeats: true)
    }
    
//    
//    private func tableView (tableView:UITableView,  viewForHeaderInSection section:Int)->UIView
//    {
//        
//        var title = tableView.titleForHeaderInSection[section] as String
//        if (title == "") {
//            return UIView(frame:CGRectZero);
//        }
//        var headerView:UIView! = UIView (frame:CGRectMake(0, 0, self.tableView.frame.size.width, 20.0));
//        headerView.backgroundColor = self.view.backgroundColor;
//        
//        return headerView;
//    }

//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Section \(section)"
//    }
    
//    private func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let vw = UIView()
//        vw.backgroundColor = UIColor.gray
//
//        return vw
//    }

    // MARK: - refresh data
    /**
     Reload the data from the data source. if it went OK, we'll get a CB with result=true
     we can then reload the data into our table view
     */
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
     
        // get the taxi model from our data source for an index
        let taxi:Taxi = taxisDataSource[indexPath.row]
        
        // populate the cell with the model values
        cell.taxiLogoImage.image = UIImage(named: taxi.logoImage)
        cell.station.text = taxi.currentStation
        cell.ETA.text = "\(taxi.ETA)m"
        
        // Return our new cell for display
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taxisDataSource.getCount()
    }
    
    // perform the deinitialization
    deinit {
        refreshTimer.invalidate()
    }

}

