//
//  TSPGeneticAlgorithm.swift
//  TSP
//
//  Created by Bink Wang on 8/11/18.
//  Copyright © 2018 Bink Wang. All rights reserved.
//

import UIKit

class GeneticAlgorithm
{
    var populationSize = 500
    let mutationProbability = 0.015
    
    let cities: [TSPPlace]
    var onNewGeneration: ((Route, Int) -> ())?
    
    private var population: [Route] = []
    
    init(withCities: [TSPPlace]) {
        self.cities = withCities
        self.population = self.randomPopulation(fromCities: self.cities)
    }
    
    private func randomPopulation(fromCities: [TSPPlace]) -> [Route] {
        var result: [Route] = []
        for _ in 0..<populationSize {
            let randomCities = fromCities.shuffle()
            result.append(Route(cities: randomCities))
        }
        return result
    }
    
    private var evolving = false
    private var generation = 1
    
    public func startEvolution() {
        var evolveTimes: NSInteger = 0
        evolving = true
        DispatchQueue.global().async {
            while self.evolving {
                
                evolveTimes += 1
                
                let currentTotalDistance = self.population.reduce(0.0, { $0 + $1.distance })
                let sortByFitnessDESC: (Route, Route) -> Bool = { $0.fitness(withTotalDistance: currentTotalDistance) > $1.fitness(withTotalDistance: currentTotalDistance) }
                let currentGeneration = self.population.sorted(by: sortByFitnessDESC)
                
                var nextGeneration: [Route] = []
                
                for _ in 0..<self.populationSize {
                    guard
                        let parentOne = self.getParent(fromGeneration: currentGeneration, withTotalDistance: currentTotalDistance),
                        let parentTwo = self.getParent(fromGeneration: currentGeneration, withTotalDistance: currentTotalDistance)
                        else { continue }
                    
                    let child = self.produceOffspring(firstParent: parentOne, secondParent: parentTwo)
                    let finalChild = self.mutate(child: child)
                    
                    nextGeneration.append(finalChild)
                }
                self.population = nextGeneration
                
                if let bestRoute = self.population.sorted(by: sortByFitnessDESC).first {
//                    self.onNewGeneration?(bestRoute, self.generation)
                    
                    if evolveTimes > 5 { // TODO: evolveTimes
                        self.evolving = false
                        self.onNewGeneration?(bestRoute, self.generation)
                    }
                }
                self.generation += 1
            }
        }
    }
    
    public func stopEvolution() {
        evolving = false
    }
    
    private func getParent(fromGeneration generation: [Route], withTotalDistance totalDistance: CGFloat) -> Route? {
        let fitness = CGFloat(Double(arc4random()) / Double(UINT32_MAX))
        
        var currentFitness: CGFloat = 0.0
        var result: Route?
        generation.forEach { (route) in
            if currentFitness <= fitness {
                currentFitness += route.fitness(withTotalDistance: totalDistance) //TODO: This is using the 'elitist' method, convert it to a 'roulette'
                result = route
            }
        }
        
        return result
    }
    
    private func produceOffspring(firstParent: Route, secondParent: Route) -> Route {
        let slice: Int = Int(arc4random_uniform(UInt32(firstParent.cities.count)))
        var cities: [TSPPlace] = Array(firstParent.cities[0..<slice])
        
        var idx = slice
        while cities.count < secondParent.cities.count {
            let city = secondParent.cities[idx]
            
            var contained: Bool = false
            cities.forEach { (aCity) in
                if aCity.location.x == city.location.x && aCity.location.y == city.location.y {
                    contained = true
                }
            }
            
            if !contained {
                cities.append(city)
            }
            idx = (idx + 1) % secondParent.cities.count
        }
        
        return Route(cities: cities)
    }
    
    private func mutate(child: Route) -> Route {
        if self.mutationProbability >= Double(Double(arc4random()) / Double(UINT32_MAX)) {
            let firstIdx = Int(arc4random_uniform(UInt32(child.cities.count)))
            let secondIdx = Int(arc4random_uniform(UInt32(child.cities.count)))
            var cities = child.cities
            cities.swapAt(firstIdx, secondIdx)
            
            return Route(cities: cities)
        }
        
        return child
    }
}

extension Array {
    public func shuffle() -> [Element] {
        return sorted(by: { (_, _) -> Bool in
            return arc4random() < arc4random()
        })
    }
}
