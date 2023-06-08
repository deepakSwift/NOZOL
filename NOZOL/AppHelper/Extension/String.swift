//
//  StringExtension.swift
//  MyLaundryApp
//
//  Created by TecOrb on 15/12/16.
//  Copyright © 2016 Nakul Sharma. All rights reserved.
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
