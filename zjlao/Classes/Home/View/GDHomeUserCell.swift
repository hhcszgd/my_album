//
//  GDHomeUserCell.swift
//  zjlao
//
//  Created by WY on 4/10/17.
//  Copyright © 2017 com.16lao.zjlao. All rights reserved.
//

import UIKit
import SDWebImage
class GDHomeUserCell: UICollectionViewCell {
    let imgView = UIImageView.init()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(imgView)
        self.imgView.image = UIImage(named: "qieziImgPlaceholder")

    }
    var model : BaseControlModel = BaseControlModel(dict: nil){
        willSet{
//            self.imgView.sd_setImage(with: URL(string: newValue.imageUrl!))
            /**
             .sd_setImage(with: urlReal, for: UIControlState.normal, placeholderImage: placePolderImage, options:  [SDWebImageOptions.cacheMemoryOnly , SDWebImageOptions.retryFailed])
             */
            self.imgView.sd_setImage(with: URL(string: newValue.imageUrl ?? ""), placeholderImage: placePolderImage, options:  [SDWebImageOptions.cacheMemoryOnly , SDWebImageOptions.retryFailed]) { (image , error , imageCacheType, url ) in
                
            }
           
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imgView.frame = self.bounds

    }
}
