//
//  ViewController+SelectCurrentLoactionDelegate.swift
//  TSP
//
//  Created by Bink Wang on 9/2/18.
//  Copyright © 2018 Bink Wang. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

extension ViewController: SelectCurrentLoactionDelegate
{
    func cancelButtonTapped() {
        self.layoutUIWithMode(.defaultMode)
    }
    
    func confirmButtonTapped() {
        self.layoutUIWithMode(.defaultMode)
        
        // Donot use the current GMS location, use the precision location(which adjust by user)
        
        if let address: GMSAddress = self.customMapMarker.address {
            var formattedAddress: String?
            let lines = address.lines! as [String] //componentsJoinedByString
            
            formattedAddress = lines.joined(separator: ", ")
            let characterSet = CharacterSet(charactersIn: ", ")
            formattedAddress = formattedAddress?.trimmingCharacters(in: characterSet)
            
            let tspPlace = TSPPlace(location: CGPoint.init(x: address.coordinate.latitude, y: address.coordinate.longitude), address: formattedAddress, coordinate: address.coordinate)
            
            if !self.isPlaceExistingInList(tspPlace) {
                self.selectedPlaces.append(tspPlace)
            } else {
                self.showAlert("Prompt", "The place has been existing in the list.")
            }
        }
        
        /**************************************************** Current GMS location
         let placesClient = GMSPlacesClient()
         placesClient.currentPlace(callback: { (placeLikelihoods, error) -> Void in
         if error != nil {
         // TODO: Handle error in some way.
         }
         if let placeLikelihood = placeLikelihoods?.likelihoods.first {
         let place = placeLikelihood.place
         if !self.isPlaceExisting(place) {
         self.selectedPlaces.append(place)
         } else {
         self.showAlert("Prompt", "The place has been existing in the list.")
         }
         }
         })
         ****************************************************/
    }
}
