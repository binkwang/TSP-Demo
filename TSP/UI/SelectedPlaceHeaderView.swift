//
//  SelectedPlaceHeaderView.swift
//  TSP
//
//  Created by Bink Wang on 8/10/18.
//  Copyright © 2018 Bink Wang. All rights reserved.
//

import UIKit

class SelectedPlaceHeaderView: UIView {
    
    let nibName = "SelectedPlaceHeaderView"
    
    var directionsHandler: (() -> Void)?
    var clearAllHandler: (() -> Void)?
    
    //MARK: - IBOutlets
    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var destinationsLabel: UILabel!
    @IBOutlet weak var directionsButton: UIButton!
    @IBOutlet weak var clearAllButton: UIButton!
    
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
        
        self.viewAutoLayout()
        
        clearAllButton.styleButton()
        directionsButton.styleButton()
    }
    
    func configureNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func viewAutoLayout() {
        destinationsLabel.translatesAutoresizingMaskIntoConstraints = false
        directionsButton.translatesAutoresizingMaskIntoConstraints = false
        clearAllButton.translatesAutoresizingMaskIntoConstraints = false
        
        let views = Dictionary(dictionaryLiteral: ("customView",customView), ("destinationsLabel",destinationsLabel), ("directionsButton",directionsButton), ("clearAllButton",clearAllButton)) as [String : Any]
        
        let metrics = Dictionary(dictionaryLiteral: ("padding", 10),("indexLabel",40))
        
        let horizontal1 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-padding-[destinationsLabel]-[clearAllButton(==90)]-[directionsButton(==90)]-20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views)
        
        let vertical1 = NSLayoutConstraint.constraints(withVisualFormat: "V:|-padding-[destinationsLabel]-padding-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views)
        
        let vertical2 = NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[clearAllButton]-15-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views)
        
        let vertical3 = NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[directionsButton]-15-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views)
        
        var viewConstraints = [NSLayoutConstraint]()
        
        viewConstraints += horizontal1
        viewConstraints += vertical1
        viewConstraints += vertical2
        viewConstraints += vertical3
        
        NSLayoutConstraint.activate(viewConstraints)
    }
    
    @IBAction private func directionsButtonTapped() {
        print("directionsButtonTapped..")
        guard let directionsHandler = self.directionsHandler else { return }
        directionsHandler()
    }
    
    @IBAction private func clearAllButtonTapped() {
        print("clearAllButtonTapped..")
        guard let clearAllHandler = self.clearAllHandler else { return }
        clearAllHandler()
    }

}
