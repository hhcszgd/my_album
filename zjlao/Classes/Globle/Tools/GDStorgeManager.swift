//
//  GDStorgeManager.swift
//  zjlao
//
//  Created by WY on 16/11/18.
//  Copyright © 2016年 com.16lao.zjlao. All rights reserved.
//

import UIKit

/// 存储类
class GDStorgeManager: UserDefaults {
   public class var registerID : String?{
        set{
            if newValue == nil  {
                return
            }
            GDStorgeManager.standard.set(newValue!, forKey: "registerID")
        }
        get{
            if let registerid = GDStorgeManager.standard.value(forKey: "registerID") as? String{
                return registerid
            }else{
                return nil
            }
        }
    }

//MARK:
    //MARK:增
    //MARK:删
    //MARK:改
    //MARK:查

}
