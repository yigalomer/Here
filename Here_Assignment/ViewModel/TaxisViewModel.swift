//
//  TaxisDataSource.swift
//  Here_Assignment
//
//  Created by Yigal Omer on 02/04/2019.
//  Copyright © 2019 Yigal Omer. All rights reserved.
//

import UIKit

protocol TaxisDataSourceDelegate : class {
    
    func didDataWasLoaded()
}
/**
 The class functions as a ViewModel. Decoupled from the vc, it contains the business logic related to the UI.
 Class responsible also for getting the taxis data (could be a DB or network)
 We take that responsibility from the VC which does not concern with this business logic.
 
 */
class TaxisViewModel: NSObject {
    
    weak var delegate: TaxisDataSourceDelegate?
    
    var refreshTimer: Timer?
    /// Stub data
    var taxisStub:[Taxi]?
    
    // MARK: - init
    override init() {
        super.init()
        
        self.taxisStub = [
            Taxi(stationName:"Airport Taxis", stationLogoImage:"AirportTaxi" ,ETA:34),
            Taxi(stationName:"Jerusalem Taxis", stationLogoImage:"JerusalemTaxi",ETA:29),
            Taxi(stationName:"Ayalon Taxis", stationLogoImage:"AyalonTaxi",ETA:35),
            Taxi(stationName:"Zvi Taxis", stationLogoImage:"ZviTaxi",ETA:25),
            Taxi(stationName:"Shekem Taxis", stationLogoImage:"ShekemTaxi",ETA:22),
            Taxi(stationName:"Yahav Taxis", stationLogoImage:"YahavTaxi",ETA:27),
            Taxi(stationName:"Nizan Taxis", stationLogoImage:"NizanTaxi",ETA:18),
            Taxi(stationName:"Rishon Taxis", stationLogoImage:"RishonTaxi",ETA:11),
            Taxi(stationName:"BeerYaakov Taxis", stationLogoImage:"BeerYaakovTaxi",ETA:32),
            Taxi(stationName:"Shimshon Taxis", stationLogoImage:"ShimshonTaxi",ETA:15),
            ]
        
        /// Start a timer which will invoke reloadData() after 5 seconds and will be repeated every 5 seconds
        self.refreshTimer = Timer.scheduledTimer(timeInterval:TimeInterval(Constants.refreshRateInSeconds),
                                                 target: self,
                                                 selector: #selector(reloadData),
                                                 userInfo: nil,
                                                 repeats: true)
    }
    
  
    
    // MARK: - Reload data
    /**
     Reload the data. for the assignment, it just gets if from the local array and changing the ETA randomly.
     Realoading the data could be DB or network which are heavy tasks, thus better doing that on a background task.
     */
    @objc func reloadData() {
        
        DispatchQueue.global(qos: .default).async { [weak self] in
            guard let self = self else {
                return
            }
            if let taxisStub = self.taxisStub {
                
                for index in 0..<taxisStub.count {
                    
                    let taxiElement = taxisStub[index]
                    if ((taxiElement.ETA) >= 0){
                        let randomInt:Int = Int.random(in: 1..<8)
                        let newETA = taxiElement.ETA-randomInt
                        self.taxisStub![index].ETA = newETA>=0 ? newETA: 0
                    }
                }
            }
            /// Sort the array by ETA
            self.taxisStub = (self.taxisStub?.sorted(by: { $0.ETA < $1.ETA }))
            
            /// Notifies the VC that new data was received
            self.delegate?.didDataWasLoaded()

            
            /// If all Taxi item's ETA reached 0, there's no point to keep on with the timer
            if (self.isAllTaxiIemsETAAreZero()){
                self.refreshTimer?.invalidate()
            }
        }
    }
 
    /**
      - returns: true if all ETA are 0
     */
    func isAllTaxiIemsETAAreZero() -> Bool {
        
        if let taxisStub = self.taxisStub {
            /// Get an Int Array of all ETAs
            let flatETA:[Int] = taxisStub.compactMap({ $0.ETA })
            /// Sum up all ETAs
            let sumETA:Int = flatETA.reduce(0) { (result, next) -> Int in
                return result + next
            }
            return (sumETA == 0)
        }
        return false
    }
    
    /**
     Subscript that enables accessing our class with [], just like an array
     - returns: a Taxi item
     */
    subscript(index: Int) -> Taxi {
        return taxisStub![index]
    }

    func getStationName(index: Int) -> String {
        return taxisStub![index].stationName
    }
    
    func getStationLogo(index: Int) -> UIImage {
        let  taxiStationlogoImageName : String = taxisStub![index].stationLogoImage
        return  UIImage(named:taxiStationlogoImageName)!
     }
    func getTaxiETA(index: Int) -> Int {
        return taxisStub![index].ETA
    }
    
    /**
     - returns: a Taxis count
     */
    func getCount() -> Int {
        return taxisStub?.count ?? 0
    }
    
    /// perform the deinitialization
    deinit {
        refreshTimer?.invalidate()
    }
    
}
