//
//  GDTrendsMsgCell.swift
//  zjlao
//
//  Created by WY on 4/9/17.
//  Copyright © 2017 com.16lao.zjlao. All rights reserved.
//

import UIKit
protocol GDTrendsMsgCellDelegate : NSObjectProtocol  {
    func otherIconClick(view : GDTrendsMsgCell)
}
import SDWebImage
class GDTrendsMsgCell: UITableViewCell {

    weak var msgCelldelegate : GDTrendsMsgCellDelegate?
    let otherIcon = UIButton()//UIImageView()
    let mediaIconView = UIImageView()
    let arrowView = UIButton()
    let zanView = UIImageView()
    let redPoint = UIView()
    let descripLbl = UILabel()
    let timeLbl = UILabel()
    let commentLbl = UILabel()
    let bottomLine = UIView()
    var model  : TrendsMsgCellModel?{

        didSet{
            self.setmodel(tempmodel: model)
            /*
            self.myIconView.sd_setImage(with: URL(string: model?.comment_user_avatar ?? ""))
            self.otherIconView.sd_setImage(with: URL(string: model?.media_thumbnail ?? ""))

            var descrip = model?.comment_user_name ?? ""
            var commentOrRecomment = "评论"
            if let type = model?.type {
                if type == "1"  {
                    commentOrRecomment = "评论"
                }else if type == "2"{
                    commentOrRecomment = "回复"
                }
            }
            if let mediaType = model?.media_type {
                if mediaType == "1"  {
                    descrip.append("\(commentOrRecomment)了你的照片")
                }else if mediaType == "2"{
                    descrip.append("\(commentOrRecomment)了你的视频")
                }
            }
            self.descripLbl.text = descrip
            self.commentLbl.text = model?.content ?? ""
            self.timeLbl.text = model?.create_at ?? ""
*/
            
        }
    }
    
    func setmodel(tempmodel:TrendsMsgCellModel?)  {

        self.otherIcon.sd_setImage(with:  URL(string: tempmodel?.comment_user_avatar ?? ""), for: UIControlState.normal, placeholderImage: placePolderImage, options: [SDWebImageOptions.cacheMemoryOnly , SDWebImageOptions.retryFailed]) { (img , error , imageCacheType, url ) in
            
        }
        
      
        
        
        
        
        
        self.mediaIconView.sd_setImage(with: URL(string: tempmodel?.media_thumbnail ?? ""))
        
        var descrip = tempmodel?.comment_user_name ?? ""
        var commentOrRecomment = "评论"
        if let type = tempmodel?.type {
            if type == "1"  {
                commentOrRecomment = "评论"
            }else if type == "2"{
                commentOrRecomment = "回复"
            }
        }
        if let mediaType = tempmodel?.media_type {
            if mediaType == "1"  {
                descrip.append("\(commentOrRecomment)了你的照片")
            }else if mediaType == "2"{
                descrip.append("\(commentOrRecomment)了你的视频")
            }
        }
        self.descripLbl.text = descrip
        self.commentLbl.text = tempmodel?.content ?? ""
        self.timeLbl.text = tempmodel?.create_at ?? ""
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.contentView.addSubview(otherIcon)
        self.contentView.addSubview(mediaIconView)
        self.contentView.addSubview(arrowView)
        self.contentView.addSubview(redPoint)
        redPoint.backgroundColor = UIColor.red
        let redpointW : CGFloat = 10
        redPoint.frame = CGRect(x: SCREENWIDTH - 15, y: 10, width: redpointW, height: redpointW)
        redPoint.layer.cornerRadius = redpointW / 2
//        redPoint.clipsToBounds = true
        redPoint.layer.masksToBounds  = true
        self.contentView.addSubview(descripLbl)
        self.contentView.addSubview(timeLbl)
        self.contentView.addSubview(commentLbl)
        self.contentView.addSubview(zanView)
        self.contentView.addSubview(bottomLine)
        bottomLine.backgroundColor = UIColor.lightGray
        bottomLine.alpha = 0.5
        self.descripLbl.font = GDFont.systemFont(ofSize: 12)
        self.timeLbl.font = GDFont.systemFont(ofSize: 12)
        self.commentLbl.font = GDFont.systemFont(ofSize: 12)
        self.commentLbl.numberOfLines = 2
        self.arrowView.setImage(UIImage(named: "arrowLight"), for: UIControlState.normal)
        self.arrowView.imageEdgeInsets = UIEdgeInsets(top: 17, left: 5, bottom: 17, right: 5  )
        self.zanView.image = UIImage(named: "like_black")
        
        
        self.otherIcon.addTarget(self , action: #selector(otherIconClick(sender:)), for: UIControlEvents.touchUpInside)
        self.otherIcon.contentMode = UIViewContentMode.scaleToFill
        self.mediaIconView.contentMode = UIViewContentMode.scaleToFill
    }
    
    func otherIconClick(sender : UIButton)  {
        self.msgCelldelegate?.otherIconClick(view: self )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        self.setmodel(tempmodel: model)
        let margin : CGFloat = 5.0
        let lineH : CGFloat = 1.0
        let cellH = self.frame.size.height
        let cellW = self.frame.size.width
        let iconW = cellH - lineH - margin * 2
        self.bottomLine.frame = CGRect(x: 0 , y: cellH - lineH, width: cellW , height: lineH)
        self.otherIcon.frame = CGRect(x: margin , y: margin, width: iconW , height: iconW)
        self.arrowView.frame = CGRect(x: cellW  - iconW * 0.6 , y: margin, width: iconW * 0.6 , height: iconW)
        
        self.mediaIconView.frame = CGRect(x: cellW  - self.arrowView.bounds.size.width - iconW  , y: margin, width: iconW , height: iconW)
        self.timeLbl.sizeToFit()
        let timeSize = self.timeLbl.bounds.size
        self.timeLbl.frame = CGRect(x: self.mediaIconView.frame.minX - timeSize.width - margin   , y: margin, width: timeSize.width , height: timeSize.height)
        self.descripLbl.sizeToFit()
        let descripSize = self.descripLbl.bounds.size
        self.descripLbl.frame = CGRect(x: self.otherIcon.frame.maxX + margin   , y: margin, width: self.timeLbl.frame.minX - (self.otherIcon.frame.maxX + margin)  , height: descripSize.height)
        
        self.commentLbl.frame = CGRect(x: self.otherIcon.frame.maxX + margin   , y: self.descripLbl.frame.maxY + margin, width: self.mediaIconView.frame.minX - (self.otherIcon.frame.maxX + margin)  , height: self.bottomLine.frame.minY - (self.descripLbl.frame.maxY + margin))
        
        self.zanView.frame = CGRect(x: self.otherIcon.frame.maxX + margin   , y: self.descripLbl.frame.maxY + margin , width: 20  , height: 20)
        if self.model?.is_good == "1" {
            self.zanView.isHidden = false
        }else{
            self.zanView.isHidden = true
        }
        if self.model?.status ?? "0" == "0" {
            self.redPoint.isHidden = false
        }else{
            self.redPoint.isHidden = true
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
