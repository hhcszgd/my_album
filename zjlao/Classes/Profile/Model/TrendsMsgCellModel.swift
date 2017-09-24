//
//  TrendsMsgCellModel.swift
//  zjlao
//
//  Created by WY on 21/04/2017.
//  Copyright © 2017 com.16lao.zjlao. All rights reserved.
//

import UIKit

class TrendsMsgCellModel: GDBaseModel {
    @objc var id : String?
    @objc var content : String?
    @objc var media_type    : String?
    @objc var type   : String?
    @objc var create_at  : String?
    @objc var media_thumbnail  : String?
    @objc var comment_user_id  : String?
    @objc var comment_user_avatar  : String?
    @objc var media_create_at  : String?
    @objc var media_id  : String?
    @objc var is_good  : String?
    @objc var status  : String?
    @objc var comment_user_name  : String?
    @objc var title  : String?
    override init(dict: [String : AnyObject]?) {
        super.init(dict: dict)
    }
}
