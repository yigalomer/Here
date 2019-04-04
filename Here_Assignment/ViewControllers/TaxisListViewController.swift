//
//  ViewController.swift
//  Here_Assignment
//
//  Created by Yigal Omer on 02/04/2019.
//  Copyright © 2019 Yigal Omer. All rights reserved.
//

import UIKit

class TaxisListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,  TaxisDataSourceDelegate{
  
    @IBOutlet weak var tableView: UITableView!
    let taxisDataSource: TaxisViewModel = TaxisViewModel()
    /// hide/show the cells of the table view. We'll show the cells only after fetching it from the data source
    var isDataLoaded = false
    /// Local data source for the table view. Will be received from the data source
    var taxisData : [Taxi]?
    var countReload = 1 // for debug usage only 
    
    // MARK: - View Controller lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taxisDataSource.delegate = self
        /// Show a loading indicator
        LoadingIndicatorView.show(tableView,loadingText: Constants.loadingTitle)
        self.tableView.rowHeight = 100.0
    }
    
    // MARK: - TaxisDataSourceDelegate
    /**
     TaxisDataSourceDelegate method is called when a new data has arrived
     in which, we update our table view data source (self.taxisData) and reload the table data
     - parameter array of Taxis : that was fetched by the View Model
     */
    func didDataWasLoaded(data:[Taxi]) {
        
        print ("didDataWasLoaded \(countReload)")
        countReload += 1
        /// save the data that was received from the data source locally. It will be used as the data for the table view
        self.taxisData = data
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            
            /// Set the table view transition animation
            var animationOption:UIView.AnimationOptions = .transitionCrossDissolve
            if ( !self.isDataLoaded) { //First time do a flip
                animationOption = .transitionFlipFromLeft
            }
            self.isDataLoaded = true
            
            UIView.transition(with: self.tableView, duration: 1.5, options: animationOption, animations: {self.self.tableView.reloadData()}, completion: nil)
            
            if ( LoadingIndicatorView.isAnimating()){
                LoadingIndicatorView.hide()
            }
        }
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// Create a new cell with the reuse identifier of our prototype cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "taxiCell") as! TaxiTableViewCell
     
        /// get the taxi model from our data for a specific index
        let taxi:Taxi? = (self.taxisData?[indexPath.row])
        
        /// populate the cell with the model values
        cell.taxiLogoImage.image = UIImage(named: (taxi?.logoImage ?? Constants.defaultLogoName))
        cell.station.text = taxi?.currentStation
        cell.ETA.text = ((taxi?.ETA)! > 0) ? "\(taxi!.ETA)m" : Constants.now

        /// Return our new cell for display
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /// Do not show the table cell, not untill data was received from the data source
        if(self.isDataLoaded){
            return taxisDataSource.getCount()
        }
        else{
            return 0
        }
    }
    

}


