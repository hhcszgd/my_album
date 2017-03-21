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
        mylog("\(model.keyparamete)")
        guard var realActionKey = model.actionkey else {
            mylog("actionKey为空")
            return
        }
        mylog("当前actionKey为\(model.actionkey)")
        
        if model.judge && !Account.shareAccount.isLogin {
            mylog("当前处于登录状态 , 执行跳转")
            realActionKey = "Login"
        }
        
        var targetVC : GDBaseVC?
        
        switch realActionKey {
        case "goodscollect" , "shopcollect" , "focusbrand" , "pay", "ship", "receive", "comment", "over", "balance", "coupons", "coins", "help" , "order" , "my_capital" , "member_club" , "webpage" : //webViewVC
            //            targetVC = BaseWebVC(vcType: VCType.withBackButton , model : model )
            //            targetVC = BaseWebVC(vcType: VCType.withBackButton)
            targetVC = GDBaseWebVC()
            
            break
        case "info"://查看用户信息
            mylog("跳转到个人信息页面")
            break
        case "QRCodeScannerVC":
            //            targetVC = QRCodeScannerVC(vcType: VCType.withBackButton)
            targetVC = QRCodeScannerVC()
            break
        case "set":
            //            mylog("跳转到设置")
            //            targetVC = SettingVC(vcType: VCType.withBackButton)
            
            targetVC = SettingVC()
            break
            //        case <#pattern#>:
            //            <#code#>
            //        case <#pattern#>:
            //            <#code#>
            //        case <#pattern#>:
            //            <#code#>
            //        case <#pattern#>:
            //            <#code#>
            //        case <#pattern#>:
            //            <#code#>
            //        case <#pattern#>:
        //            <#code#>
        case "Login"://执行登录操作
            mylog("执行登录操作")
            //            let loginVC = LoginVC(vcType: VCType.withBackButton)
            let loginVC = LoginVC()
            let loginNaviVC = LoginNaviVC(rootViewController: loginVC)
            loginNaviVC.navigationBar.isHidden = true
            viewController.navigationController?.present(loginNaviVC, animated: true, completion: nil)
            return
        //            break
        case "ChooseLuanguageVC":
            //            targetVC = ChooseLanguageVC(vcType: VCType.withBackButton)
            targetVC = ChooseLanguageVC()
            break
        default:
            mylog("\(realActionKey)是无效actionKey ,找不到跳转控制器")
        }
        
        if let vc = targetVC {
            vc.keyModel = model
            if let naviVC  = viewController as? UINavigationController {
                naviVC.pushViewController(vc, animated: true )
            }else{
                viewController.navigationController?.pushViewController(vc, animated: true )
            }
        }
        
    }
    

}
