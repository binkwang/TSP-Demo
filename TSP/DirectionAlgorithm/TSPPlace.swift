//
//  TSPPlace.swift
//  TSP
//
//  Created by Bink Wang on 8/11/18.
//  Copyright © 2018 Bink Wang. All rights reserved.
//

import UIKit
import CoreLocation

struct TSPPlace
{
    //    static func ==(lhs: City, rhs: City) -> Bool {
    //        return lhs.location == rhs.location
    //    }
    
    let location: CGPoint
    let address: String?
    let coordinate: CLLocationCoordinate2D?
    
    func distance(to: TSPPlace) -> CGFloat {
        return sqrt(pow(to.location.x - self.location.x, 2) + pow(to.location.y - self.location.y, 2))
    }
    
    func isSamePlace(_ aPlace: TSPPlace) -> Bool {
        let accuracy: Int = 3
        
        var isSame: Bool = false
        if self.coordinate?.latitude.roundTo(places: accuracy) == aPlace.coordinate?.latitude.roundTo(places: accuracy)
            && self.coordinate?.longitude.roundTo(places: accuracy) == aPlace.coordinate?.longitude.roundTo(places: accuracy) {
            isSame = true
        }
        return isSame
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
