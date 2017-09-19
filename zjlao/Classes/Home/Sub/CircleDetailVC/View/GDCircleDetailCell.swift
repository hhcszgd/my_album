//
//  GDCircleDetailCell.swift
//  zjlao
//
//  Created by WY on 18/04/2017.
//  Copyright © 2017 com.16lao.zjlao. All rights reserved.
//

import UIKit
import SnapKit
protocol GDCircleDetailCellDelete : NSObjectProtocol {
    func gotoUserDetail(userID:String )//暂未实现
}

class GDCalculatorCircleDetailCellHeight : NSObject{
   class func getCellHeight (modelData : GDCircleDetailCellModel?) -> CGFloat{
        var height  : CGFloat = 0
        if modelData != nil {
            height = 44
        }
        return height
    }
    
}


class GDCircleDetailCell: UITableViewCell {
    /*                   
     if let comment_user_avatar = commentDict["comment_user_avatar"] as? String{
     commentModel.imageUrl = comment_user_avatar
     }
     if let comment_user_name = commentDict["comment_user_name"] as? String{
     commentModel.title = comment_user_name
     }
     if let content = commentDict["content"] as? String{
     commentModel.subTitle = content
     }
     if let comment_user_id = commentDict["comment_user_id"] as? String{
     commentModel.additionalTitle = comment_user_id
     }
     */
//    let user : UIButton = UIButton()
//    let otheruser = UIButton()//做回复功能时再实现
    let commetTextLabel = UILabel()
    let backColorView = UIView()
    
    var singleComment  : BaseControlModel?{
        didSet{
//            let fullCommtenStr = (singleComment?.title ?? "") + ":" + (singleComment?.subTitle ?? "")
            
            let attributeStr  = NSMutableAttributedString(string: (singleComment?.title ?? ""))
            let nameColor : UIColor = UIColor(hexString: "#5A6D96")! // UIColor.blue
            attributeStr.addAttribute(NSAttributedStringKey.foregroundColor, value: nameColor, range: NSRange.init(location: 0, length: attributeStr.string.characters.count))
            attributeStr.append(NSAttributedString.init(string:  ": " + (singleComment?.subTitle ?? "")))
            self.commetTextLabel.attributedText = attributeStr
        }
        
    }
    /////
    let  backColor = UIColor(red: 240 / 256, green:  240 / 256, blue:  240 / 256, alpha: 1)
    
    weak var cellDelegate : GDCircleDetailCellDelete?
    
 
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupSubViews()
        self.backgroundColor = UIColor.white//UIColor.init(colorLiteralRed: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let backColorViewW = SCREENWIDTH - 44 * 2
        let horizontalMargin  :CGFloat = 5
        let verticalMargin : CGFloat = 2
        let maxWidth =  backColorViewW - horizontalMargin * 2
        let size = self.commetTextLabel.text?.sizeWith(font: self.commetTextLabel.font, maxWidth: maxWidth)
        backColorView.frame = CGRect(x: 44, y: 0, width: backColorViewW, height: (size?.height ?? 0) + verticalMargin * 2)
        commetTextLabel.frame = CGRect(x: horizontalMargin, y: verticalMargin, width: maxWidth, height: size?.height ?? 0)
        
      
    }
    func setupSubViews()  {
        self.contentView.addSubview(self.backColorView)
        self.backColorView.addSubview(self.commetTextLabel)
        self.commetTextLabel.numberOfLines = 0
        self.backColorView.backgroundColor = self.backColor
        self.commetTextLabel.font = GDFont.systemFont(ofSize: 14)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//    func gotoUserDetail(userID:String)  {
//        //            mylog("\(model.title)  \(model.subTitle)  \(model.imageUrl)")
//        let skipModel = GDBaseModel.init(dict: nil )
//        skipModel.actionkey = "GDUserHistoryVC"
//        skipModel.keyparamete =  userID //model.subTitle as AnyObject//用户id
//        GDSkipManager.skip(viewController: self , model: skipModel)
//    }
}
/**
 //
 //  GDCircleDetailCell.swift
 //  zjlao
 //
 //  Created by WY on 18/04/2017.
 //  Copyright © 2017 com.16lao.zjlao. All rights reserved.
 //
 
 import UIKit
 import SnapKit
 protocol GDCircleDetailCellDelete : NSObjectProtocol {
 func zanClick(mediaID:String)
 func commentClick(mediaID:String)
 func deleteClick(mediaID:String)
 func seeMoreCmmments(mediaID:String)
 func bigImageClick(mediaID:String)
 func bigImageClickToImageBrowser(model  : GDCircleDetailCellModel)
 func gotoUserDetail(userID:String )
 
 }
 class GDCircleDetailCell: UITableViewCell {
 let subZanLogo = UIImageView(image: UIImage(named: "like_black"))
 let subCommentLogo = UIImageView(image: UIImage(named: "comment"))
 
 let videoIcon = UIImageView(image: UIImage(named : "VideoOverlayPlay")/*?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)*/)
 var isVideo  = false
 
 
 weak var cellDelegate : GDCircleDetailCellDelete?
 var model  : GDCircleDetailCellModel?{
 willSet{
 self.ownerIcon.sd_setImage(with: URL(string: newValue?.avatar ?? ""), for: UIControlState.normal)
 
 self.bigImageView.sd_setImage(with: URL(string: newValue?.original ?? ""), for: UIControlState.normal)
 if let imgUrl = newValue?.original {
 if imgUrl.hasSuffix("jpeg") {
 self.isVideo  = false
 }else{
 self.isVideo  = true
 }
 }
 
 if let num  = newValue?.good_count {
 self.zanCount.text  = "\(num)"
 }else{
 self.zanCount.text =  ""
 }
 
 self.ownerName.text = newValue?.name
 self.creatTime.text = (newValue?.city ?? "" ) + " " + (newValue?.create_at ?? "")
 
 for subView  in self.zanContainer.subviews {
 subView.removeFromSuperview()
 }
 for subView  in self.commentContainer.subviews {
 subView.removeFromSuperview()
 }
 
 if newValue?.goods?.count ?? 0 > 0  {
 for (index ,submodel) in (newValue?.goods?.enumerated())! {
 if index >= 16 {break  }
 let user  = GDZanUser.init(frame: CGRect.zero)
 user.model = submodel
 user.addTarget(self , action: #selector(zanUserClick(sender:)), for: UIControlEvents.touchUpInside)
 self.zanContainer.addSubview(user)
 }
 }
 
 if newValue?.comments?.count ?? 0 > 0 {
 for (index ,submodel) in (newValue?.comments?.enumerated())! {
 if index >= 2 {break  }
 let comment  = GDCommentShort.init(frame: CGRect.zero)
 comment.model = submodel
 comment.button.addTarget(self , action: #selector(commentUserClick(sender:)), for: UIControlEvents.touchUpInside)
 comment.backgroundColor = self.backgroundColor
 self.commentContainer.addSubview(comment)
 }
 }
 
 self.commentCount.text = "总共有\(newValue?.comment_count ?? 0)条评论"
 
 }
 }
 
 let bigImageView : UIButton = UIButton.init(frame: CGRect.zero)
 let zanBtn  = UIButton()
 let zanCount = UILabel()
 let commentBtn = UIButton()
 let deleteBtn = UIButton()
 let ownerIcon = UIButton()
 let ownerName = UILabel()
 let descripLabel = UILabel()
 let creatTime = UILabel()
 let zanContainer = UIView()
 let commentContainer = UIView()
 let commentCount = UILabel()
 let seeMoreBtn = UIButton()
 let zanLine = UIView()
 let commentLine = UIView()
 let cellJiange = UIView()
 
 override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
 super.init(style: style, reuseIdentifier: reuseIdentifier)
 self.setupSubViews()
 self.backgroundColor = UIColor.init(colorLiteralRed: 0.95, green: 0.95, blue: 0.95, alpha: 1)
 self.selectionStyle = UITableViewCellSelectionStyle.none
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
 
 self.descripLabel.frame = CGRect(x: iconW + 5, y: bigImgW - 20, width: bigImgW - 5 * 2, height: 20)
 if !(self.model?.descrip?.isEmpty ?? true)   && self.model?.descrip?.characters.count ?? 0 > 0{
 self.descripLabel.isHidden = false
 self.descripLabel.text = self.model?.descrip
 }else{
 self.descripLabel.isHidden = true
 }
 
 self.ownerName.frame = CGRect(x: iconW, y: bigImgW, width: bigImgW / 2, height: 17)
 self.creatTime.frame  = CGRect(x: iconW + bigImgW / 2, y: bigImgW, width: bigImgW / 2, height: 17)
 
 var zanContainerW = bigImgW
 var zanContainerH : CGFloat = 0
 let verticalMargin : CGFloat = 10
 let horizontalMargin : CGFloat = 10
 
 self.zanContainer.frame = CGRect.zero
 if self.model?.goods?.count ?? 0 > 0  {
 self.zanContainer.isHidden = false
 
 if self.model?.comments?.count ?? 0 == 0 {
 self.zanLine.isHidden = true
 }else{
 self.zanLine.isHidden = false
 }
 let col : CGFloat = 8
 let zanIconMargin : CGFloat = 2
 let zanIconW = (bigImgW - (col - 1 ) *  zanIconMargin) /  col
 zanContainerH = zanIconW
 
 if zanContainer.subviews.count > 8 {
 zanContainerH = zanIconW * 2 + zanIconMargin
 }
 
 self.zanContainer.frame = CGRect(x: iconW, y: self.ownerName.frame.maxY + verticalMargin, width: zanContainerW, height: zanContainerH)//容器
 self.zanLine.frame = CGRect(x: horizontalMargin, y: self.zanContainer.frame.maxY - 0.5 + verticalMargin / 2, width: SCREENWIDTH - horizontalMargin * 3, height: 1)
 
 
 
 
 for (index ,subView) in self.zanContainer.subviews.enumerated() {
 if index >= 16 {break  }
 let colth = index / 8 //列
 let rowth = index % 8//行
 subView.frame = CGRect(x: CGFloat(rowth) * (zanIconW + zanIconMargin), y:  CGFloat(colth) * (zanIconW + zanIconMargin) , width: zanIconW, height: zanIconW)
 }
 subZanLogo.isHidden = false
 subZanLogo.frame = CGRect(x: 11, y: self.zanContainer.frame.minY + 6, width: 22, height: 22)
 
 
 }else{
 self.zanContainer.isHidden = true
 self.zanLine.isHidden = true
 self.subZanLogo.isHidden = true
 }
 
 
 
 
 
 
 if self.model?.comments?.count ?? 0 > 0 {
 self.commentContainer.isHidden = false
 //            self.commentLine.isHidden = false
 let subViewH : CGFloat = 64
 
 if self.commentContainer.subviews.count == 1  {
 if zanContainer.frame.height > 0 {
 
 self.commentContainer.frame =  CGRect(x: iconW, y: zanContainer.frame.maxY + verticalMargin, width: bigImgW + iconW / 2, height: subViewH)
 }else{
 self.commentContainer.frame =  CGRect(x: iconW, y: ownerName.frame.maxY + verticalMargin, width: bigImgW + iconW / 2, height: subViewH)
 }
 }else if self.commentContainer.subviews.count >= 2 {
 if zanContainer.frame.height > 0 {
 
 self.commentContainer.frame =  CGRect(x: iconW, y: zanContainer.frame.maxY + verticalMargin, width: bigImgW + iconW / 2, height: subViewH * 2 + verticalMargin)
 }else{
 self.commentContainer.frame =  CGRect(x: iconW, y: ownerName.frame.maxY + verticalMargin, width: bigImgW + iconW / 2, height: subViewH * 2 + verticalMargin)
 }
 }
 
 for (index ,subView) in self.commentContainer.subviews.enumerated() {
 if index == 0 {
 subView.frame = CGRect(x: 0, y: 0, width: self.commentContainer.bounds.size.width, height: subViewH)
 }else if index == 1 {
 subView.frame = CGRect(x: 0, y: subViewH + verticalMargin , width: self.commentContainer.bounds.size.width, height: subViewH)
 }
 }
 
 if Int((self.model?.comment_count)!) > 2 {//查看更多
 let seeMoreH : CGFloat = 20
 self.commentCount.isHidden = false
 self.seeMoreBtn.isHidden = false
 self.commentCount.frame = CGRect(x: bigImageView.frame.minX, y: self.commentContainer.frame.maxY + verticalMargin, width: bigImgW / 2 , height: seeMoreH)
 self.seeMoreBtn.frame = CGRect(x: bigImageView.frame.minX + self.commentCount.bounds.size.width, y: self.commentCount.frame.minY, width: bigImgW / 2 , height: seeMoreH)
 //                self.commentLine.frame = CGRect(x: horizontalMargin, y: self.seeMoreBtn.frame.maxY - 0.5, width: SCREENWIDTH - horizontalMargin * 3, height: 1)
 
 }else{
 
 self.commentCount.isHidden = true
 self.seeMoreBtn.isHidden = true
 //                self.commentLine.frame = CGRect(x: horizontalMargin, y: self.commentContainer.frame.maxY - 0.5, width: SCREENWIDTH - horizontalMargin * 3, height: 1)
 }
 
 self.subCommentLogo.isHidden = false
 self.subCommentLogo.frame =  CGRect(x: 11, y: self.commentContainer.frame.minY + 6, width: 22, height: 22)
 
 }else{
 self.commentContainer.isHidden = true
 //            self.commentLine.isHidden = true
 self.subCommentLogo.isHidden = true
 
 self.commentCount.isHidden = true
 self.seeMoreBtn.isHidden = true
 }
 let cellJiange : CGFloat = 10
 self.commentLine.frame = CGRect(x: horizontalMargin, y: self.bounds.size.height - cellJiange / 2, width: SCREENWIDTH - horizontalMargin * 3, height: 1)
 
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
 self.contentView.addSubview(zanCount)
 zanCount.textAlignment = NSTextAlignment.center
 
 self.contentView.addSubview(commentBtn)
 commentBtn.setImage(UIImage(named: "comment"), for: UIControlState.normal)
 
 self.contentView.addSubview(deleteBtn)
 deleteBtn.setImage(UIImage(named : "trash"), for: UIControlState.normal)
 self.contentView.addSubview(ownerIcon)
 ownerIcon.addTarget(self , action: #selector(commentUserClick(sender:)), for: UIControlEvents.touchUpInside)
 self.contentView.addSubview(ownerName)
 self.contentView.addSubview(descripLabel)
 descripLabel.font = GDFont.systemFont(ofSize: 14)
 descripLabel.textColor = UIColor.gray
 
 descripLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
 
 ownerName.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
 ownerName.font = GDFont.systemFont(ofSize: 14)
 self.contentView.addSubview(creatTime)
 self.creatTime.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
 creatTime.font = self.ownerName.font
 self.creatTime.textAlignment = NSTextAlignment.right
 self.contentView.addSubview(zanContainer)
 self.contentView.addSubview(commentContainer)
 
 
 self.contentView.addSubview(subZanLogo)
 self.contentView.addSubview(subCommentLogo)
 
 
 
 self.contentView.addSubview(self.zanLine)
 zanLine.backgroundColor = UIColor.lightGray
 
 self.contentView.addSubview(self.commentLine)
 self.commentLine.backgroundColor  = UIColor.lightGray
 //        self.contentView.addSubview(<#T##view: UIView##UIView#>)
 //        self.contentView.addSubview(<#T##view: UIView##UIView#>)
 self.contentView.addSubview(self.seeMoreBtn)
 self.seeMoreBtn.addTarget(self , action: #selector(seeMoreCmmments(sender:)), for: UIControlEvents.touchUpInside)
 
 self.contentView.addSubview(self.commentCount)
 self.seeMoreBtn.setTitleColor(UIColor.blue, for: UIControlState.normal)
 self.seeMoreBtn.setTitle("查看更多>>>", for: UIControlState.normal)
 self.commentCount.font = GDFont.systemFont(ofSize: 14)
 self.seeMoreBtn.titleLabel?.font = self.commentCount.font
 
 self.zanBtn.addTarget(self , action: #selector(zanClick(sender:)), for: UIControlEvents.touchUpInside)
 self.commentBtn.addTarget(self , action: #selector(commentClick(sender:)), for: UIControlEvents.touchUpInside)
 self.deleteBtn.addTarget(self , action: #selector(deleteClick(sender:)), for: UIControlEvents.touchUpInside)
 
 }
 
 func seeMoreCmmments(sender:UIButton)  {
 self.cellDelegate?.seeMoreCmmments(mediaID: self.model?.id ?? "0")
 }
 func zanClick(sender:UIButton)  {
 self.cellDelegate?.zanClick(mediaID: self.model?.id ?? "0")
 }
 func commentClick(sender:UIButton) {
 self.cellDelegate?.commentClick(mediaID: self.model?.id ?? "0")
 }
 func deleteClick(sender:UIButton)  {
 self.cellDelegate?.deleteClick(mediaID: self.model?.id ?? "0")
 }
 func commentUserClick(sender : UIButton)  {
 mylog("点击点赞的人")
 if let superview = sender.superview as? GDCommentShort {
 if let userID = superview.model?.additionalTitle {
 
 self.cellDelegate?.gotoUserDetail(userID: userID)
 }
 }
 if let superview = sender.superview?.superview as? GDCircleDetailCell {
 if let userID = superview.model?.user_id {
 self.cellDelegate?.gotoUserDetail(userID: userID)
 }
 
 }
 }
 func zanUserClick(sender : GDZanUser)  {
 mylog("点击点赞的人")
 if let userID = sender.model?.additionalTitle {
 
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
 required init?(coder aDecoder: NSCoder) {
 fatalError("init(coder:) has not been implemented")
 }
 
 
 //    func gotoUserDetail(userID:String)  {
 //        //            mylog("\(model.title)  \(model.subTitle)  \(model.imageUrl)")
 //        let skipModel = GDBaseModel.init(dict: nil )
 //        skipModel.actionkey = "GDUserHistoryVC"
 //        skipModel.keyparamete =  userID //model.subTitle as AnyObject//用户id
 //        GDSkipManager.skip(viewController: self , model: skipModel)
 //    }
 }
 /**
 
 -(UIView*)gotInputView
 {
 /** 有表情按钮的 */
 CGFloat margin= 10 ;
 UIView * inputView = [[UIView alloc]initWithFrame: CGRectMake(0, screenH-56*SCALE, screenW, 56*SCALE)];
 
 inputView.backgroundColor= [UIColor whiteColor];
 
 //    picture.backgroundColor=randomColor;
 CGFloat browH =   inputView.bounds.size.height * 0.6;
 CGFloat browW =  browH ;
 CGFloat browX =  0 ;
 CGFloat browY =  inputView.bounds.size.height * 0.2 ;
 
 
 UIButton * brow = [[UIButton alloc]initWithFrame:CGRectMake(browX,browY,browW,browH)];
 self.browButton = brow;
 //    brow.imageEdgeInsets = UIEdgeInsetsMake(10*SCALE, 10*SCALE, 10*SCALE, 10*SCALE);
 //    brow.backgroundColor = randomColor;
 [inputView addSubview:brow];
 [brow setImage:[UIImage imageNamed:@"bg_icon_ff"] forState:UIControlStateNormal];
 [brow setImage:[UIImage imageNamed:@"bg_icon_ww"] forState:UIControlStateSelected];
 [brow addTarget:self action:@selector(showBrow:) forControlEvents:UIControlEventTouchUpInside];
 
 //    [brow setTitle:@"情" forState:UIControlStateNormal];
 //    [brow setTitle:@"盘" forState:UIControlStateSelected];
 
 CGFloat picX =  browW ;
 CGFloat picY =  browY ;
 CGFloat picH =   browH;
 CGFloat picW =  browW ;
 UIButton * picture = [[UIButton alloc]initWithFrame:CGRectMake(picX, picY,picW, picH)];
 //    picture.imageEdgeInsets = UIEdgeInsetsMake(10*SCALE, 10*SCALE, 10*SCALE, 10*SCALE);
 
 [inputView addSubview:picture];
 [picture setImage:[UIImage imageNamed:@"imgPicker"] forState:UIControlStateNormal];
 //    [picture setImage:[UIImage imageNamed:@"bg_electric"] forState:UIControlStateHighlighted];
 [picture addTarget:self action:@selector(gotPicture:) forControlEvents:UIControlEventTouchUpInside];
 
 
 CGFloat sendButtonH = browH ;
 CGFloat sendButtonW = browW ;
 CGFloat sendButtonX = screenW - sendButtonW ;
 CGFloat sendButtonY = browY ;
 UIButton * sendButton = [[UIButton alloc]initWithFrame:CGRectMake(sendButtonX,sendButtonY,sendButtonW,sendButtonH)];
 //    emoj.backgroundColor=randomColor;
 [sendButton setImage:[UIImage imageNamed:@"bg_icon_xx"] forState:UIControlStateNormal];
 //    sendButton.imageEdgeInsets = UIEdgeInsetsMake(10*SCALE, 10*SCALE, 10*SCALE, 10*SCALE);
 //    sendButton.backgroundColor = randomColor;
 //    [sendButton setImage:[UIImage imageNamed:@"bg_Production"] forState:UIControlStateDisabled];
 [sendButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
 
 [inputView addSubview:sendButton];
 CGFloat textviewW = screenW -  sendButtonW - browW - picW;
 CGFloat textviewX = browW + picW ;
 CGFloat textviewY = margin*0.8;
 CGFloat textviewH = inputView.bounds.size.height - textviewY*2;
 GDTextView * textView = [[GDTextView alloc]initWithFrame:CGRectMake(textviewX,textviewY,textviewW,textviewH)];
 [inputView addSubview:textView];
 textView.backgroundColor = [UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1];
 self.textView = textView;
 textView.layer.borderColor=inputView.backgroundColor.CGColor;
 textView.layer.borderWidth=2;
 textView.layer.masksToBounds=YES;
 textView.layer.cornerRadius=13;
 textView.textContainerInset=UIEdgeInsetsMake(8, 10, 8, 5);
 textView.keyboardType=UIKeyboardTypeTwitter;
 textView.returnKeyType=UIReturnKeySend;
 //    textView.inputDelegate=self;
 textView.enablesReturnKeyAutomatically=YES;
 textView.delegate = self ;
 textView.showsVerticalScrollIndicator = NO ;
 return inputView;
 
 
 
 }
 */

 */
