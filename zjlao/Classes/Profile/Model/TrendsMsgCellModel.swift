//
//  TrendsMsgCellModel.swift
//  zjlao
//
//  Created by WY on 21/04/2017.
//  Copyright © 2017 com.16lao.zjlao. All rights reserved.
//

import UIKit

class TrendsMsgCellModel: GDBaseModel {
    var id : String?
    var content : String?
    var media_type    : String?
    var type   : String?
    var create_at  : String?
    var media_thumbnail  : String?
    var comment_user_id  : String?
    var comment_user_avatar  : String?
    var media_create_at  : String?
    var media_id  : String?
    var is_good  : String?
    var status  : String?
    var comment_user_name  : String?
    
    override init(dict: [String : AnyObject]?) {
        super.init(dict: dict)
    }
}
