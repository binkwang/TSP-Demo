//
//  CurrentLoactionAddingView.swift
//  TSP
//
//  Created by Bink Wang on 8/10/18.
//  Copyright © 2018 Bink Wang. All rights reserved.
//

import UIKit

class CurrentLoactionAddingView: UIView {

    let nibName = "CurrentLoactionAddingView"
    
    var cancelHandler: (() -> Void)?
    var confirmHandler: (() -> Void)?
    
    
    //MARK: - IBOutlets
    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
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
        
        cancelButton.layer.masksToBounds = true
        cancelButton.layer.cornerRadius = 10
        cancelButton.setBackgroundColor(UIColor.lightGray, for: .normal)
        cancelButton.setBackgroundColor(UIColor.gray, for: .highlighted)
        
        confirmButton.layer.masksToBounds = true
        confirmButton.layer.cornerRadius = 10
        confirmButton.setBackgroundColor(UIColor.lightGray, for: .normal)
        confirmButton.setBackgroundColor(UIColor.gray, for: .highlighted)
    }
    
    func configureNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    @IBAction private func cancelButtonTapped() {
        print("cancelButtonTapped")
        guard let cancelHandler = self.cancelHandler else { return }
        cancelHandler()
    }
    
    @IBAction private func confirmButtonTapped() {
        print("confirmButtonTapped")
        guard let confirmHandler = self.confirmHandler else { return }
        confirmHandler()
    }
    
}
