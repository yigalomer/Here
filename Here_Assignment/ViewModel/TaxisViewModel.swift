//
//  TaxisDataSource.swift
//  Here_Assignment
//
//  Created by Yigal Omer on 02/04/2019.
//  Copyright © 2019 Yigal Omer. All rights reserved.
//

import UIKit

protocol TaxisDataSourceDelegate : class {
    
    func didDataWasLoaded(data:[Taxi])
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
            Taxi(currentStation:"Airport Taxis", logoImage:"AirportTaxi" ,ETA:34),
            Taxi(currentStation:"Jerusalem Taxis", logoImage:"JerusalemTaxi",ETA:29),
            Taxi(currentStation:"Ayalon Taxis", logoImage:"AyalonTaxi",ETA:35),
            Taxi(currentStation:"Zvi Taxis", logoImage:"ZviTaxi",ETA:25),
            Taxi(currentStation:"Shekem Taxis", logoImage:"ShekemTaxi",ETA:22),
            Taxi(currentStation:"Yahav Taxis", logoImage:"YahavTaxi",ETA:27),
            Taxi(currentStation:"Nizan Taxis", logoImage:"NizanTaxi",ETA:18),
            Taxi(currentStation:"Rishon Taxis", logoImage:"RishonTaxi",ETA:11),
            Taxi(currentStation:"BeerYaakov Taxis", logoImage:"BeerYaakovTaxi",ETA:32),
            Taxi(currentStation:"Shimshon Taxis", logoImage:"ShimshonTaxi",ETA:15),
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
            if let taxisStub = self.taxisStub {
                self.delegate?.didDataWasLoaded(data:taxisStub)
            }
            
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
