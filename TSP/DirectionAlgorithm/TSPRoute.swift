//
//  TSPRoute.swift
//  TSP
//
//  Created by Bink Wang on 8/11/18.
//  Copyright © 2018 Bink Wang. All rights reserved.
//

import UIKit

class Route
{
    let cities: [TSPPlace]
    
    var _distance: CGFloat?
    var distance: CGFloat {
        if _distance == nil {
            _distance = calculateDistance()
        }
        return _distance ?? 0.0
    }
    
    init(cities: [TSPPlace]) {
        self.cities = cities
    }
    
    private func calculateDistance() -> CGFloat {
        var result: CGFloat = 0.0
        var previousCity: TSPPlace?
        
        cities.forEach { (city) in
            if let previous = previousCity {
                result += previous.distance(to: city)
            }
            previousCity = city
        }
        
        guard let first = cities.first, let last = cities.last else { return result }
        
        return result + first.distance(to: last)
    }
    
    // Probability of being selected from 0 to 1
    func fitness(withTotalDistance totalDistance: CGFloat) -> CGFloat {
        return 1 - (distance/totalDistance)
    }
}
