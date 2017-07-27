//
//  GDCollectionImageCell.swift
//  zjlao
//
//  Created by WY on 17/4/5.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit
import SDWebImage
class GDCollectionImageCell: UICollectionViewCell {
    let imgView = UIImageView.init()
    let videoIcon = UIImageView(image: UIImage(named : "VideoCameraPreview"))//?.withRenderingMode(UIImageRenderingMode.alwaysTemplate))
    var isVideo  = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(imgView)
        self.imgView.image = UIImage(named: "qieziImgPlaceholder")
        self.contentView.addSubview(videoIcon)
        self.videoIcon.contentMode = UIViewContentMode.scaleAspectFit
    }
    var model : BaseControlModel = BaseControlModel(dict: nil){
        didSet{
//            self.imgView.sd_setImage(with: URL(string: newValue.subImageUrl!))
            
//            if let imgUrl = newValue.imageUrl {
//                if imgUrl.hasSuffix("jpeg") {
//                        self.isVideo  = false
//                }else{
//                    self.isVideo  = true
//                }
//            }
            
            if let formate = model.extensionTitle2 {
                if formate == "jpeg" || formate == "png" || formate == "jpg" {
                        self.isVideo  = false
                }else if formate == "MOV" || formate == "mp4" || formate == "avi" {
                    self.isVideo  = true
                }else{
                    self.isVideo  = false
                }
            }
            
            self.imgView.sd_setImage(with: URL(string: model.subImageUrl ?? ""), placeholderImage: UIImage(named: "qieziImgPlaceholder"), options: [SDWebImageOptions.cacheMemoryOnly , SDWebImageOptions.retryFailed])
            self.setNeedsLayout()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imgView.frame = self.bounds
        if self.isVideo {
            self.videoIcon.isHidden = false
            self.videoIcon.frame = CGRect(x: 5, y: self.bounds.size.height - 18 , width: 20, height: 20)
        }else{
            self.videoIcon.isHidden = true
        }
    }
}
