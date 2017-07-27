//
//  GDButton.swift
//  zjlao
//
//  Created by WY on 22/04/2017.
//  Copyright © 2017 com.16lao.zjlao. All rights reserved.
//

import UIKit
import SDWebImage
class GDButton: UIButton {
    var urlStr : String?{
        willSet{
            if let urlString = newValue {
                self.sd_setBackgroundImage(with: <#T##URL!#>, for: <#T##UIControlState#>, placeholderImage: <#T##UIImage!#>, options: <#T##SDWebImageOptions#>, completed: <#T##SDWebImageCompletionBlock!##SDWebImageCompletionBlock!##(UIImage?, Error?, SDImageCacheType, URL?) -> Void#>)
                self.sd_setImageWithPreviousCachedImage(with: URL(string: urlString), placeholderImage: placePolderImage, options: SDWebImageOptions.cacheMemoryOnly, progress: { (received, total ) in
                    
                }) { (image, error, imageCacheType, url) in
                    
                }
            }else{
                
            }
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
