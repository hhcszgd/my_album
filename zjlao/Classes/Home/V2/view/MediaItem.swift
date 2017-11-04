//
//  MediaItem.swift
//  zjlao
//
//  Created by WY on 2017/10/24.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit
import SDWebImage
import SnapKit
class MediaItem: UICollectionViewCell {
    let imgView = UIImageView.init()
    let videoIcon = UIImageView(image: UIImage(named : "VideoOverlayPlay")/*?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)*/)

    override init(frame: CGRect) {
        super.init(frame: frame )
        self.contentView.addSubview(imgView)
        self.contentView.addSubview(videoIcon)
        videoIcon.isUserInteractionEnabled = true
        videoIcon.isHidden = true
        videoIcon.bounds = CGRect(x: 0, y: 0, width: 44, height: 44)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var model : MediaModel = MediaModel(dict : nil ){
        didSet{
            if let url = URL(string : model.thumbnail){
                self.imgView.sd_setImage(with: url , placeholderImage: UIImage(named:"bg_nohead"), options: [SDWebImageOptions.retryFailed])
            }
            if model.media_type == 2{//movie
                self.videoIcon.isHidden = false
            }else{//image
                self.videoIcon.isHidden = true
            }
            self.layoutIfNeeded()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imgView.snp.remakeConstraints { (make ) in
            make.left.right.bottom.top.equalToSuperview()
        }
        videoIcon.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
    }
}
