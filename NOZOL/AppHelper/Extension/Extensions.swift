//
//  Extensions.swift
//  MyLaundryApp
//
//  Created by TecOrb on 15/12/16.
//  Copyright © 2016 Nakul Sharma. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation




extension UIView {
    //MARK: - method for UITableView
    func tableViewCell() -> UITableViewCell? {
        var tableViewcell : UIView? = self
        while(tableViewcell != nil)
        {
            if tableViewcell! is UITableViewCell {
                break
            }
            tableViewcell = tableViewcell!.superview
        }
        return tableViewcell as? UITableViewCell
    }

    func tableViewIndexPath(_ tableView: UITableView) -> IndexPath? {

        if let cell = self.tableViewCell() {

            return tableView.indexPath(for: cell) as IndexPath?
        }else {
            return nil
        }
    }



    //MARK: - method for UICollectionView
    func collectionViewCell() -> UICollectionViewCell? {

        var collectionViewcell : UIView? = self

        while(collectionViewcell != nil)
        {
            if collectionViewcell! is UICollectionViewCell {
                break
            }
            collectionViewcell = collectionViewcell!.superview
        }
        return collectionViewcell as? UICollectionViewCell
    }


    func collectionViewIndexPath(_ collectionView: UICollectionView) -> IndexPath? {
        if let cell = self.collectionViewCell(){
            return collectionView.indexPath(for: cell) as IndexPath?
        }else {
            return nil
        }

    }

    func collectionReusableView() -> UICollectionReusableView? {
        var collectionReusableView : UIView? = self
        while(collectionReusableView != nil)
        {
            if collectionReusableView! is UICollectionReusableView {
                break
            }
            collectionReusableView = collectionReusableView!.superview
        }
        return collectionReusableView as? UICollectionReusableView
    }

    func addShadowView(_ width:CGFloat=0.2, height:CGFloat=0.2, Opacidade:Float=0.7, maskToBounds:Bool=false, radius:CGFloat=0.5){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: width, height: height)
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = Opacidade
        self.layer.masksToBounds = maskToBounds
    }
}

extension UserDefaults {

    class func save(_ value:AnyObject,forKey key:String)
    {
        UserDefaults.standard.setValue(value, forKey:key)
        UserDefaults.standard.synchronize()
    }

    class func removeFromUserDefaultForKey(_ key:String)
    {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }

    class func getDataFromUserDefaultForKey(_ key:String) -> String
    {
        return UserDefaults.standard.object(forKey: key) as? String ?? ""
    }

    class func getAnyDataFromUserDefault(_ key:String) -> AnyObject
    {
        //println_debug("Any Data ---->  \(NSUserDefaults.standardUserDefaults().objectForKey(key) ?? 0)")
        return UserDefaults.standard.object(forKey: key) as AnyObject? ?? false as AnyObject
    }

    class func userdefaultForArray(_ key:String) -> Array <AnyObject>
    {
        return UserDefaults.standard.object(forKey: key) as! Array
    }
    
}

extension String {
    func doubleValue() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }

    func wordCount(_ string: String) -> Int{
        let words = string.components(separatedBy:CharacterSet.whitespaces)

       return words.count
    }
}


extension CGSize {

    var center : CGPoint {
        get {
            return CGPoint(x: width / 2, y: height / 2)
        }
    }
}

extension UIImage {

    func blur(_ radius: CGFloat) -> UIImage? {
        // extensions of UImage don't know what a CIImage is...
        typealias CIImage = CoreImage.CIImage

        // blur of your choice
        guard let blurFilter = CIFilter(name: "CIBoxBlur") else {
            return nil
        }

        blurFilter.setValue(CIImage(image: self), forKey: kCIInputImageKey)
        blurFilter.setValue(radius, forKey: kCIInputRadiusKey)

        let ciContext  = CIContext(options: nil)

        guard let result = blurFilter.value(forKey: kCIOutputImageKey) as? CIImage else {
            return nil
        }

        let blurRect = CGRect(x: -radius, y: -radius, width: self.size.width + (radius * 2), height: self.size.height + (radius * 2))

        let cgImage = ciContext.createCGImage(result, from: blurRect)

        return UIImage(cgImage: cgImage!)

    }

    func crop(_ cropRect : CGRect) -> UIImage? {

        guard let imgRef = self.cgImage!.cropping(to: cropRect) else {
            return nil
        }
        return UIImage(cgImage: imgRef)

    }

    func getPixelColor(atPoint point: CGPoint, radius:CGFloat) -> UIColor? {

        var pos = point
        var image = self

        // if the radius is too small -> skip
        if radius > 1 {

            let cropRect = CGRect(x: point.x - (radius * 4), y: point.y - (radius * 4), width: radius * 8, height: radius * 8)
            guard let cropImg = self.crop(cropRect) else {
                return nil
            }

            guard let blurImg = cropImg.blur(radius) else {
                return nil
            }

            pos = blurImg.size.center
            image = blurImg

        }

        let pixelData = image.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)

        let pixelInfo: Int = ((Int(image.size.width) * Int(pos.y)) + Int(pos.x)) * 4

        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }

    func resizeImage(_ newWidth: CGFloat) -> UIImage {

        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width:newWidth, height:newHeight))
        self.draw(in: CGRect(x:0, y:0, width:newWidth, height:newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

var tableRefreshControl:UIRefreshControl = UIRefreshControl()
extension UIViewController{
    func makePullToRefreshToTableView(_ tableName: UITableView,triggerToMethodName: String){

        tableRefreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        tableRefreshControl.backgroundColor = UIColor.white
        tableRefreshControl.addTarget(self, action: Selector(triggerToMethodName), for: UIControl.Event.valueChanged)
        tableName.addSubview(tableRefreshControl)
    }

    func makePullToRefreshEndRefreshing (_ tableView: UITableView)
    {
        tableRefreshControl.endRefreshing()
        tableView.reloadData()
    }
}


extension CLPlacemark {

    var compactAddress: String? {
        if let name = name {
            var result = name

            if let street = thoroughfare {
                result += ", \(street)"
            }

            if let city = locality {
                result += ", \(city)"
            }

            if let country = country {
                result += ", \(country)"
            }

            return result
        }
        
        return nil
    }
    
}
