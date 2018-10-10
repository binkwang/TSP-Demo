//
//  ViewController+TSPDelegate.swift
//  TSP
//
//  Created by Bink Wang on 9/2/18.
//  Copyright © 2018 Bink Wang. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

protocol TSPDelegate {
    func findOptimizedOrder(_ places: [TSPPlace])
}

extension ViewController: TSPDelegate
{
    func findOptimizedOrder(_ places: [TSPPlace]) {
        guard places.count >= 2 else {
            self.showAlert("Error", "You need at least 2 destinations in the list, please add your current location or by searching locations")
            return
        }
        let spinner = UIViewController.displaySpinner(onView: self.view)
        let geneticAlgorithm: GeneticAlgorithm? = GeneticAlgorithm(withCities: places)
        geneticAlgorithm?.onNewGeneration = {
            (route, generation) in
            DispatchQueue.main.async {
                //print(route.cities)
                UIViewController.removeSpinner(spinner: spinner)
                self.drawRouteOnMap(route.cities)
            }
        }
        geneticAlgorithm?.startEvolution()
    }
    
    private func addMarker(_ latitude: Double, _ longitude: Double) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.title = ""
        marker.snippet = ""
        marker.map = self.mapView
    }
    
    private func drawRouteOnMap(_ places: [TSPPlace]) {
        self.mapView.clear()
        
        for i in 0..<places.count {
            
            let originLatitude = places[i].location.x
            let originLongitude = places[i].location.y
            
            addMarker(Double(originLatitude), Double(originLongitude))
            
            var destinationLatitude: CGFloat?
            var destinationLongitude: CGFloat?
            
            if i == places.count-1 {
                destinationLatitude = places[0].location.x
                destinationLongitude = places[0].location.y
            }
            else {
                destinationLatitude = places[i+1].location.x
                destinationLongitude = places[i+1].location.y
            }
            
            let url = NSURL(string: "\("https://maps.googleapis.com/maps/api/directions/json")?origin=\(originLatitude),\(originLongitude)&destination=\(destinationLatitude!),\(destinationLongitude!)&sensor=true&key=\(kDirectionAPIKeyWithIPLimit)")
            
            let task = URLSession.shared.dataTask(with: url! as URL) { [weak self] (data, response, error) -> Void in
                guard let strongSelf = self else { return }
                do {
                    guard let data = data else { return }
                    
                    let responseDic = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves) as!  [String:AnyObject]
                    
                    guard let status = responseDic["status"] else { return }
                    
                    if status as! String == "OK" {
                        let routesArray = (((responseDic["routes"]!as! [Any])[0] as! [String:Any])["overview_polyline"] as! [String:Any])["points"] as! String
                        
                        DispatchQueue.main.async {
                            let path = GMSPath.init(fromEncodedPath: routesArray)
                            let singleLine = GMSPolyline.init(path: path)
                            singleLine.strokeWidth = 4.0
                            singleLine.strokeColor = UIColor.random
                            singleLine.map = strongSelf.mapView
                        }
                    } else {
                        guard let error_message = responseDic["error_message"] else {
                            strongSelf.showAlert("ERROR", "No detailed error message")
                            return
                        }
                        strongSelf.showAlert("ERROR", error_message as! String)
                    }
                    
                } catch {
                    print("Error")
                }
            }
            task.resume()
        }
    }
}
