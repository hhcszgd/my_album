//
//  GDSkipManager.swift
//  zjlao
//
//  Created by WY on 17/1/15.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit

class GDSkipManager: NSObject {
    
    class func skip(viewController : UIViewController , model : GDBaseModel){
        guard var realActionKey = model.actionkey else {
            mylog("actionKey为空")
            return
        }
//        mylog("当前actionKey为\(model.actionkey)")
        
        if model.judge && !Account.shareAccount.isLogin {
            mylog("当前处于登录状态 , 执行跳转")
            realActionKey = "Login"
        }
        
        var targetVC : GDBaseVC?
        
        switch realActionKey {
        case "goodscollect" , "shopcollect" , "focusbrand" , "pay", "ship", "receive", "comment", "over", "balance", "coupons", "coins", "help" , "order" , "my_capital" , "member_club" , "webpage" : //webViewVC

            targetVC = GDBaseWebVC()
            
            break
        case "ProvisionVC"://
            targetVC = ProvisionVC()
            break
            
        case "info"://查看用户信息
            mylog("跳转到个人信息页面")
            break
        case "QRCodeScannerVC":
            targetVC = QRCodeScannerVC()
            break
        case "set":
            targetVC = SettingVC()
            break
        case "Login"://执行登录操作
            mylog("执行登录操作")
            let loginVC = LoginVC()
            let loginNaviVC = LoginNaviVC(rootViewController: loginVC)
            loginNaviVC.navigationBar.isHidden = true
            viewController.navigationController?.present(loginNaviVC, animated: true, completion: nil)
            return
        //            break
        case "ChooseLuanguageVC":
            targetVC = ChooseLanguageVC()
            break
        case "GDMapVC":
            targetVC = GDMapVC()
            break
        case "GDCircleDetailVC":
            targetVC = GDCircleDetailVC()
            break
            
        case "GDMideaDetailVC":
            targetVC = GDMideaDetailVC()
            break
        case "DayMediaDetailVC":
            targetVC = DayMediaDetailVC()
            break
            
        case "GDUserHistoryVC":
            targetVC = GDUserHistoryVC()
            break
        case "GDSetUserinfoVC":
            targetVC = GDSetUserinfoVC()
            break
            
        case "GDCreateCircleVC":
            targetVC = GDCreateCircleVC()
            break
            
            
        case "GDCircleDetailVC2":
            targetVC = GDCircleDetailVC2()
            break
            
            
        case "GDAllCirclesVC":
            targetVC = GDAllCirclesVC()
            break
            
            
        case "GDPhotoPickerVC":
            targetVC = GDPhotoPickerVC()
            break
        default:
            mylog("\(realActionKey)是无效actionKey ,找不到跳转控制器")
        }
        
        if let vc = targetVC {
            vc.keyModel = model
            if let naviVC  = viewController as? UINavigationController {
                naviVC.pushViewController(vc, animated: true )
            }else{
                if viewController.navigationController != nil {
                    viewController.navigationController?.pushViewController(vc, animated: true )
                }else{
                    viewController.present(vc, animated: true , completion: { 
                        
                    })
                }
            }
        }
        
    }
    

}
