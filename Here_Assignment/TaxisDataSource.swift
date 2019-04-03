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
        Taxi(currentStation:"Castle", logoImage:"AirportTaxi" ,ETA:60),
        Taxi(currentStation:"Dizingof", logoImage:"JerusalemTaxi",ETA:58),
        Taxi(currentStation:"Habima", logoImage:"MayTaxi",ETA:53),
        Taxi(currentStation:"Kaplan", logoImage:"ZviTaxi",ETA:56),
        Taxi(currentStation:"Gordon", logoImage:"ShekemTaxi",ETA:53),
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
     it could be DB or network and in that way, we does not affect the TaxisListViewController functionality
     
     - parameter completion block : return true if data fetched ok
     */
    func reloadData( completion: (_ result: Bool)->()) {
        
         for index in 0..<taxisStub.count {
            
            let taxiElement = taxisStub[index]
            
            if (taxiElement.ETA != 0){
                let randomInt:Int = Int.random(in: 0..<taxiElement.ETA)
                taxisStub[index].ETA = randomInt
            }
         }
        taxisStub = taxisStub.sorted(by: { $0.ETA < $1.ETA })
        completion(true)
    }


}
