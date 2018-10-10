//
//  SelectCurrentLoactionView.swift
//  TSP
//
//  Created by Bink Wang on 8/10/18.
//  Copyright © 2018 Bink Wang. All rights reserved.
//

import UIKit

protocol SelectCurrentLoactionDelegate: class {
    func cancelButtonTapped()
    func confirmButtonTapped()
}

class SelectCurrentLoactionView: UIView {
    let nibName = "SelectCurrentLoactionView"
    
    weak var delegate: SelectCurrentLoactionDelegate?
    
    //MARK: - IBOutlets
    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBAction private func cancelButtonTapped() {
        delegate?.cancelButtonTapped()
    }
    
    @IBAction private func confirmButtonTapped() {
        delegate?.confirmButtonTapped()
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
        
        cancelButton.styleButton()
        confirmButton.styleButton()
    }
    
    func configureNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
}
