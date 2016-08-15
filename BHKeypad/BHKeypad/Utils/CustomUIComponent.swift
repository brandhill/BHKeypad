//
//  UIButtonEx.swift
//  BHKeypad
//  Created by Hill on 2016/7/19.
//  Copyright © 2016 mitsw. All rights reserved.
//

import UIKit

extension UIView {
    class func createRoundCornerRectLayer(bounds: CGRect, byRoundingCorners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: byRoundingCorners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds;
        maskLayer.path  = maskPath.CGPath;
        
        return maskLayer
    }
    
    class func createViewFromNib(forClass aClass: AnyClass, nibName: String) -> UIView {
        let bundle = NSBundle(forClass: aClass)
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiateWithOwner(self, options: nil)[0] as! UIView
    }
}

@IBDesignable class UIViewEx: UIView {
    @IBInspectable var showTopLeftCorner:Bool {
        get{
            if let show = self.layer.valueForKey("showTopLeftCorner") {
                return show as! Bool
            } else {
                return false
            }
        }
        set {
            self.layer.setValue(newValue, forKey: "showTopLeftCorner")
        }
    }
    @IBInspectable var showTopRightCorner:Bool {
        get{
            if let show = self.layer.valueForKey("showTopRightCorner") {
                return show as! Bool
            } else {
                return false
            }
        }
        set {
            self.layer.setValue(newValue, forKey: "showTopRightCorner")
        }
    }
    @IBInspectable var showBottomLeftCorner:Bool {
        get{
            if let show = self.layer.valueForKey("showBottomLeftCorner") {
                return show as! Bool
            } else {
                return false
            }
        }
        set {
            self.layer.setValue(newValue, forKey: "showBottomLeftCorner")
        }
    }
    @IBInspectable var showBottomRightCorner:Bool {
        get{
            if let show = self.layer.valueForKey("showBottomRightCorner") {
                return show as! Bool
            } else {
                return false
            }
        }
        set {
            self.layer.setValue(newValue, forKey: "showBottomRightCorner")
        }
    }
    
    @IBInspectable var layerCornerRadius: CGFloat {
        get {
            if let radius = self.layer.valueForKey("layerCornerRadius") {
                return radius as! CGFloat
            } else {
                return 0
            }
        }
        set {
            self.layer.setValue(newValue, forKey: "layerCornerRadius")
        }
    }
    
    @IBInspectable var layerColor: UIColor {
        get { return UIColor.clearColor() }
        set {
            self.layer.backgroundColor = newValue.CGColor
        }
    }
    
    internal func setupRoundCornerMask() {
        var corners:UIRectCorner = UIRectCorner.TopLeft
        
        if showTopLeftCorner {
            corners.insert(UIRectCorner.TopLeft)
        }
        else {
            corners.remove(UIRectCorner.TopLeft)
        }
        
        if showTopRightCorner {
            corners.insert(UIRectCorner.TopRight)
        }
        
        if showBottomLeftCorner {
            corners.insert(UIRectCorner.BottomLeft)
        }
        
        if showBottomRightCorner {
            corners.insert(UIRectCorner.BottomRight)
        }
        self.layer.mask = UIView.createRoundCornerRectLayer(self.bounds, byRoundingCorners: corners, radius: layerCornerRadius)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if layerCornerRadius > 0 {
            setupRoundCornerMask()
        }
    }
}

@IBDesignable class UILabelEx: UILabel {

}

@IBDesignable class UIButtonEx: UIButton {
    @IBInspectable var increasedTouchArea: CGPoint = CGPoint.zero
    
    @IBInspectable var showTopLeftCorner:Bool {
        get{
            if let show = self.layer.valueForKey("showTopLeftCorner") {
                return show as! Bool
            } else {
                return false
            }
        }
        set {
            self.layer.setValue(newValue, forKey: "showTopLeftCorner")
        }
    }
    @IBInspectable var showTopRightCorner:Bool {
        get{
            if let show = self.layer.valueForKey("showTopRightCorner") {
                return show as! Bool
            } else {
                return false
            }
        }
        set {
            self.layer.setValue(newValue, forKey: "showTopRightCorner")
        }
    }
    @IBInspectable var showBottomLeftCorner:Bool {
        get{
            if let show = self.layer.valueForKey("showBottomLeftCorner") {
                return show as! Bool
            } else {
                return false
            }
        }
        set {
            self.layer.setValue(newValue, forKey: "showBottomLeftCorner")
        }
    }
    @IBInspectable var showBottomRightCorner:Bool {
        get{
            if let show = self.layer.valueForKey("showBottomRightCorner") {
                return show as! Bool
            } else {
                return false
            }
        }
        set {
            self.layer.setValue(newValue, forKey: "showBottomRightCorner")
        }
    }
    
    @IBInspectable var layerCornerRadius: CGFloat {
        get {
            if let radius = self.layer.valueForKey("layerCornerRadius") {
                return radius as! CGFloat
            } else {
                return 0
            }
        }
        set {
            self.layer.setValue(newValue, forKey: "layerCornerRadius")
        }
    }
    
    @IBInspectable var layerColor: UIColor {
        get {
            if let radius = self.layer.valueForKey("layerColor") {
                return radius as! UIColor
            } else {
                return UIColor.clearColor()
            }
        }
        set {
            self.layer.backgroundColor = newValue.CGColor
            self.layer.setValue(newValue, forKey: "layerColor")
        }
    }
    
    @IBInspectable var layerPressedColor: UIColor {
        get {
            if let radius = self.layer.valueForKey("layerPressedColor") {
                return radius as! UIColor
            } else {
                return UIColor.clearColor()
            }
        }
        set {
            self.layer.setValue(newValue, forKey: "layerPressedColor")
            if layerColor != UIColor.clearColor() {
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        if layerPressedColor != UIColor.clearColor() {
            self.layer.backgroundColor = layerPressedColor.CGColor
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        if layerPressedColor != UIColor.clearColor() {
            self.layer.backgroundColor = layerColor.CGColor
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
        if layerPressedColor != UIColor.clearColor() {
            self.layer.backgroundColor = layerColor.CGColor
        }
    }
    
    internal func setupRoundCornerMask() {
        var corners:UIRectCorner = UIRectCorner.TopLeft
        
        if showTopLeftCorner {
            corners.insert(UIRectCorner.TopLeft)
        }
        else {
            corners.remove(UIRectCorner.TopLeft)
        }
        
        if showTopRightCorner {
            corners.insert(UIRectCorner.TopRight)
        }
        
        if showBottomLeftCorner {
            corners.insert(UIRectCorner.BottomLeft)
        }
        
        if showBottomRightCorner {
            corners.insert(UIRectCorner.BottomRight)
        }
        self.layer.mask = UIView.createRoundCornerRectLayer(self.bounds, byRoundingCorners: corners, radius: layerCornerRadius)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if layerCornerRadius > 0 {
            setupRoundCornerMask()
        }
    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        if increasedTouchArea == CGPoint.zero {
            return super.hitTest(point, withEvent: event)
        } else {
        
            if (!self.userInteractionEnabled || self.hidden || self.alpha <= 0.01) {
                return nil;
            }
            let touchRect = CGRectInset(self.bounds, -increasedTouchArea.x, -increasedTouchArea.y)
            if(CGRectContainsPoint(touchRect, point)) {
                return self
            }
        }
        return nil
    }
}

@IBDesignable class UIClickableView : UIView {
    @IBInspectable var pressedColor: UIColor?
    var originBgColor : UIColor?
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        originBgColor = backgroundColor
        backgroundColor = pressedColor ?? backgroundColor
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        backgroundColor = originBgColor
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
        
        backgroundColor = originBgColor
    }
}