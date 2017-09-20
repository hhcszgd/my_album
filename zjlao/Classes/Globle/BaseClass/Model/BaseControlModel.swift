//
//  BaseControlModel.swift
//  mh824appWithSwift
//
//  Created by wangyuanfei on 16/9/21.
//  Copyright © 2016年 www.16lao.com. All rights reserved.
//

import UIKit

class BaseControlModel: GDBaseModel {

    override init(dict: [String : AnyObject]?) {
        super.init(dict: dict)
    }
    @objc var id : String?
    
    
    @objc var title : String?
     @objc var subTitle : String?
     @objc var additionalTitle : String?
    @objc var extensionTitle : String?
    @objc var extensionTitle1 : String?
    @objc var extensionTitle2 : String?
    
   @objc   var image : UIImage?
     @objc var subImage : UIImage?
     @objc var additionalImage : UIImage?
    @objc var extensionImage : UIImage?
     @objc var backImage  : UIImage?
    
    @objc var imageUrl : String?
    @objc var subImageUrl : String?
    @objc var additionalImageUrl : String?
    @objc var backImageUrl  : String?
    @objc var extensionImageUrl : String?
    @objc var switchState  = false
     var needReset : Bool?
    
}
