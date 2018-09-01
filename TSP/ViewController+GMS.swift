//
//  ViewController+GMSAutocompleteResultsViewControllerDelegate.swift
//  TSP
//
//  Created by Bink Wang on 9/1/18.
//  Copyright © 2018 Bink Wang. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

// MARK: GMSAutocomplete - Handle the user's selection.

extension ViewController: GMSAutocompleteResultsViewControllerDelegate {
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        
        let tspPlace = TSPPlace.init(location: CGPoint.init(x: place.coordinate.latitude, y: place.coordinate.longitude), address: place.formattedAddress, coordinate: place.coordinate)
        
        if !isPlaceExistingInList(tspPlace) {
            selectedPlaces.append(tspPlace)
        } else {
            self.showAlert("Prompt", "The place has been existing in the list.")
        }
        
        // Do something with the selected place.
        print("Place:\(place)")
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

// MARK: GMSMapViewDelegate

extension ViewController: GMSMapViewDelegate
{
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        print("myLocation: \(String(describing: mapView.myLocation))")
        self.mapView.clear()
        self.showCurrentLoactionAddingView()
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let newCoordinate = CLLocationCoordinate2DMake(position.target.latitude, position.target.longitude)
        GMSGeocoder().reverseGeocodeCoordinate(CLLocationCoordinate2DMake(newCoordinate.latitude, newCoordinate.longitude)) { response , error in
            if let address: GMSAddress = response?.firstResult() {
                print("address: \(address)")
                self.customMapMarker.address = address
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
    }
}
