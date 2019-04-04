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
    let taxisViewModel: TaxisViewModel = TaxisViewModel()
    /// hide/show the cells of the table view. We'll show the cells only after fetching it from the data source
    var isDataLoaded = false
 
    var countReload = 1 // for debug usage only 
    
    // MARK: - View Controller lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taxisViewModel.delegate = self
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
    func didDataWasLoaded() {
        
        print ("didDataWasLoaded \(countReload)")
        countReload += 1
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            
            /// Set the table view transition animation
            var animationOption:UIView.AnimationOptions = .transitionCrossDissolve
            if ( !self.isDataLoaded) { //First time do a flip
                animationOption = .transitionFlipFromLeft
            }
            self.isDataLoaded = true
            
            UIView.transition(with: self.tableView, duration: 1.5, options: animationOption, animations: {self.tableView.reloadData()}, completion: nil)
            
            if ( LoadingIndicatorView.isAnimating()){
                LoadingIndicatorView.hide()
            }
        }
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// Create a new cell with the reuse identifier of our prototype cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "taxiCell") as! TaxiTableViewCell
     
        /// populate the cell with the model values
        cell.taxiLogoImage.image = taxisViewModel.getStationLogo(index:indexPath.row)
        cell.station.text = taxisViewModel.getStationName(index:indexPath.row)
        let taxiETA = taxisViewModel.getTaxiETA(index:indexPath.row)
        cell.ETA.text = (taxiETA > 0) ? "\(taxiETA)m" : Constants.now
        
        /// Return our new cell for display
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /// Do not show the table cell, not untill data was received from the data source
        if(self.isDataLoaded){
            return taxisViewModel.getCount()
        }
        else{
            return 0
        }
    }
    

}


