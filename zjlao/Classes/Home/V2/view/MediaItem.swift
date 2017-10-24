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
    override init(frame: CGRect) {
        super.init(frame: frame )
        self.contentView.addSubview(imgView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var model : MediaModel = MediaModel(dict : nil ){
        didSet{
            if let url = URL(string : model.thumbnail){
                self.imgView.sd_setImage(with: url , placeholderImage: UIImage(named:"bg_nohead"), options: [SDWebImageOptions.retryFailed])
            }
            
            self.layoutIfNeeded()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imgView.snp.remakeConstraints { (make ) in
            make.left.right.bottom.top.equalToSuperview()
        }
    }
}
