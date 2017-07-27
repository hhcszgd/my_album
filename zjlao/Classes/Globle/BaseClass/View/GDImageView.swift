//
//  GDImageView.swift
//  zjlao
//
//  Created by WY on 22/04/2017.
//  Copyright © 2017 com.16lao.zjlao. All rights reserved.
//

import UIKit
import SDWebImage
class GDImageView: UIImageView {

    var urlStr : String?{
        willSet{
            if let urlString = newValue {
                self.sd_setImageWithPreviousCachedImage(with: URL(string: urlString), placeholderImage: placePolderImage, options: SDWebImageOptions.cacheMemoryOnly, progress: { (received, total ) in
                    
                }) { (image, error, imageCacheType, url) in
                    
                }
            }else{
                
            }
        }
    }
    
    override init(frame: CGRect) {
       super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
