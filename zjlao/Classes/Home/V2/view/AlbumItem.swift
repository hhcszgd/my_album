//
//  AlbumItem.swift
//  zjlao
//
//  Created by WY on 2017/10/24.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//
import UIKit
import SDWebImage
import SnapKit
class AlbumItem: UICollectionViewCell {
    let imgView = UIImageView()
    let albumName = UILabel()
    let mediaCount = UILabel()
    let memberCount = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.97, alpha: 1)
        self.contentView.addSubview(imgView )
        self.contentView.addSubview(albumName )
        self.contentView.addSubview(mediaCount )
        self.contentView.addSubview(memberCount )
        memberCount.textAlignment = NSTextAlignment.right
        memberCount.textColor = UIColor.lightGray
        albumName.textColor = memberCount.textColor
        mediaCount.textColor = memberCount.textColor
        memberCount.font = UIFont.systemFont(ofSize: 14)
        albumName.font = memberCount.font
        mediaCount.font = memberCount.font
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var model  : AlbumModel = AlbumModel(dict:nil ){
        didSet{
            if let url = URL(string : model.album_image){
                self.imgView.sd_setImage(with: url , placeholderImage: UIImage(named:"bg_nohead"), options: [SDWebImageOptions.retryFailed])
            }else{
                self.imgView.image = UIImage(named:"bg_nohead")
            }
            albumName.text = model.album_name
            
            let attachment = NSTextAttachment.init()
            attachment.image = UIImage(named:"member_icon")
            attachment.bounds = CGRect(x: 0, y: -memberCount.font.lineHeight * 0.2, width: memberCount.font.lineHeight, height: memberCount.font.lineHeight)
            let attributeStr = NSMutableAttributedString.init()
            attributeStr.append(NSAttributedString(attachment: attachment))
            attributeStr.append(NSAttributedString(string: "\(model.album_member_count)"))
            memberCount.attributedText = attributeStr
//            memberCount.text = "\(model.album_member_count) 人"
            mediaCount.text = "\(model.media_count)" + "张"
            self.layoutIfNeeded()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imgView.snp.remakeConstraints { (make ) in
            make.left.top.equalToSuperview().offset(10)
            make.width.height.equalTo(self.contentView.bounds.size.width - 10 * 2)
        }
        self.mediaCount.snp.remakeConstraints { (make ) in
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo((self.contentView.bounds.width - 20) / 2)
            make.height.equalTo(18)
        }
        self.memberCount.snp.remakeConstraints { (make ) in
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo((self.contentView.bounds.width - 20) / 2)
            make.height.equalTo(18)
        }
        self.albumName.snp.remakeConstraints { (make ) in
            make.left.equalTo(mediaCount)
            make.right.equalTo(memberCount)
            make.bottom.equalTo(mediaCount.snp.top)
            make.height.equalTo(18)
        }
    }
}
