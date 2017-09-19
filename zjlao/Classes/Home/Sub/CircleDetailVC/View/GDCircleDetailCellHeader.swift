//
//  GDCircleDetailCellHeader.swift
//  zjlao
//
//  Created by WY on 09/06/2017.
//  Copyright © 2017 com.16lao.zjlao. All rights reserved.
//

import UIKit
protocol GDCircleDetailCellHeaderDelete : NSObjectProtocol {
    func zanClick(mediaID:String)
    func commentClick(mediaID:String)
    func deleteClick(mediaID:String)
    func seeMoreCmmments(mediaID:String)
    func bigImageClick(mediaID:String)
    func bigImageClickToImageBrowser(model  : GDCircleDetailCellModel)
    func gotoUserDetail(userID:String )
    func perforReport(mediaID : String , reporterID : String)
    func blockSomeoneSuccess()
    
}

class GDCircleDetailCellHeader: UITableViewHeaderFooterView {
    let  backColor = UIColor(red: 240 / 256, green:  240 / 256, blue:  240 / 256, alpha: 1)

    let videoIcon = UIImageView(image: UIImage(named : "VideoOverlayPlay")/*?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)*/)
    var isVideo  = false
    
    weak var cellDelegate : GDCircleDetailCellHeaderDelete?

    let bigImageView : UIButton = UIButton.init(frame: CGRect.zero)
    let zanBtn  = UIButton()
    let zanCount = UILabel()
    let commentBtn = UIButton()
    let deleteBtn = UIButton()
    let ownerIcon = UIButton()
    var longPress : UILongPressGestureRecognizer?
    var alertvc : UIAlertController?
    
    let ownerName = UILabel()
    let arrowView = UIImageView(image: UIImage(named:"sanjiao"))
    let descripLabel = UILabel()
    let creatTime = UILabel()
    let zanContainer = UIView()
    let line = UIView()
    let reportBtn = UIButton()
    
    var model  : GDCircleDetailCellModel?{
        didSet{
            mylog("xxxxxxxxxxxxxxxxxxxx\(String(describing: model?.my_good))")
            self.zanBtn.isEnabled = model?.my_good == 1 ?   false : true
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
            let prefixStr = (model?.city ?? "" ) + " " + (model?.create_at ?? "")
            self.creatTime.text = prefixStr  + "\t "
            for subview in self.zanContainer.subviews {
                subview.removeFromSuperview()
            }
            self.zanContainer.addSubview(UIImageView(image: UIImage(named:"like_black")))
            for zanModel in model?.goods ?? [] {
                let zan = GDZanUser()
                
                zan.model = zanModel
                mylog("点赞人模型赋值时姓名列表:\(String(describing: zanModel.title))")
                zan.addTarget(self , action: #selector(zanUserClick(sender:)), for: UIControlEvents.touchUpInside)
                self.zanContainer.addSubview(zan)
            }

            self.layoutIfNeeded()
        }
    }
    func setupLongPress()  {
        let longpress = UILongPressGestureRecognizer.init(target: self , action: #selector(alertMessage))
        self.longPress = longpress
        self.ownerIcon.addGestureRecognizer(longpress)
    }
    @objc func alertMessage()  {
//        print(self.alertvc)
        if self.model?.mine ?? 0 == 1 {
            return
        }
        if  self.alertvc == nil  {
            let alertvc = UIAlertController.init(title: "屏蔽[\(self.model?.name ?? "此人")]", message: nil , preferredStyle: UIAlertControllerStyle.alert)
            let action0 = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.default) { (action ) in
                alertvc.dismiss(animated: true , completion:{
                    
                })
                self.alertvc = nil
            }
            let action = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default) { (action ) in
                
                alertvc.dismiss(animated: false  , completion:{
                    
                })
                self.alertvc = nil
                
                self.perforReport(mediaID:self.model?.name ?? "", reporterID: "")////
            }
            alertvc.addAction( action0 )
            alertvc.addAction(action)
            self.alertvc = alertvc
            GDKeyVC.share.present(alertvc, animated: true , completion: nil )
            mylog("长按else")
        }
        
        
    }
    /**拉黑*/
    
    func perforReport(mediaID : String , reporterID : String){
        
        
        GDNetworkManager.shareManager.block(userID: self.model?.user_id ?? "", { (dataModel) in
            print(dataModel.status)
//            print(dataModel.data)
            if dataModel.status == 200{
//                GDAlertView.alert("成功加入黑名单", image: nil , time: 2, complateBlock: nil)
                self.cellDelegate?.blockSomeoneSuccess()
            }else{
                GDAlertView.alert("操作失败", image: nil , time: 2, complateBlock: nil)
            }
        }) { (error ) in
            GDAlertView.alert("操作失败", image: nil , time: 2, complateBlock: nil)
        }
        
//        GDNetworkManager.shareManager.report(mediaID: mediaID, { (model ) in
//            mylog(model.status)
//            var tips = ""
//            switch model.status {
//            case 200 :
//                tips = "举报成功,等待审核"
//            case 350 :
//                tips = "请勿重复举报"
//            default :
//                tips = "未知错误"
//            }
//            GDAlertView.alert(tips, image: nil , time: 2, complateBlock: nil)
//        }) { (error ) in
//            GDAlertView.alert( "未知错误", image: nil , time: 2, complateBlock: nil)
//        }
        
    }


    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupSubViews()
        self.setupLongPress()
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
        zanBtn.setImage(UIImage(named: "like_black_selected"), for: UIControlState.disabled)
        self.contentView.addSubview(zanCount)
        zanCount.textAlignment = NSTextAlignment.center
        
        self.contentView.addSubview(commentBtn)
        commentBtn.setImage(UIImage(named: "comment"), for: UIControlState.normal)
        
        self.contentView.addSubview(deleteBtn)
        deleteBtn.setImage(UIImage(named : "trash"), for: UIControlState.normal)
        self.contentView.addSubview(ownerIcon)
        ownerIcon.addTarget(self , action: #selector(commentUserClick(sender:)), for: UIControlEvents.touchUpInside)
        /**举报*/
        self.contentView.addSubview(reportBtn)
        self.reportBtn.setTitleColor(UIColor.gray, for: UIControlState.normal)
        self.reportBtn.titleLabel?.font = GDFont.systemFont(ofSize: 13)
//        deleteBtn.setImage(UIImage(named : "trash"), for: UIControlState.normal)
        self.reportBtn.setTitle("举报", for: UIControlState.normal)
        reportBtn.addTarget(self , action: #selector(reportClick(sender:)), for: UIControlEvents.touchUpInside)
        
        
        self.contentView.addSubview(ownerName)
        self.contentView.addSubview(descripLabel)
        self.contentView.addSubview(arrowView)
        descripLabel.font = GDFont.systemFont(ofSize: 14)
        descripLabel.textColor = UIColor.white
        
        descripLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        
        ownerName.backgroundColor =  self.backColor
        ownerName.font = GDFont.systemFont(ofSize: 14)
        self.contentView.addSubview(creatTime)
        self.creatTime.backgroundColor =  self.backColor
        creatTime.font = self.ownerName.font
        if(UIScreen.main.bounds.size.height == 480){//5,5s,5c不变
            self.ownerName.adjustsFontSizeToFitWidth = true
            self.creatTime.adjustsFontSizeToFitWidth = true 
        }else{//
            
        }
        self.creatTime.textAlignment = NSTextAlignment.right

        self.zanBtn.addTarget(self , action: #selector(zanClick(sender:)), for: UIControlEvents.touchUpInside)
        self.commentBtn.addTarget(self , action: #selector(commentClick(sender:)), for: UIControlEvents.touchUpInside)
        self.deleteBtn.addTarget(self , action: #selector(deleteClick(sender:)), for: UIControlEvents.touchUpInside)
        
        self.contentView.addSubview(self.zanContainer)
        self.zanContainer.backgroundColor = self.backColor
        self.contentView.addSubview(line)
        line.backgroundColor = UIColor(red: 230 / 256, green:  230 / 256, blue:  230 / 256, alpha: 1)
    }
    @objc func reportClick(sender : UIButton)  {
        mylog("reportClick")
        self.cellDelegate?.perforReport(mediaID: self.model?.id ?? "" , reporterID: "")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let iconW  : CGFloat = 44
        let bigImgW = SCREENWIDTH - iconW * 2
        let besideBtnMargin = (bigImgW - iconW) / 8 // 赞,评,删得垂直间距
        
        if model?.mine == 1 {
            self.ownerIcon.frame = CGRect(x: SCREENWIDTH - iconW, y: 0, width: iconW, height: iconW)
        }else{
            self.ownerIcon.frame = CGRect(x: 0, y: 0, width: iconW, height: iconW)
        }
        
        self.reportBtn.frame = CGRect(x: 0, y: bigImgW * 0.5 - 44 / 2, width: iconW, height: 44)
        
        self.zanBtn.frame = CGRect(x: SCREENWIDTH - iconW, y: ownerIcon.frame.maxY + besideBtnMargin , width: iconW, height: iconW)
        self.zanCount.frame = CGRect(x: zanBtn.frame.minX , y: zanBtn.frame.maxY , width: iconW , height: iconW / 3)
        
        
        self.commentBtn.frame = CGRect(x: zanBtn.frame.minX, y: zanBtn.frame.maxY + besideBtnMargin , width: iconW, height: iconW)
        
        self.deleteBtn.frame = CGRect(x: zanBtn.frame.minX, y: commentBtn.frame.maxY + besideBtnMargin , width: iconW, height: iconW)
        self.deleteBtn.isHidden = self.model?.mine == 1 ? false : true
        
        self.bigImageView.frame = CGRect(x: iconW, y: 0, width: bigImgW, height: bigImgW)
        self.videoIcon.bounds = CGRect(x: 0, y: 0, width: 44, height: 44)
        self.videoIcon.center = self.bigImageView.center
        if self.isVideo {
            self.videoIcon.isHidden = false
        }else{
            self.videoIcon.isHidden = true
        }
        
        self.descripLabel.frame = CGRect(x: iconW , y: bigImgW - 20, width: bigImgW , height: 20)
        if !(self.model?.descrip?.isEmpty ?? true)   && self.model?.descrip?.characters.count ?? 0 > 0{
            self.descripLabel.isHidden = false
            self.descripLabel.text =  " " + (self.model?.descrip)!
        }else{
            self.descripLabel.isHidden = true
        }
        let nameH  : CGFloat = 30
        self.ownerName.frame = CGRect(x: iconW, y: bigImgW, width: bigImgW / 2, height: nameH)
        self.creatTime.frame  = CGRect(x: iconW + bigImgW / 2, y: bigImgW, width: bigImgW / 2, height: nameH)
        self.arrowView.frame = CGRect(x: iconW + 10, y: self.ownerName.frame.maxY, width: 12, height: 8)
        
//        var zanContainerW = bigImgW
//        var zanContainerH : CGFloat = 0
//        let verticalMargin : CGFloat = 10
//        let horizontalMargin : CGFloat = 10
        
    
        
        self.zanContainer.frame = CGRect.zero
        let zanContainerMaxW :CGFloat = SCREENWIDTH - 44 * 2
        let margin : CGFloat = 5
        var currentW : CGFloat = margin
        var currentH : CGFloat = margin
        
        if self.model?.goods?.count ?? 0 > 0  {
            self.zanContainer.isHidden = false
            var zanitemH : CGFloat = 0
            for (index ,subView) in self.zanContainer.subviews.enumerated() {
                if let zanLogo = subView as? UIImageView {
                    zanLogo.frame =  CGRect(x: margin , y: margin  , width: 14, height:14 )
                    currentW += (margin + 14)
                }
                if let zanView = subView as? GDZanUser {
                    zanitemH = zanView.bounds.size.height
                    let tempmodel =  model?.goods?[index-1]
                    
//                    tempmodel?.switchState = true
                    zanView.model = tempmodel
                    if zanView.bounds.size.width > zanContainerMaxW - currentW - margin {
                        mylog("点赞人布局时 处于一行中第一个位置的姓名:\(String(describing: tempmodel?.title))")
                        currentH += (zanView.bounds.size.height + margin)
                        currentW = margin 
                        if index == (self.model?.goods?.count ?? 0) {//所有点赞人中 , 最后一个点赞的人逗号隐藏
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
                        mylog("点赞人布局时不在一行中第一个位置的姓名:\(String(describing: tempmodel?.title))")
                    }
                }
            }
            currentH += (zanitemH + margin)
            self.zanContainer.frame = CGRect(x: iconW, y: self.arrowView.frame.maxY, width: zanContainerMaxW, height: currentH  )//容器
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
    @objc func zanClick(sender:UIButton)  {
        self.cellDelegate?.zanClick(mediaID: self.model?.id ?? "0")
    }
    @objc func zanUserClick(sender : GDZanUser)  {
        mylog("点击点赞的人")
        if let userID = sender.model?.additionalTitle {
            self.cellDelegate?.gotoUserDetail(userID: userID)
        }
    }
    @objc func commentClick(sender:UIButton) {
        self.cellDelegate?.commentClick(mediaID: self.model?.id ?? "0")
    }
    @objc func deleteClick(sender:UIButton)  {
        self.cellDelegate?.deleteClick(mediaID: self.model?.id ?? "0")
    }
    @objc func commentUserClick(sender : UIButton)  {
        mylog("点击点赞的人")
        if let userID = self.model?.user_id {
            self.cellDelegate?.gotoUserDetail(userID: userID)
        }
    }
    // MARK: 注释 : 进入图片浏览器  新/旧
    @objc func bigImageClick(sender:UIButton)  {
        //self.cellDelegate?.bigImageClick(mediaID: self.model?.id ?? "0")
        if let realModel = model {
            
            self.cellDelegate?.bigImageClickToImageBrowser(model: realModel)
        }
    }

}
