//
//  MediaModel.swift
//  zjlao
//
//  Created by WY on 2017/10/24.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit

class MediaModel: GDBaseModel {
    @objc var thumbnail:String  = "" //http://f0.ugshop.cn/Fnl6zK1pf5wfzJod0Y2B7tKq8lji?imageView2/1/w/200/h/200;
    @objc var id : Int  = 0
    @objc var create_user_name : String = ""
    @objc var media_type:Int  = 0
    @objc var original:String  = "" // http://f0.ugshop.cn/Fnl6zK1pf5wfzJod0Y2B7tKq8lji;
    @objc var create_at:String  = "" // 2017-10-24 15:57:40;
    @objc var create_user_id : Int  = 0
}
