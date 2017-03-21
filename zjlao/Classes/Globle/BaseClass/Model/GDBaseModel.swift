//
//  GDBaseModel.swift
//  zjlao
//
//  Created by WY on 17/1/15.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit

class GDBaseModel: NSObject {
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
    //    func change(value  : [AnyObject] , modelType : String) -> [AnyObject]?{
    //        var models = [GoodsModel]()
    //        for item in value {//遍历数组
    //            if let itemreal = item as? [String] {//取出并判断子数组元素类型是否是字符串类型,基本不会
    //
    //            }
    //            if let itemreal = item as? [String : AnyObject] {//取出并判断子数组元素类型是否是字典类型,基本都是
    //                //再进行字典转模型
    //                let someModel : GoodsModel = GoodsModel(dict: itemreal)
    //                models.append(someModel)
    //            }
    //            if let itemreal = item as? [AnyObject] {//取出并判断子数组元素类型是否是数组类型,基本不会
    //
    //            }
    //        }
    //        return models
    //    }
    //    func change(value  : [AnyObject]) -> [AnyObject]?{
    //         let models = [SomeModel]()
    //        for item in value {//遍历数组
    //            if let itemreal = item as? [String] {//取出并判断子数组元素类型是否是字符串类型,基本不会
    //
    //            }
    //            if let itemreal = item as? [String : AnyObject] {//取出并判断子数组元素类型是否是字典类型,基本都是
    //                //再进行字典转模型
    //                let someModel : SomeModel = SomeModel.init(dict:itemreal)
    //                models.append(someModel)
    //            }
    //            if let itemreal = item as? [AnyObject] {//取出并判断子数组元素类型是否是数组类型,基本不会
    //
    //            }
    //        }
    //        return models
    //    }
}



func dictArrToModelArr(value  : [AnyObject] , modelType : String) -> [AnyObject]? {
    var models = [AnyObject]()
    for item in value {//遍历数组
        if let itemreal = item as? [String] {//取出并判断子数组元素类型是否是字符串类型,基本不会
            
        }
        if let itemreal = item as? [AnyObject] {//取出并判断子数组元素类型是否是数组类型,基本不会
            
        }
        if let itemreal = item as? [String : AnyObject] {//取出并判断子数组元素类型是否是字典类型,基本都是
            //再进行字典转模型
            var model : GDBaseModel = GDBaseModel(dict: nil)
            if modelType == "Goods" {
                model  = GoodsModel(dict: itemreal)
            }else if (modelType == "Shop"){
                model = ShopModel(dict: itemreal)
            }else if (modelType == "SomeClassNameElse"){
                //                 model = SomeModel(dict: itemreal)
            }
            models.append(model)
        }
    }
    return models

}
