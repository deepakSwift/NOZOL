//
//  NOZOL
//
//  Created by Mukul Sharma on 14/07/20.
//  Copyright © 2020 Mukul Sharma. All rights reserved.
//

import Foundation

extension String {
//    static func className(aClass: AnyClass) -> String {
//        return NSStringFromClass(aClass).componentsSeparated(by: ".").last!
//    }
//    
//    func substring(from: Int) -> String {
//        return self.substring(from: self.startIndex.advancedBy(from))
//    }
//    
//    var length: Int {
//        return self.characters.count
//    }
    var chomp : String {
        mutating get {
            self.remove(at: self.startIndex)
            return self
        }
    }
    
    
    var numbers: String {
           return filter { "0"..."9" ~= $0 }
       }
}

/*============== LOCALIZATION ==================*/

extension String {
    func localizableString(loc: String) -> String {
        let path = Bundle.main.path(forResource: loc, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}
