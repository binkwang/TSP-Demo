//
//  AppDelegate.swift
//  TSP
//
//  Created by Bink Wang on 8/9/18.
//  Copyright © 2018 Bink Wang. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Do a quick check to see if you've provided an API key
        if kMapsAPIKey.isEmpty || kPlacesAPIKey.isEmpty {
            let msg = "Configure API keys inside GoogleAPIKeys.swift"
            fatalError(msg)
        }
        GMSServices.provideAPIKey(kMapsAPIKey)
        GMSPlacesClient.provideAPIKey(kPlacesAPIKey)
        
        return true
    }
}

