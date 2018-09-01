//
//  ViewController.swift
//  TSP
//
//  Created by Bink Wang on 8/9/18.
//  Copyright © 2018 Bink Wang. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class ViewController: UIViewController {
    
    // MARK: GMSAutocomplete Property
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    
    var selectedPlaces: [TSPPlace] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currentLoactionAddingView: CurrentLoactionAddingView!
    
    var customMapMarker: CustomMapMarker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.initGMSMapView()
        self.initTableView()
        self.initCurrentLoactionAddingView()
        self.initSearchController() // Init UISearchController with GMSAutocompleteResultsViewController
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: private methods
    
    private func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableView.separatorColor = UIColor.gray
        let nib = UINib.init(nibName: "SelectedPlaceCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "SelectedPlaceCellIdentifier")
    }
    
    private func initGMSMapView() {
        let camera = GMSCameraPosition.camera(withLatitude: -36.850283, longitude: 174.769261, zoom: 14) // Auckland University
        mapView.camera = camera
        mapView.mapType = .normal
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        mapView.delegate = self
        
        customMapMarker = CustomMapMarker.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: 80))
        mapView.addSubview(customMapMarker)
        customMapMarker.center = CGPoint.init(x: mapView.center.x, y: mapView.center.y-customMapMarker.frame.height/2)
        customMapMarker.isHidden = true
    }
    
    private func initCurrentLoactionAddingView() {
        // Init CurrentLoactionAddingView
        currentLoactionAddingView.frame = currentLoactionAddingViewFrameForStatus(status: 1)
        currentLoactionAddingView.cancelHandler = { () in
            self.dismissCurrentLoactionAddingView()
        }
        currentLoactionAddingView.confirmHandler = { () in
            self.dismissCurrentLoactionAddingView()
            
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
    
    private func initSearchController() {
        
        resultsViewController = GMSAutocompleteResultsViewController()
        let visibleRegion = mapView.projection.visibleRegion()
        let bounds = GMSCoordinateBounds(coordinate: visibleRegion.farLeft, coordinate: visibleRegion.nearRight)
        resultsViewController?.autocompleteBounds = bounds
        //resultsViewController?.tableCellBackgroundColor = UIColor.gray
        resultsViewController?.delegate = self as GMSAutocompleteResultsViewControllerDelegate
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.view.backgroundColor = UIColor.clear
        searchController?.searchResultsUpdater = resultsViewController
        
        let searchBarContainer = UIView(frame: CGRect(x: 0, y: 20.0, width: 350.0, height: 45.0))
        searchBarContainer.addSubview((searchController?.searchBar)!)
        view.addSubview(searchBarContainer)
        
        searchController?.searchBar.sizeToFit()
        
        searchController?.searchBar.tintColor = UIColor.red
        searchController?.searchBar.barTintColor = UIColor.clear
        searchController?.searchBar.backgroundImage = UIImage()
        
        searchController?.hidesNavigationBarDuringPresentation = false
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
    }
    
    private func dismissCurrentLoactionAddingView() {
        self.customMapMarker.isHidden = true
        UIView.animate(withDuration: 0.6, animations: {
            self.mapView.frame = self.mapViewFrameForStatus(status: 1)
            self.tableView.frame = self.tableViewFrameForStatus(status: 1)
            self.currentLoactionAddingView.frame = self.currentLoactionAddingViewFrameForStatus(status: 1)
        }) { (isFinish) in
        }
    }
    
    private func mapViewFrameForStatus(status: NSInteger) -> CGRect {
        switch status {
        case 0:
            return CGRect.init(x: 0, y: 0, width: self.screenWidth, height: self.screenHeight-100)
        default:
            return CGRect.init(x: 0, y: 0, width: self.screenWidth, height: self.screenHeight/2)
        }
    }
    
    private func tableViewFrameForStatus(status: NSInteger) -> CGRect {
        switch status {
        case 0:
            return CGRect.init(x: 0, y: self.screenHeight, width: self.screenWidth, height: self.screenHeight/2)
        default:
            return CGRect.init(x: 0, y: self.screenHeight/2, width: self.screenWidth, height: self.screenHeight/2)
        }
    }
    
    private func currentLoactionAddingViewFrameForStatus(status: NSInteger) -> CGRect {
        switch status {
        case 0:
            return CGRect.init(x: 0, y: self.screenHeight-100, width: self.screenWidth, height: 100)
        default:
            return CGRect.init(x: 0, y: self.screenHeight, width: self.screenWidth, height: 100)
        }
    }
    
    func showCurrentLoactionAddingView() {
        UIView.animate(withDuration: 0.6, animations: {
            self.mapView.frame = self.mapViewFrameForStatus(status: 0)
            self.tableView.frame = self.tableViewFrameForStatus(status: 0)
            self.currentLoactionAddingView.frame = self.currentLoactionAddingViewFrameForStatus(status: 0)
            self.customMapMarker.center = CGPoint.init(x: self.mapView.center.x, y: self.mapView.center.y-self.customMapMarker.frame.height/2)
        }) { (isFinish) in
            if isFinish {
                self.customMapMarker.isHidden = false
            }
        }
    }
    
    func isPlaceExistingInList(_ place: TSPPlace) -> Bool {
        var isExisting: Bool = false
        selectedPlaces.forEach { (selectedPlace) in
            if place.isSamePlace(selectedPlace) {
                isExisting = true
                return
            }
        }
        return isExisting
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style {
            case .default:
                print("default")
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            }}))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: TSPDelegate

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
            
            let task = URLSession.shared.dataTask(with: url! as URL) { (data, response, error) -> Void in
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
                            singleLine.map = self.mapView
                        }
                    } else {
                        guard let error_message = responseDic["error_message"] else {
                            self.showAlert("ERROR", "No detailed error message")
                            return
                        }
                        self.showAlert("ERROR", error_message as! String)
                    }
                    
                } catch {
                    print("Error")
                }
            }
            
            task.resume()
        }
    }
}
