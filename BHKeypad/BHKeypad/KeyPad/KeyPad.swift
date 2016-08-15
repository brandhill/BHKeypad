//
//  NumPad.swift
//  BHKeypad
//  Created by Hill on 2016/7/19.
//  Copyright © 2016 Mitsw. All rights reserved.
//

import Foundation

@IBDesignable
class KeyPad: UIView {
 
    @IBOutlet weak var creditPointView: CreditView!
    @IBOutlet weak var numKey0: NumKey!
    @IBOutlet weak var numKey1: NumKey!
    @IBOutlet weak var numKey2: NumKey!
    @IBOutlet weak var numKey3: NumKey!
    @IBOutlet weak var numKey4: NumKey!
    @IBOutlet weak var numKey5: NumKey!
    @IBOutlet weak var numKey6: NumKey!
    @IBOutlet weak var numKey7: NumKey!
    @IBOutlet weak var numKey8: NumKey!
    @IBOutlet weak var numKey9: NumKey!
    @IBOutlet weak var numKeyStar: NumKey!
    @IBOutlet weak var numKeyHash: NumKey!
    @IBOutlet weak var dialBar: DialBar!

    private var contentView: UIView!
    private let digitAlphaMapping = ["", "\u{0020}", "ABC", "DEF", "GHI", "JKL", "MNO", "PQRS", "TUV", "WXYZ"]
    
    private let digitStart = 48 // ascii code range of number 0 ~ 9 is between 48 and 57
    private let hashKeyTag = 35 // ascii code for hash character is 35
    private let starKeyTag = 42 // ascii code for star character is 42
    private let backSpaceKeyTag = 8 // ascii code for backspace character is 8
    private let dialKeyTag = 200
    
    var numKeyPressedClosure: ((phone: String) -> Void)?
    var dialKeyPressedClosure: ((phone: String) -> Void)?
    var currInput = ""
    
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
        let nib = UINib(nibName: "KeyPad", bundle: bundle)
        contentView = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        contentView.frame = bounds
        contentView.autoresizingMask = [.FlexibleWidth]
        
        self.addSubview(contentView)
        self.backgroundColor = UIColor(red:5/255.0, green:37/255.0, blue:60/255.0,  alpha:1)
        self.clipsToBounds = true
    }
    
    func setupUiComponent(){
        
        let numKeys = [numKey0, numKey1, numKey2,numKey3,
                   numKey4, numKey5, numKey6,
                   numKey7, numKey8, numKey9]
        
        for (index, key) in numKeys.enumerate() {
            key.digitLabel.text = String(index)
            key.alphaLabel.text = digitAlphaMapping[index]
            key.button.tag = digitStart + index
            key.button.addTarget(self, action: #selector(onNumKeyClick), forControlEvents: .TouchUpInside)
        }
        
        numKeyStar.digitLabel.text = "*"
        numKeyStar.alphaLabel.text = ""
        numKeyStar.button.tag = starKeyTag
        numKeyStar.button.addTarget(self, action: #selector(onNumKeyClick), forControlEvents: .TouchUpInside)

        numKeyHash.digitLabel.text = "#"
        numKeyHash.alphaLabel.text = ""
        numKeyHash.button.tag = hashKeyTag
        numKeyHash.button.addTarget(self, action: #selector(onNumKeyClick), forControlEvents: .TouchUpInside)
        
        dialBar.dialButton.tag = dialKeyTag
        dialBar.dialButton.addTarget(self, action: #selector(onDialClick), forControlEvents: .TouchUpInside)

        
        dialBar.backSpaceView.button.tag = backSpaceKeyTag
        dialBar.backSpaceView.button.addTarget(self, action: #selector(onBackSpaceKeyClick), forControlEvents: .TouchUpInside)
    }
    
    func onNumKeyClick(sender: UIButton){
        
        currInput.append(Character(UnicodeScalar(sender.tag)))

        if let closure = numKeyPressedClosure{
            closure(phone: currInput)
        }
    }
    
    
    func onBackSpaceKeyClick(sender: UIButton){
        
        guard !currInput.isEmpty else{
            return
        }
        
        currInput = String(currInput.characters.dropLast())
        
        if let closure = numKeyPressedClosure{
            closure(phone: currInput)
        }
    }
    
    func onDialClick(sender: UIButton){
        if let closure = dialKeyPressedClosure{
            closure(phone: currInput)
        }
    }
    
    
    func setActionClosure(numKeyPressedClosure numKeyPressedClosure: ((phone: String) -> Void)?, dialKeyPressedClosure: ((phone: String) -> Void)?){
        self.numKeyPressedClosure = numKeyPressedClosure
        self.dialKeyPressedClosure = dialKeyPressedClosure
    }
}