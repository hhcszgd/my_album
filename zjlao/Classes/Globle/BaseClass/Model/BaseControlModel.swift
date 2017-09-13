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
    var id : String?
    
    
    var title : String?
     var subTitle : String?
     var additionalTitle : String?
    var extensionTitle : String?
    var extensionTitle1 : String?
    var extensionTitle2 : String?
    
     var image : UIImage?
     var subImage : UIImage?
     var additionalImage : UIImage?
    var extensionImage : UIImage?
     var backImage  : UIImage?
    
    var imageUrl : String?
    var subImageUrl : String?
    var additionalImageUrl : String?
    var backImageUrl  : String?
    var extensionImageUrl : String?
    var switchState  = false 
    var needReset : Bool?
    
}
