
///
//  NOZOL
//
//  Created by Mukul Sharma on 14/07/20.
//  Copyright © 2020 Mukul Sharma. All rights reserved.
//

import UIKit


extension UIImageView {
    
//    func setRandomDownloadImage(width: Int, height: Int) {
//        if self.image != nil {
//            self.alpha = 1
//            return
//        }
//        self.alpha = 0
//        let url = NSURL(string: "https://ssl.webpack.de/lorempixel.com/\(width)/\(height)/")!
//        let configuration = URLSessionConfiguration.default
//        configuration.timeoutIntervalForRequest = 15
//        configuration.timeoutIntervalForResource = 15
//        configuration.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
//        let session = URLSession(configuration: configuration)
//        let task = session.dataTaskWithURL(url as URL, completionHandler: { (data: NSData?, response: URLResponse?, error: NSError?) -> Void in
//            if error != nil {
//                return
//            }
//            
//            if let response = response as? NSHTTPURLResponse {
//                if response.statusCode / 100 != 2 {
//                    return
//                }
//                if let data = data, let image = UIImage(data: data) {
//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        self.image = image
//                        UIView.animateWithDuration(0.3, animations: { () -> Void in
//                            self.alpha = 1
//                            }) { (finished: Bool) -> Void in
//                        }
//                    })
//                }
//            }
//        })
//        task.resume()
//    }
//    
//    func clipParallaxEffect(baseImage: UIImage?, screenSize: CGSize, displayHeight: CGFloat) {
//        if let baseImage = baseImage {
//            if displayHeight < 0 {
//                return
//            }
//            let aspect: CGFloat = screenSize.width / screenSize.height
//            let imageSize = baseImage.size
//            let imageScale: CGFloat = imageSize.height / screenSize.height
//            
//            let cropWidth: CGFloat = floor(aspect < 1.0 ? imageSize.width * aspect : imageSize.width)
//            let cropHeight: CGFloat = floor(displayHeight * imageScale)
//            
//            let left: CGFloat = (imageSize.width - cropWidth) / 2
//            let top: CGFloat = (imageSize.height - cropHeight) / 2
//            
//            let trimRect : CGRect = CGRect(x:left, y:top, width:cropWidth, height:cropHeight)
//            //self.image = baseImage.trim(trimRect: trimRect)
//            self.frame = CGRect(x:0, y:0, width:screenSize.width, height:displayHeight)
//        }
//    }
}
