//
//  ViewController+UITableView.swift
//  TSP
//
//  Created by Bink Wang on 9/1/18.
//  Copyright © 2018 Bink Wang. All rights reserved.
//

import Foundation
import UIKit

extension ViewController: UITableViewDataSource, UITableViewDelegate
{
    // UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.section as Any)
        print(indexPath.row as Any)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == UITableViewCellEditingStyle.delete {
            selectedPlaces.remove(at: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = SelectedPlaceHeaderView.init(frame: CGRect.init())
        headView.directionsHandler = { () in
            self.findOptimizedOrder(self.selectedPlaces)
        }
        headView.clearAllHandler = { () in
            self.selectedPlaces.removeAll()
        }
        return headView
    }
    
    // UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "SelectedPlaceCellIdentifier"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SelectedPlaceCell else {
            fatalError("The dequeued cell is not an instance of SelectedPlaceCell.")
        }
        
        cell.indexLabel.text = "(\(indexPath.row+1))"
        cell.place = selectedPlaces[indexPath.row]
        
        return cell
    }
}
