//
//  GDCircleTrendsCellModel.swift
//  zjlao
//
//  Created by WY on 17/4/3.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit

class GDCircleTrendsCellModel: BaseControlModel {

    var names : String?
    var num  : String?
    var time  : String?
    var circleID : String?
    var city : String?
    var members = [BaseControlModel]()
    var pictures = [BaseControlModel]()
    
    override init(dict: [String : AnyObject]?) {
        super.init(dict: dict)
    }
}
