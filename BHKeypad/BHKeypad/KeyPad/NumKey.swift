//
//  NumKey.swift
//  BHKeypad
//  Created by Hill on 2016/7/19.
//  Copyright © 2016 Mitsw. All rights reserved.
//

import Foundation

@IBDesignable
class NumKey: UIView {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var digitLabel: UILabel!
    @IBOutlet weak var alphaLabel: UILabel!
    var contentView: UIView!
    
//    private let btnColorSelector = [UIControlState.Highlighted : UIColor(red:15/255.0, green:68/255.0, blue:106/255.0,  alpha:1),
//                            UIControlState.Normal : UIColor.clearColor(),
//                            UIControlState.Disabled : UIColor.clearColor()]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initFromXIB()
        setupUiComponent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initFromXIB()
        setupUiComponent()
    }
    
    func initFromXIB() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "NumKey", bundle: bundle)
        contentView = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        contentView.frame = bounds
        
        self.addSubview(contentView)
        self.backgroundColor = UIColor.clearColor()
        self.clipsToBounds = true
    }
    
    func setupUiComponent(){
        digitLabel.textColor = UIColor(red:96/255.0, green:175/255.0, blue:255/255.0,  alpha:1)
        alphaLabel.textColor = UIColor.whiteColor()
    }
}