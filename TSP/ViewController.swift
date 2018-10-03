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
    @IBOutlet weak var selectCurrentLoactionView: SelectCurrentLoactionView!
    
    var customMapMarker: CustomMapMarker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.initGMSMapView()
        self.initTableView()
        self.initCurrentLoactionView()
        self.initSearchController() // Init UISearchController with GMSAutocompleteResultsViewController
        
        self.layoutUIWithMode(.defaultMode)
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
    
    private func initCurrentLoactionView() {
        selectCurrentLoactionView.delegate = self
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
}

extension ViewController {
    
    enum ViewLayoutMode: NSInteger {
        case showCurrentLoaction = 0, defaultMode
    }
    
    func layoutUIWithMode(_ mode: ViewLayoutMode) {
        UIView.animate(withDuration: 0.6, animations: {
            self.mapView.frame = self.mapViewFrameForStatus(mode)
            self.tableView.frame = self.tableViewFrameForStatus(mode)
            self.selectCurrentLoactionView.frame = self.currentLoactionViewFrameForStatus(mode)
            if mode == .showCurrentLoaction {
                self.customMapMarker.center = CGPoint.init(x: self.mapView.center.x, y: self.mapView.center.y-self.customMapMarker.frame.height/2)
            }
        }) { (isFinish) in
            if isFinish && mode == .showCurrentLoaction{
                self.customMapMarker.isHidden = false
            }
        }
    }
    
    private func mapViewFrameForStatus(_ status: ViewLayoutMode) -> CGRect {
        switch status {
        case .showCurrentLoaction:
            return CGRect.init(x: 0, y: 0, width: self.screenWidth, height: self.screenHeight-100)
        default:
            return CGRect.init(x: 0, y: 0, width: self.screenWidth, height: self.screenHeight/2)
        }
    }
    
    private func tableViewFrameForStatus(_ status: ViewLayoutMode) -> CGRect {
        switch status {
        case .showCurrentLoaction:
            return CGRect.init(x: 0, y: self.screenHeight, width: self.screenWidth, height: self.screenHeight/2)
        default:
            return CGRect.init(x: 0, y: self.screenHeight/2, width: self.screenWidth, height: self.screenHeight/2)
        }
    }
    
    private func currentLoactionViewFrameForStatus(_ status: ViewLayoutMode) -> CGRect {
        switch status {
        case .showCurrentLoaction:
            return CGRect.init(x: 0, y: self.screenHeight-100, width: self.screenWidth, height: 100)
        default:
            return CGRect.init(x: 0, y: self.screenHeight, width: self.screenWidth, height: 100)
        }
    }
}

