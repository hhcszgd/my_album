//
//  AlbumModel.swift
//  zjlao
//
//  Created by WY on 2017/10/24.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit

class AlbumModel: GDBaseModel {
    @objc var album_id : Int = 0
    @objc var album_member_count = 1;
    @objc var album_image : String = ""
    @objc var status = 1;
    @objc var media_count = 0;
    @objc var album_name : String = ""
    @objc var album_type : Int = 1 //默认个人相册
    @objc var create_at : String = ""
    @objc var create_user_id : Int = 0
    @objc var update_at : String = ""
}
