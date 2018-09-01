//
//  CustomMapMarker.swift
//  TSP
//
//  Created by Bink Wang on 8/13/18.
//  Copyright © 2018 Bink Wang. All rights reserved.
//

import UIKit
import GoogleMaps

class CustomMapMarker: UIView {
    
    let nibName = "CustomMapMarker"
    
    //MARK: - IBOutlets
    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var markerImageView: UIImageView!
    
    var address: GMSAddress? {
        didSet {
            infoLabel.text = address?.thoroughfare
        }
    }
    
    //MARK: - UIView Overided methods
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureXIB()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureXIB()
    }
    
    func configureXIB() {
        customView = configureNib()
        customView.frame = bounds
        customView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(customView)
        customView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        infoLabel.layer.masksToBounds = true
        infoLabel.layer.cornerRadius = 5
    }
    
    func configureNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
}
