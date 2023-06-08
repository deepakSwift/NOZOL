//
//  UIView.swift
//  MyLaundryApp
//
//  Created by TecOrb on 15/12/16.
//  Copyright © 2016 Nakul Sharma. All rights reserved.
//

import UIKit
//import Toast_Swift

@IBDesignable class DottedVertical: UIView {
    @IBInspectable var dotColor: UIColor = UIColor.darkGray
    override func draw(_ rect: CGRect) {
        self.addDashedLine(fromPoint: self.frame.origin, toPoint: CGPoint(x:self.frame.size.width,y:self.frame.origin.y))
    }
    fileprivate func addDashedLine(fromPoint start: CGPoint, toPoint end:CGPoint) {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: start)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        line.strokeColor = dotColor.cgColor
        line.lineWidth = 1
        line.lineJoin = CAShapeLayerLineJoin.round
        line.lineDashPattern = [2, 2]
        self.layer.addSublayer(line)
    }
}

extension UIView {
//    class func loadNib<T: UIView>(viewType: T.Type) -> T {
//        let className = String.className(aClass: viewType)
//        return NSBundle(forClass: viewType).loadNibNamed(className, owner: nil, options: nil).first as! T
//    }
//    
//    class func loadNib() -> Self {
//        return loadNib(self)
//    }
//
//    func addGradientBackGround(){
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = CGRect(x:0, y:0, width:self.frame.size.width, height: self.frame.size.height)
//        var i = 36
//        var colors = [AnyObject]()
//        while i >= 0 {
//            colors.append(UIColor(red: CGFloat(i)/255.0, green: CGFloat(i)/255.0, blue: CGFloat(i)/255.0, alpha: 1.0).cgColor as AnyObject)
//            i-=1
//        }
//        gradientLayer.colors = colors
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
//        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
//        self.layer.addSublayer(gradientLayer)
//    }


//    func addShadow(topShadowWidth:CGFloat,leftShadowWidth:CGFloat,bottomShadowWidth:CGFloat,rightShadowWidth:CGFloat,shadowColor:UIColor,opicity:Float){
//        let shadowPath = UIBezierPath(rect: CGRectMake(self.frame.origin.x - leftShadowWidth,
//            self.frame.origin.y - topShadowWidth,
//            self.frame.size.width + rightShadowWidth,
//            self.frame.size.height + bottomShadowWidth))
//
//        self.layer.masksToBounds = false
//        self.layer.shadowColor = shadowColor.CGColor;
//        self.layer.shadowOffset = CGSizeMake(10, 10);
//        self.layer.shadowOpacity = opicity
//        self.layer.shadowPath = shadowPath.CGPath;
//
//    }




    func addTopBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:0, width:self.frame.size.width, height:width)
        self.layer.addSublayer(border)
    }

    func addTopThinBorderWithColor(_ color: UIColor) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        let width = 1.0/(UIScreen.main.scale/4)
        border.frame = CGRect(x:0, y:0, width:self.frame.size.width, height:width)
        self.layer.addSublayer(border)
    }
    func addBottomThinBorderWithColor(_ color: UIColor) {
        let border = CALayer()
        let width = 1.0/(UIScreen.main.scale/4)
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:self.frame.size.height - width, width:self.frame.size.width, height:width)
        self.layer.addSublayer(border)
    }

    func addRightBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:self.frame.size.width - width, y:0,width:width, height:self.frame.size.height)
        self.layer.addSublayer(border)
    }

    func addBottomBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:self.frame.size.height - width, width:self.frame.size.width, height:width)
        self.layer.addSublayer(border)
    }

    func addLeftBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:0, width:width, height:self.frame.size.height)
        self.layer.addSublayer(border)
    }

}

extension UIView {

    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue

            // Don't touch the masksToBound property if a shadow is needed in addition to the cornerRadius
            if shadow == false {
                self.layer.masksToBounds = true
            }
        }
    }


    func addShadow(_ shadowColor: CGColor = UIColor.black.cgColor,
                   shadowOffset: CGSize = CGSize(width: 1.0, height: 2.0),
                   shadowOpacity: Float = 0.4,
                   shadowRadius: CGFloat = 3.0) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
}


//@IBDesignable class RoundRectView: UIView {
//
//    @IBInspectable var cornerRadius: CGFloat = 0.0
//    @IBInspectable var borderColor: UIColor = UIColor.black
//    @IBInspectable var borderWidth: CGFloat = 0.5
//    @IBInspectable var shadowRadius: CGFloat = 5.0
//    @IBInspectable var shadowOpacity: Float = 0.5
//
//    private var customBackgroundColor = UIColor.white
//    override var backgroundColor: UIColor?{
//        didSet {
//            customBackgroundColor = backgroundColor!
//            super.backgroundColor = UIColor.clear
//        }
//    }
//
//    func setup() {
//        layer.shadowColor = UIColor.black.cgColor;
//        layer.shadowOffset = CGSize.zero
//        layer.shadowRadius = shadowRadius
//        layer.shadowOpacity = shadowOpacity
//        super.backgroundColor = UIColor.clear
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.setup()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        self.setup()
//    }
//
//    override func draw(_ rect: CGRect) {
//        customBackgroundColor.setFill()
//        UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius ).fill()
//        let borderRect = bounds.insetBy(dx: borderWidth/2, dy: borderWidth/2)
//        let borderPath = UIBezierPath(roundedRect: borderRect, cornerRadius: cornerRadius - borderWidth/2)
//        borderColor.setStroke()
//        borderPath.lineWidth = borderWidth
//        borderPath.stroke()
//        
//        // whatever else you need drawn
//    }
//}
