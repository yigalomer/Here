//
//  TaxisDataSource.swift
//  Here_Assignment
//
//  Created by Yigal Omer on 02/04/2019.
//  Copyright © 2019 Yigal Omer. All rights reserved.
//

import UIKit

/**
 A class responsiblre for getting the taxis data (could be from a DB or network)
 */
class TaxisDataSource {
    
    /// Stub data
    var taxisStub = [
        Taxi(currentStation:"Castle", logoImage:"AirportTaxi" ,ETA:5),
        Taxi(currentStation:"Shekem", logoImage:"JerusalemTaxi",ETA:6),
        Taxi(currentStation:"Habima", logoImage:"MayTaxi",ETA:7),
    ]

    
    func getTaxi(_ index:Int) -> Taxi{
        return taxisStub[index]
    }
    
    /**
     Subscript that enables accessing our class with [], just like an array
     */
    subscript(index: Int) -> Taxi {
        return taxisStub[index]
    }
    
    func getCount() -> Int {
        return taxisStub.count
    }
    
    /**
     Reload the data - for the assigment, it's just get if from the local array
     and changing the ETA
     it could be DB or network and that way does not affect the TaxisListViewController functionality
     
     - parameter completion block : return true if data fetched ok
     */
    func reloadData( completion: (_ result: Bool)->()) {
        var randomInt = Int.random(in: 0..<30)
        taxisStub[0].ETA = randomInt
  
        randomInt = Int.random(in: 0..<30)
        taxisStub[1].ETA = randomInt

        randomInt = Int.random(in: 0..<30)
        taxisStub[2].ETA = randomInt
        
        completion(true)
    }
    
//    func getTaxis() -> [Taxi]? {
//        return taxisStub
//    }

}
