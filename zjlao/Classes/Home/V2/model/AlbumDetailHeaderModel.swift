//
//  AlbumDetailHeaderModel.swift
//  zjlao
//
//  Created by WY on 2017/10/25.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit

class AlbumDetailHeaderModel: GDBaseModel {
    @objc var update_at : Int  = 0
    @objc var album_name : String = ""
    @objc var members : [[String:AnyObject]] = [[String:AnyObject]]()
    @objc var membersModel : [AlbumMember]  {
        var  temp =   [AlbumMember]()
        for index  in 0...4 {
            let member = AlbumMember(dict:nil)
            temp.append(member)
        }
        return  temp
    }
    @objc var create_at : String = ""
}
