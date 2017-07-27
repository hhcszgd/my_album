//
//  GDCircleDetailCellModel.swift
//  zjlao
//
//  Created by WY on 18/04/2017.
//  Copyright © 2017 com.16lao.zjlao. All rights reserved.
//

import UIKit

class GDCircleDetailCellModel: GDBaseModel {
    var thumbnail  : String?
    var create_at  : String?
    var avatar  : String?
    var comment_count  : NSNumber?//评论总数
    var original  : String?
    var video_url : String?
    var user_id : String?
    var format : String?
    var name : String?
    var mine : NSNumber? //1代表我的
    var my_good : NSNumber? //1代表已经点赞
    var browse_count : String? //浏览量
    var good_count : NSNumber?
    var id : String? //媒体id
    var descrip : String?
    var city : String?
    var goods : [BaseControlModel]?
    var good : [[String : Any]]?{
        willSet{
            var tempArr = [BaseControlModel]()
            if let goodDictArr =  newValue{
                for goodDict in goodDictArr {
                    let goodModel  = BaseControlModel.init(dict: goodDict as [String : AnyObject]?)
                    if let comment_user_avatar = goodDict["comment_user_avatar"] as? String{
                        goodModel.imageUrl = comment_user_avatar
                    }
                    if let comment_user_name = goodDict["comment_user_name"] as? String{
                        goodModel.title = comment_user_name
                    }

                    if let comment_user_id = goodDict["comment_user_id"] as? String{
                        goodModel.additionalTitle = comment_user_id
                    }
                    tempArr.append(goodModel)
                }
//                for _  in 0...19 {
//                    let goodModel  = BaseControlModel.init(dict: nil)
//                        goodModel.title = "拉斯科"
//
//                    tempArr.append(goodModel)
//                }
                self.goods = tempArr
            }
        }
    }
    
    var comments  : [BaseControlModel]?
    var comment  : [[String:Any]]?{
        willSet{
            var tempArr = [BaseControlModel]()
            if let commentDictArr =  newValue{
                for commentDict in commentDictArr {
                    let commentModel  = BaseControlModel.init(dict: commentDict as [String : AnyObject]?)
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
                    
                    if let comment_user_id = commentDict["id"] as? String{
                        commentModel.extensionTitle1 = comment_user_id
                    }
                    if let comment_user_id = commentDict["media_id"] as? String{
                        commentModel.extensionTitle2 = comment_user_id
                    }
                    
                    
                    tempArr.append(commentModel)
                }
                self.comments = tempArr
            }
        }
    }
    /**
     description = ;
     thumbnail = http://f0.ugshop.cn/media/89/149250970097514.jpg?imageView2/1/w/100/h/100;
     my_good = 0;
     province = 北京市;
     browse_count = 0;
     country = 中国;
     user_id = 89;
     circle_id = 190;
     good_count = 1;
     create_date = 2017-04-18;
     city = 北京市;
     good = (
     );
     original = http://f0.ugshop.cn/media/89/149250970097514.jpg;
     name = 许鹏亮;
     mine = 0;
     id = 273;
     format = jpg;
     create_at = 周二 06:01;
     avatar = http://f0.ugshop.cn/avatar/89/149250205822375.jpeg;
     comment = (
     );
     comment_count = 0;
     isinformed = 0;
     */
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "description" {
            if let valueStr = value as? String {
                self.descrip = valueStr
            }
        }else{
            super.setValue(value, forKey: key)
        }
    }
    
    
    override init(dict: [String : AnyObject]?) {
        super.init(dict: dict)
    }
    
}
