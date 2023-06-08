//
//  UIView+Extension.swift
//  Batvard
//
//  Created by Vikas on 30/05/19.
//  Copyright © 2019 Mobilecoderz. All rights reserved.
//

import UIKit
extension UIView {
    func makeRoundCorner(_ radius:CGFloat){
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    func makeBorder(_ width:CGFloat,color:UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        self.clipsToBounds = true
    }
    func addShadowWithRadius(radius: CGFloat ,cornerRadius: CGFloat ){
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = radius
        layer.cornerRadius = cornerRadius
    }
    func setShadowWithColor() {
        layer.cornerRadius = 10
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize(width: 0 ,height: 3)
        self.layer.shadowRadius = 5
    }
    func setRadius(_ corner : CGFloat){
        layer.cornerRadius = corner
        clipsToBounds = true
    }
    var parentViewController: UIViewController? {
        for responder in sequence(first: self, next: { $0.next }) {
            if let viewController = responder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    func roundCornersOneSide(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func makeRounded() {
        self.layer.cornerRadius = self.frame.size.width/2.0
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func setShaddowWithColor() {
        self.layer.masksToBounds = false
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.init(red: 234/255, green:  234/255, blue:  234/255, alpha: 1.0).cgColor
        self.layer.shadowColor = UIColor.init(red: 234/255, green:  234/255, blue:  234/255, alpha: 1.0).cgColor
      //  self.layer.borderColor = UIColor.init(red: 206/255, green:  206/255, blue:  206/255, alpha: 1.0).cgColor
      //  self.layer.shadowColor = UIColor.init(red: 206/255, green:  206/255, blue:  206/255, alpha: 1.0).cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize(width: -0.5 ,height: +5)
        self.layer.shadowRadius = 3
    }
    
    func close(animate: Bool = true, duration: Double = 0.5) {
        if !animate {
            self.alpha = 0.0
            return
        }
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        }) { (compelete) in
            if compelete {
                self.removeFromSuperview()
            }
        }
    }
    
    class func fromNib<T : UIView>(xibName: String) -> T {
        return Bundle.main.loadNibNamed(xibName, owner: nil, options: nil )![0] as! T
    }
    
    func typeName(_ some: Any) -> String {
        return (some is Any.Type) ? "\(some)" : "\(type(of: some))"
    }
}
//for round Shadow

@IBDesignable
class CardView: UIView {

@IBInspectable var cornerRadiu: CGFloat = 2
@IBInspectable var shadowOffsetWidth: Int = 0
@IBInspectable var shadowOffsetHeight: Int = 3
@IBInspectable var shadowColor: UIColor? = UIColor.black
@IBInspectable var shadowOpacity: Float = 0.5
@IBInspectable var layerOpacity: Float = 1

override func layoutSubviews() {
layer.cornerRadius = cornerRadiu
let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadiu)
layer.masksToBounds = false
layer.shadowColor = shadowColor?.cgColor
layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
layer.shadowOpacity = shadowOpacity
layer.shadowPath = shadowPath.cgPath
layer.opacity = layerOpacity
}

}





