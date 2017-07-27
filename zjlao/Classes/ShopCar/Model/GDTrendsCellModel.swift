//
//  GDTrendsCellModel.swift
//  zjlao
//
//  Created by WY on 17/4/3.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit

class GDTrendsCellModel: GDBaseModel {
    var d : String? //day
    var my : String?//month and year
    var m : String? //month
    var y  : String? //year
    
    
    var w : String?//week
    override init(dict: [String : AnyObject]?) {
        super.init(dict: dict)
    }
    
}
