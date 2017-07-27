//
//  GDCommentShort.swift
//  zjlao
//
//  Created by WY on 19/04/2017.
//  Copyright © 2017 com.16lao.zjlao. All rights reserved.
//

import UIKit
import SDWebImage
class GDCommentShort: GDBaseControl {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.button)
        self.addSubview(self.titleLabel)
        self.addSubview(self.subTitleLabel)
        self.subTitleLabel.numberOfLines = 2
        self.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        self.subTitleLabel.backgroundColor = UIColor.clear
//        self.button.image = UIImage(named: "qieziImgPlaceholder")
    }
    var model : BaseControlModel?{
        willSet{
            self.button.sd_setImage(with: URL(string: newValue?.imageUrl ?? ""), for: UIControlState.normal, placeholderImage: UIImage(named: "qieziImgPlaceholder"), options: [SDWebImageOptions.cacheMemoryOnly , SDWebImageOptions.retryFailed]) { (img , error , imageCacheType, url ) in
                
            }
            self.titleLabel.text = newValue?.title
            self.subTitleLabel.text = newValue?.subTitle
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.button.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        self.titleLabel.frame = CGRect(x: self.button.frame.maxX + 10, y: self.button.frame.minY, width: 100, height: 17)
        self.subTitleLabel.frame = CGRect(x: self.button.frame.maxX + 10, y: self.titleLabel.frame.maxY, width: self.bounds.size.width - 44, height: self.bounds.size.height - self.titleLabel.bounds.size.height)

    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
/*
 //
 //  GDCommentShort.swift
 //  zjlao
 //
 //  Created by WY on 19/04/2017.
 //  Copyright © 2017 com.16lao.zjlao. All rights reserved.
 //
 
 import UIKit
 import SDWebImage
 class GDCommentShort: GDBaseControl {
 override init(frame: CGRect) {
 super.init(frame: frame)
 self.addSubview(self.button)
 self.addSubview(self.titleLabel)
 self.addSubview(self.subTitleLabel)
 self.subTitleLabel.numberOfLines = 2
 //        self.button.image = UIImage(named: "qieziImgPlaceholder")
 }
 var model : BaseControlModel?{
 willSet{
 self.button.sd_setImage(with: URL(string: newValue?.imageUrl ?? ""), for: UIControlState.normal, placeholderImage: UIImage(named: "qieziImgPlaceholder"), options: [SDWebImageOptions.cacheMemoryOnly , SDWebImageOptions.retryFailed]) { (img , error , imageCacheType, url ) in
 
 }
 self.titleLabel.text = newValue?.title
 self.subTitleLabel.text = newValue?.subTitle
 }
 }
 
 required init?(coder aDecoder: NSCoder) {
 fatalError("init(coder:) has not been implemented")
 }
 override func layoutSubviews() {
 super.layoutSubviews()
 self.button.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
 self.titleLabel.frame = CGRect(x: self.button.frame.maxX + 10, y: self.button.frame.minY, width: 100, height: 17)
 self.subTitleLabel.frame = CGRect(x: self.button.frame.maxX + 10, y: self.titleLabel.frame.maxY, width: self.bounds.size.width - 44, height: self.bounds.size.height - self.titleLabel.bounds.size.height)
 
 }
 /*
 // Only override draw() if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 override func draw(_ rect: CGRect) {
 // Drawing code
 }
 */
 
 }

 */
