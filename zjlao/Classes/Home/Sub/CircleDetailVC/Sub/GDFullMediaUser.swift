//
//  GDFullMediaUser.swift
//  zjlao
//
//  Created by WY on 20/04/2017.
//  Copyright © 2017 com.16lao.zjlao. All rights reserved.
//点赞人视图模型

import UIKit

class GDFullMediaUser: GDBaseModel {
    var comment_user_avatar  : String?//
    var comment_user_name  : String?
    var create_at  : String?
    var comment_user_id  : NSNumber?//
    var media_id  : String?
    var is_good : String?

    
    override init(dict: [String : AnyObject]?) {
        super.init(dict: dict)
    }
}
