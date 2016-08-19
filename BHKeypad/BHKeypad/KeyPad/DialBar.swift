//
//  DialBar.swift
//  BHKeypad
//  Created by Hill on 2016/7/19.
//  Copyright © 2016 Mitsw. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class DialBar: UIView{
    
    @IBOutlet weak var dialButton: UIButton!
    @IBOutlet weak var backSpaceView: NumKey!
    
    var contentView: UIView!
//    private let btnColorSelector = [UIControlState.Highlighted : UIColor(red:83/255.0, green:181/255.0, blue:25/255.0,  alpha:1),
//                                    UIControlState.Normal : UIColor(red:113/255.0, green:211/255.0, blue:55/255.0,  alpha:1),
//                                    UIControlState.Disabled : UIColor.clearColor()]
    
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
        let nib = UINib(nibName: "DialBar", bundle: bundle)
        contentView = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        contentView.frame = bounds
        
        self.addSubview(contentView)
        self.backgroundColor = UIColor.clearColor()
        self.clipsToBounds = true
    }
    
    func setupUiComponent(){
//        dialButton.setImage(UIImage(asset: UIImage.Asset.Icon_Dial_Call), forState: .Normal)
//        dialButton.setImage(UIImage(asset: UIImage.Asset.Icon_Dial_Call), forState: .Highlighted)
        //dialButton.setBackgroundColorSelector(btnColorSelector)
        
        backSpaceView.button.tintColor = UIColor(red:96/255.0, green:175/255.0, blue:255/255.0,  alpha:1)
        backSpaceView.button.setImage(UIImage(named: "Icon_Backspace.png"), forState: .Normal)
        backSpaceView.button.setImage(UIImage(named: "Icon_Backspace.png"), forState: .Highlighted)
        backSpaceView.alphaLabel.hidden = true
        backSpaceView.digitLabel.hidden = true
    }
}