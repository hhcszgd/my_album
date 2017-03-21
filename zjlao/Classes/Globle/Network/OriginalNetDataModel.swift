//
//  OriginalNetDataModel.swift
//  mh824appWithSwift
//
//  Created by wangyuanfei on 16/9/1.
//  Copyright © 2016年 www.16lao.com. All rights reserved.
//

import UIKit

class OriginalNetDataModel: NSObject , NSCoding /*, NSCopying*/{
    var data  : AnyObject? // 返回的数据
    var msg : String?//状态信息
    var status : Int  = 0 //状态码
    var additional : AnyObject? // 额外的信息 (备用)
    init(dict : [String : AnyObject]) {
        super.init()
        self.setValuesForKeys(dict)
    }

    override func setValue(_ value: Any?, forKey key: String) {
        if key == "msg" {
            self.msg  = (value as! String).unicodeStr
            mylog((value as! String).unicodeStr)
            return
        }
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    //MARK: fileManage
    func save ()  {
        mylog(self.msg)
        let docuPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
        if let realDocuPath : NSString = docuPath as NSString? {
            let filePath = realDocuPath.appendingPathComponent("homeData.data")
            let isSuccess =  NSKeyedArchiver.archiveRootObject(self , toFile: filePath)
            
            if isSuccess {
                mylog("数据归档成功")
            }else{
                mylog("数据归档失败")
            }
        }else{
            mylog("路径不存在")
        }

    }
    
   class  func read () -> OriginalNetDataModel {
    let dict = ["msg" : "解归档失败,重新创建对象" , "status" : "-200" , "data" : "error" , "additional" : "NULL" ]
        let docuPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
        if let realDocuPath : NSString = docuPath as NSString? {
            let filePath = realDocuPath.appendingPathComponent("homeData.data")
            let object =  NSKeyedUnarchiver.unarchiveObject(withFile:  filePath)
            if let realObjc = object as? OriginalNetDataModel {
                return realObjc
            }else{
                return OriginalNetDataModel.init(dict : dict as [String : AnyObject])
            }
        }else{
            mylog("路径不存在")
            return OriginalNetDataModel.init(dict : dict as [String : AnyObject])
        }
   
    }
   // func copy(with zone: NSZone? = nil) -> Any{
//let tempObj = self.init()
     //   return ""
    //}
    
//MARK:    NSCoding
    func encode(with aCoder: NSCoder){

        aCoder.encode(self.msg, forKey: "msg")
        aCoder.encode(self.data, forKey: "data")
        aCoder.encode(self.status, forKey: "status")
        aCoder.encode(self.additional, forKey: "additional")
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init()
       self.msg =  aDecoder.decodeObject(forKey: "msg") as? String
       self.data = aDecoder.decodeObject(forKey: "data") as AnyObject?
        self.status = aDecoder.decodeInteger(forKey: "status")
        self.additional = aDecoder.decodeObject(forKey: "additional") as AnyObject?
    
    } // NS_DESIGNATED_INITIALIZER

    
//    override var description: String{
//        return String.init("\(status)\(msg)\(data)")
//    
//    }
    
}
