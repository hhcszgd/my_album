//
//  UIColor+Extension.swift
//  Weibo
//
//  Created by apple on 15/11/30.
//  Copyright © 2015年 mac. All rights reserved.
//

import UIKit

extension UIColor {
    ///hexString 参数标准 : "#ffffff"
    public convenience init?(hexString: String) {
        
        if hexString.hasPrefix("#") {
            let start = hexString.characters.index(hexString.startIndex, offsetBy: 1)
            let Str = hexString.substring(from: start)
            
            if Str.characters.count == 6 {
                // 分别转换进行转换
                let redStr = (Str as NSString ).substring(to: 2)
                         let greenStr = ((Str as NSString).substring(from: 2) as NSString).substring(to: 2)
                         let blueStr = ((Str as NSString).substring(from: 4) as NSString).substring(to: 2)
                         var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
                         Scanner(string:redStr).scanHexInt32(&r)
                         Scanner(string: greenStr).scanHexInt32(&g)
                         Scanner(string: blueStr).scanHexInt32(&b)
                          self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1)
                return
            }
        }
        
        return nil
    }
    
    
    
    
    
    class func randomColor() -> UIColor {
        
//        let r = CGFloat(random() % 255) / 255.0
//        let g = CGFloat(random() % 255) / 255.0
//        let b = CGFloat(random() % 255) / 255.0
        let r = CGFloat(arc4random_uniform(225)) / 255.0
        let g = CGFloat(arc4random_uniform(225)) / 255.0
        let b = CGFloat(arc4random_uniform(225)) / 255.0
        let randomColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        
        return randomColor
    }
    
  }
