//
//  GDMediaSectionHeader.swift
//  zjlao
//
//  Created by WY on 14/07/2017.
//  Copyright © 2017 com.16lao.zjlao. All rights reserved.
//


import UIKit
protocol GDMediaSectionHeaderDelete : NSObjectProtocol {
    func zanClick(mediaID:String)
    func commentClick(mediaID:String)
    func deleteClick(mediaID:String)
    func seeMoreCmmments(mediaID:String)
    func bigImageClick(mediaID:String)
    func bigImageClickToImageBrowser(model  : GDCircleDetailCellModel)
    func gotoUserDetail(userID:String )
    
}

class GDMediaSectionHeader: UITableViewHeaderFooterView {
    let  backColor = UIColor(red: 240 / 256, green:  240 / 256, blue:  240 / 256, alpha: 1)
    
    let videoIcon = UIImageView(image: UIImage(named : "VideoOverlayPlay")/*?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)*/)
    var isVideo  = false
    
    weak var cellDelegate : GDMediaSectionHeaderDelete?
    
    let bigImageView : UIButton = UIButton.init(frame: CGRect.zero)
    let zanBtn  = UIButton()
    let zanCount = UILabel()
    let commentBtn = UIButton()
    let deleteBtn = UIButton()
    let ownerIcon = UIButton()
    let ownerName = UILabel()
    let arrowView = UIImageView(image: UIImage(named:"sanjiao"))
    let descripLabel = UILabel()
    let creatTime = UILabel()
    let zanContainer = UIView()
    let line = UIView()
    let lineBottomOfDescrip = UIView()
    let lineBottomOfZanbtn = UIView()
    
    var model  : GDCircleDetailCellModel?{
        didSet{
            self.ownerIcon.sd_setImage(with: URL(string: model?.avatar ?? ""), for: UIControlState.normal)
            
            self.bigImageView.sd_setImage(with: URL(string: model?.original ?? ""), for: UIControlState.normal)
            if let format = model?.format {
                if format == "jpeg" || format == "jpg" || format == "png" {
                    self.isVideo  = false
                }else if format == "MOV" || format == "mp4" || format == "avi" {
                    self.isVideo  = true
                }else{
                    self.isVideo  = false
                }
            }
            
            if let num  = model?.good_count {
                self.zanCount.text  = "\(num)"
            }else{
                self.zanCount.text =  ""
            }
            
            self.ownerName.text = " " + (model?.name ?? "")
            
            
            
            
            
            
            
//            self.creatTime.text = (model?.city ?? "" ) + " " + (model?.create_at ?? "") + "\t "
            if(UIScreen.main.bounds.size.height == 480){//5,5s,5c不变
                //            self.seeMoreBtn.titleLabel?.adjustsFontSizeToFitWidth = true
                self.creatTime.font = UIFont.systemFont(ofSize: 10)
            }
            
            let attriStr = NSMutableAttributedString.init(string: "")
            let attachCity = NSTextAttachment()
            attachCity.image = UIImage.init(named: "mediaDetaillocation")
            let attachCityStr = NSAttributedString.init(attachment: attachCity)
            attachCity.bounds = CGRect(x: 0, y: -self.creatTime.font.lineHeight * 0.2, width: self.creatTime.font.lineHeight , height: self.creatTime.font.lineHeight)
            attriStr.append(attachCityStr)
            let city : NSAttributedString = NSAttributedString.init(string:model?.city ?? "" )
            attriStr.append(city )
            
            let space : NSAttributedString = NSAttributedString(string: "    ")
            attriStr.append(space )
            let attachTime = NSTextAttachment()
            attachTime.image = UIImage.init(named: "mediaDetailTime")
            attachTime.bounds = CGRect(x: 0, y: -self.creatTime.font.lineHeight * 0.2, width: self.creatTime.font.lineHeight , height: self.creatTime.font.lineHeight)
            let attachTimeStr = NSAttributedString.init(attachment: attachTime)
            attriStr.append(attachTimeStr)
            let time : NSAttributedString = NSAttributedString.init(string: " " + (model?.create_date/*create_at*/ ?? "" ))
            attriStr.append(time )
            self.creatTime.attributedText = attriStr
            

            
            
            
            
            for subview in self.zanContainer.subviews {
                subview.removeFromSuperview()
            }
            self.zanContainer.addSubview(UIImageView(image: UIImage(named:"like_black")))
            for zanModel in model?.goods ?? [] {
                let zan = GDZanUser()
                
                zan.model = zanModel
                zan.addTarget(self , action: #selector(zanUserClick(sender:)), for: UIControlEvents.touchUpInside)
                self.zanContainer.addSubview(zan)
            }
            
            self.layoutIfNeeded()
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubViews()  {
        self.contentView.addSubview(bigImageView)
        bigImageView.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        
        bigImageView.setImage(UIImage(named:"qieziImgPlaceholder"), for: UIControlState.normal)
        bigImageView.adjustsImageWhenHighlighted = false
        bigImageView.addTarget(self , action: #selector(bigImageClick(sender:)), for: UIControlEvents.touchUpInside)
        self.contentView.addSubview(videoIcon)
        self.contentView.addSubview(zanBtn)
        self.videoIcon.contentMode = UIViewContentMode.scaleAspectFit
        
        zanBtn.setImage(UIImage(named: "like_black"), for: UIControlState.normal)
        zanBtn.setTitle(" 赞", for: UIControlState.normal)
        self.contentView.addSubview(zanCount)
        zanCount.textAlignment = NSTextAlignment.center
        zanBtn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        
        self.contentView.addSubview(commentBtn)
        commentBtn.setImage(UIImage(named: "comment"), for: UIControlState.normal)
        commentBtn.setTitle(" 评论", for: UIControlState.normal)
        commentBtn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        self.contentView.addSubview(deleteBtn)
        deleteBtn.setImage(UIImage(named : "shareButton"), for: UIControlState.normal)
        self.contentView.addSubview(ownerIcon)
        deleteBtn.setTitle("分享", for: UIControlState.normal)
        // MARK: 注释 : 暂时隐藏分享
        //deleteBtn.isHidden = true
        deleteBtn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        ownerIcon.addTarget(self , action: #selector(commentUserClick(sender:)), for: UIControlEvents.touchUpInside)
        self.contentView.addSubview(ownerName)
        self.contentView.addSubview(descripLabel)
        self.contentView.addSubview(arrowView)
        descripLabel.font = GDFont.systemFont(ofSize: 14)
        descripLabel.textColor = UIColor.darkGray
        
        descripLabel.backgroundColor = UIColor.white
        self.contentView.addSubview(lineBottomOfDescrip)
//        ownerName.backgroundColor =  self.backColor
        ownerName.font = GDFont.systemFont(ofSize: 14)
        self.contentView.addSubview(creatTime)
//        self.creatTime.backgroundColor =  self.backColor
        creatTime.font = self.ownerName.font
        self.creatTime.textAlignment = NSTextAlignment.left
        
        self.zanBtn.addTarget(self , action: #selector(zanClick(sender:)), for: UIControlEvents.touchUpInside)
        self.commentBtn.addTarget(self , action: #selector(commentClick(sender:)), for: UIControlEvents.touchUpInside)
        self.deleteBtn.addTarget(self , action: #selector(deleteClick(sender:)), for: UIControlEvents.touchUpInside)
        self.contentView.addSubview(lineBottomOfZanbtn)
         self.zanBtn.backgroundColor = UIColor.white
        self.commentBtn.backgroundColor = UIColor.white
        self.deleteBtn.backgroundColor = UIColor.white
        
        self.contentView.addSubview(self.zanContainer)
        self.zanContainer.backgroundColor = self.backColor
        self.contentView.addSubview(line)
        line.backgroundColor = UIColor(red: 230 / 256, green:  230 / 256, blue:  230 / 256, alpha: 1)
        
        self.lineBottomOfDescrip.backgroundColor =  UIColor(red: 240 / 256, green:  240 / 256, blue:  240 / 256, alpha: 1)

        self.lineBottomOfZanbtn.backgroundColor =  UIColor(red: 240 / 256, green:  240 / 256, blue:  240 / 256, alpha: 1)

    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let margin : CGFloat = 5.0 //00
        let iconW  : CGFloat = 64//11
        let bigImgW = SCREENWIDTH // 22
        
//        if model?.mine == 1 {
//            self.ownerIcon.frame = CGRect(x: SCREENWIDTH - iconW, y: 0, width: iconW, height: iconW)
//        }else{
            self.ownerIcon.frame = CGRect(x: margin, y: margin, width: iconW, height: iconW)
//        }
        

        self.bigImageView.frame = CGRect(x: 0, y: iconW + margin * 2 , width: bigImgW, height: bigImgW)
        self.videoIcon.bounds = CGRect(x: 0, y: 0, width: 44, height: 44)
        self.videoIcon.center = self.bigImageView.center
        if self.isVideo {
            self.videoIcon.isHidden = false
        }else{
            self.videoIcon.isHidden = true
        }
        let discripH : CGFloat = 30//33
        self.descripLabel.frame = CGRect(x: 0 , y: bigImageView.frame.maxY, width: bigImgW , height: discripH)

        let lineBottomOfDescripH = margin //44
        
        var zanY = bigImageView.frame.maxY + lineBottomOfDescripH
        let zanH : CGFloat = 44 //55
        if !(self.model?.descrip?.isEmpty ?? true)   && self.model?.descrip?.characters.count ?? 0 > 0{
            self.descripLabel.isHidden = false
            self.lineBottomOfDescrip.frame = CGRect(x: 0 , y: descripLabel.frame.maxY, width: bigImgW , height: lineBottomOfDescripH)//
            self.descripLabel.text =  " " + (self.model?.descrip)!
        }else{
            self.lineBottomOfDescrip.frame = CGRect(x: 0 , y: bigImageView.frame.maxY, width: bigImgW , height: lineBottomOfDescripH)//
            self.descripLabel.isHidden = true
        }
        
        zanY = self.lineBottomOfDescrip.frame.maxY
        
        
        self.zanBtn.frame = CGRect(x:  0, y: zanY  , width: SCREENWIDTH / 3, height: zanH)//55
//        self.zanCount.frame = CGRect(x: SCREENWIDTH / 3 , y: zanY , width: SCREENWIDTH / 3 , height: zanH)
        
        
        self.commentBtn.frame = CGRect(x: SCREENWIDTH / 3 , y: zanY , width: SCREENWIDTH / 3 , height: zanH)
        
        
        self.deleteBtn.frame =  CGRect(x: SCREENWIDTH / 3 * 2, y: zanY, width: SCREENWIDTH / 3, height: zanH)
//        self.deleteBtn.isHidden = self.model?.mine == 1 ? false : true
        
//        let lineBottomOfZanbtnH  = margin //66
        
        self.lineBottomOfZanbtn.frame = CGRect(x: 0, y: self.zanBtn.frame.maxY, width: SCREENWIDTH, height: margin)
        
        
        let nameH  : CGFloat = 30
        self.ownerName.frame = CGRect(x: ownerIcon.frame.maxX + margin , y: ownerIcon.frame.minY + margin * 0.3 , width: bigImgW / 2, height: nameH)
        self.creatTime.frame  = CGRect(x: self.ownerName.frame.minX, y: self.ownerName.frame.maxY  , width: bigImgW / 2, height: nameH)
        let arrowViewH : CGFloat = 8.0//77
        self.arrowView.frame = CGRect(x: margin + 10.0, y: lineBottomOfZanbtn.frame.maxY, width: 12.0, height: arrowViewH)
        
//        var zanContainerW = bigImgW
//        var zanContainerH : CGFloat = 0
//        let verticalMargin : CGFloat = 10
//        let horizontalMargin : CGFloat = 10
//        
//        
        
        self.zanContainer.frame = CGRect.zero
        let zanContainerMaxW :CGFloat = SCREENWIDTH - margin * 2
        
        var currentW : CGFloat = margin
        var currentH : CGFloat = margin
        
        if self.model?.goods?.count ?? 0 > 0  {
            self.zanContainer.isHidden = false
            var zanitemH : CGFloat = 0
            for (index ,subView) in self.zanContainer.subviews.enumerated() {
                if let zanLogo = subView as? UIImageView {
                    zanLogo.contentMode = UIViewContentMode.scaleAspectFit
                    zanLogo.frame =  CGRect(x: margin , y: margin  , width: 14, height:14 )
                    currentW += (margin + 14)
                }
                if let zanView = subView as? GDZanUser {
                    zanitemH = zanView.bounds.size.height
                    let tempmodel =  model?.goods?[index-1]
                    //                    tempmodel?.switchState = true
                    zanView.model = tempmodel
                    if zanView.bounds.size.width > zanContainerMaxW - currentW - margin {
                        currentH += (zanView.bounds.size.height + margin)
                        currentW = margin
                        if index == (self.model?.goods?.count ?? 0) {
                            tempmodel?.switchState = false
                        }else{
                            tempmodel?.switchState = true
                        }
                        zanView.model = tempmodel
                        zanView.frame = CGRect(x: currentW, y: currentH, width: zanView.bounds.size.width, height: zanView.bounds.size.height)
                        
                        currentW += (zanView.bounds.size.width + margin)
                    }else{
                        if index == (self.model?.goods?.count ?? 0) {//隐藏最后一个人得逗号
                            tempmodel?.switchState = false
                        }else{
                            tempmodel?.switchState = true
                        }
                        //                        if currentW == margin  {//隐藏行尾人后面的逗号
                        //                            let tempmodel2 =  model?.goods?[index-1]
                        //                            tempmodel2?.switchState = false
                        //                            if let priviousZanview = self.zanContainer.subviews[index - 2] as? GDZanUser{
                        //                                priviousZanview.model = tempmodel2
                        //                            }
                        //                        }
                        if currentW == margin  {//隐藏上一行行尾人后面的逗号
                            let tempmodel2 =  model?.goods?[index-2]
                            tempmodel2?.switchState = false
                            if let priviousZanview = self.zanContainer.subviews[index - 1] as? GDZanUser{
                                priviousZanview.model = tempmodel2
                            }
                        }
                        
                        
                        zanView.frame = CGRect(x: currentW , y: currentH   , width: zanView.bounds.size.width, height: zanView.bounds.size.height)
                        currentW += (zanView.bounds.size.width + margin)
                        
                        zanView.model = tempmodel
                    }
                }
            }
            currentH += (zanitemH + margin)//88
            self.zanContainer.frame = CGRect(x: margin , y: self.arrowView.frame.maxY, width: zanContainerMaxW, height: currentH  )//容器
            self.line.frame = CGRect(x: self.zanContainer.frame.minX, y: self.zanContainer.frame.maxY, width: self.zanContainer.frame.size.width, height: 1  )//容器
            self.zanContainer.isHidden = false
            self.arrowView.isHidden = false
            if model?.comments?.count ?? 0  > 0  {
                self.line.isHidden =  false
                
            }else{
                self.line.isHidden =  true
            }
        }else{
            self.line.isHidden =  true
            self.zanContainer.isHidden = true
            self.arrowView.isHidden =  self.model?.comments?.count ?? 0 > 0 ? false : true
        }
        
        
        
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    func zanClick(sender:UIButton)  {
        self.cellDelegate?.zanClick(mediaID: self.model?.id ?? "0")
    }
    func zanUserClick(sender : GDZanUser)  {
        mylog("点击点赞的人")
        if let userID = sender.model?.additionalTitle {
            self.cellDelegate?.gotoUserDetail(userID: userID)
        }
    }
    func commentClick(sender:UIButton) {
        self.cellDelegate?.commentClick(mediaID: self.model?.id ?? "0")
    }
    func deleteClick(sender:UIButton)  {
//        self.cellDelegate?.deleteClick(mediaID: self.model?.id ?? "0")
         self.cellDelegate?.deleteClick(mediaID: self.createTheUrlstrWillBeShare())
    }
    func createTheUrlstrWillBeShare() -> String {
        //      http://www.123qz.cn/share.php?media_id=123i38434&token=md5(媒体ID+用户ID+创建时间+token)
        let paramete = (self.model?.id ?? ""  ) + (self.model?.user_id  ?? "") + (self.model?.create_date ?? "") // + (GDNetworkManager.shareManager.token ?? "")
        mylog(paramete)
        let md5Str = paramete.md5() ?? ""
        let mediaID = self.model?.id ?? "0"
        let shareString = "http://www.123qz.cn/share?" + "media_id=" + mediaID + "&token=" + md5Str
//        self.cellDelegate?.shareClick(mediaID: shareString)
        return shareString
    }
    func commentUserClick(sender : UIButton)  {
        mylog("点击点赞的人")
        if let userID = self.model?.user_id {
            self.cellDelegate?.gotoUserDetail(userID: userID)
        }
    }
    // MARK: 注释 : 进入图片浏览器  新/旧
    func bigImageClick(sender:UIButton)  {
        //self.cellDelegate?.bigImageClick(mediaID: self.model?.id ?? "0")
        if let realModel = model {
            
            self.cellDelegate?.bigImageClickToImageBrowser(model: realModel)
        }
    }
    
}
