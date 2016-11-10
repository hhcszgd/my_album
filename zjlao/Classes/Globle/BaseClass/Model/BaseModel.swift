//
//  BaseModel.swift
//  mh824appWithSwift
//
//  Created by wangyuanfei on 16/9/7.
//  Copyright © 2016年 www.16lao.com. All rights reserved.
//

import UIKit

class BaseModel: NSObject {
    var judge : Bool = false //跳转之前是否需要判断登录状态 , 默认为否
    var actionkey : String?
    var keyparamete : AnyObject?
    var items : [AnyObject]?
    init(dict : [String : AnyObject]?) {
        super.init()
        if let dic = dict {
            self.setValuesForKeys(dic)
        }
    }
    override func setValue(_ value: Any?, forKey key: String) {
//        mylog("\(value)/\(key)")
        super.setValue(value, forKey: key)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
