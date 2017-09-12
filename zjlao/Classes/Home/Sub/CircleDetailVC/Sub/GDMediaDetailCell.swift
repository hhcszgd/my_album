//
//  GDMediaDetailCell.swift
//  zjlao
//
//  Created by WY on 14/07/2017.
//  Copyright © 2017 com.16lao.zjlao. All rights reserved.
//

import UIKit


import UIKit
import SnapKit
protocol GDMediaDetailCellDelete : NSObjectProtocol {
    func gotoUserDetail(userID:String )//暂未实现
}


class GDMediaDetailCell: UITableViewCell {
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
            attributeStr.addAttribute(NSForegroundColorAttributeName, value: nameColor, range: NSRange.init(location: 0, length: attributeStr.string.characters.count))
            attributeStr.append(NSAttributedString.init(string:  ": " + (singleComment?.subTitle ?? "")))
            self.commetTextLabel.attributedText = attributeStr
        }
        
    }
    /////
    let  backColor = UIColor(red: 240 / 256, green:  240 / 256, blue:  240 / 256, alpha: 1)
    
    weak var cellDelegate : GDMediaDetailCellDelete?
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupSubViews()
        self.backgroundColor = UIColor.white//UIColor.init(colorLiteralRed: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let horizontalMargin  :CGFloat = 5
        let backColorViewW = SCREENWIDTH - horizontalMargin * 2
        let verticalMargin : CGFloat = 2
        let maxWidth =  backColorViewW - horizontalMargin * 2
        let size = self.commetTextLabel.text?.sizeWith(font: self.commetTextLabel.font, maxWidth: maxWidth)
        backColorView.frame = CGRect(x: horizontalMargin, y: 0, width: backColorViewW, height: (size?.height ?? 0) + verticalMargin * 2)
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
