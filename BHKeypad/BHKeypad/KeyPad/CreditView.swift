//
//  CreditBar.swift
//  BHKeypad
//  Created by Hill on 2016/7/19.
//  Copyright © 2016 mitsw. All rights reserved.
//

import Foundation

@IBDesignable
class CreditView: UIView {
    
    @IBOutlet weak var creditText: UILabel!
    @IBOutlet weak var creditValue: UILabel!
    var contentView: UIView!
    
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
        let nib = UINib(nibName: "CreditView", bundle: bundle)
        contentView = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        contentView.frame = bounds
        
        self.addSubview(contentView)
        self.backgroundColor = UIColor(red:1/255.0, green:48/255.0, blue:81/255.0,  alpha:1)
        self.clipsToBounds = true
    }

    func setupUiComponent(){
        creditText.textColor = UIColor.whiteColor()
        creditValue.textColor = UIColor(red:96/255.0, green:175/255.0, blue:255/255.0,  alpha:1);
    }
}