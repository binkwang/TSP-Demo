//
//  SelectedPlaceCell.swift
//  TSP
//
//  Created by Bink Wang on 8/10/18.
//  Copyright © 2018 Bink Wang. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class SelectedPlaceCell: UITableViewCell {
    
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    
    // GMSPlace instance format:
    // name: 120 Broadway, id: ChIJ19MrQBdawokRYZ6HeQMZmok, coordinate: (40.708212 -74.010659), open now: 2, phone: (null), address: 120 Broadway, New York, NY 10271, USA, rating: 0.000000, price level: -1, website: (null), types: ("street_address")
    var place: TSPPlace? {
        didSet {
            guard let place = place else { return }
            
            guard let addresses = place.address?.components(separatedBy: ", ") else { return }
            
            if addresses.count > 0 {
                self.addressLabel.text = addresses[0]
            }
            
            if addresses.count > 1 {
                self.areaLabel.text = addresses[1]
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewAutoLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func viewAutoLayout() {
        indexLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        areaLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let views = Dictionary(dictionaryLiteral: ("indexLabel",indexLabel), ("addressLabel",addressLabel), ("areaLabel",areaLabel)) as [String : Any]
        
        let metrics = Dictionary(dictionaryLiteral: ("padding", 10),("indexLabel",40))
        
        let horizontal1 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[indexLabel(==indexLabel)]-6-[addressLabel]-padding-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views)
        
        let horizontal2 = NSLayoutConstraint.constraints(withVisualFormat: "H:[indexLabel]-6-[areaLabel]-padding-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views)
        
        let vertical1 = NSLayoutConstraint.constraints(withVisualFormat: "V:|-padding-[indexLabel]-padding-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views)
        
        let vertical2 = NSLayoutConstraint.constraints(withVisualFormat: "V:|-padding-[addressLabel]-5-[areaLabel]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views)
        
        var viewConstraints = [NSLayoutConstraint]()
        
        viewConstraints += horizontal1
        viewConstraints += horizontal2
        viewConstraints += vertical1
        viewConstraints += vertical2
        
        NSLayoutConstraint.activate(viewConstraints)
    }
    
}
