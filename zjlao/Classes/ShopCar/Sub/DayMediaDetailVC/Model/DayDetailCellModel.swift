//
//  DayDetailCellModel.swift
//  zjlao
//
//  Created by WY on 21/04/2017.
//  Copyright © 2017 com.16lao.zjlao. All rights reserved.
//

import UIKit

class DayDetailCellModel: GDBaseModel {
    var d : String? //day
    var my : String?//month and year//创建时间 , 用于请求当天媒体
    var m : String? //month
    var y  : String? //year
    
    
    var w : String?//week
    override init(dict: [String : AnyObject]?) {
        super.init(dict: dict)
    }
    
}
