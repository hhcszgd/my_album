  //
//  AppDelegate.swift
//  mh824appWithSwift
//
//  Created by wangyuanfei on 16/10/24.
//  Copyright © 2016年 www.16lao.com. All rights reserved.
//

import UIKit
import CoreData

import MBProgressHUD
import UserNotifications
import AFNetworking
import XMPPFramework
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , AfterChangeLanguageKeyVCDidApear,UNUserNotificationCenterDelegate{
    
    //MARK:////////////////////////////////////属性相关//////////////////////////////////////////
    
    
    var window: UIWindow?
    
    
    
    //MARK:////////////////////////////////////XXXXXX相关//////////////////////////////////////////
    
    
    
    //MARK:////////////////////////////////////jpush相关//////////////////5fc08fd5a94d030233aaee98////////////////////////
    func setupJpush(launchOptions: [UIApplicationLaunchOptionsKey: Any]?)   {
        JPUSHService.setup(withOption: launchOptions, appKey: "9ddc23d468957b06e24131d6", channel: "WYAppStore", apsForProduction: true, advertisingIdentifier: nil)
        //        JPUSHService.setup(withOption: launchOptions, appKey: "97771ee938d1dc6354c0451d", channel: "WYAppStore", apsForProduction: true)
    }
    
    
    
    
    
    //MARK:////////////////////////////////////原生推送相关//////////////////////////////////////////
    func setupOriginPushNotification()  {
        if #available(iOS 10.0, *){
            let novifiCenter = UNUserNotificationCenter.current()
            novifiCenter.delegate = self
            novifiCenter.requestAuthorization(options: [UNAuthorizationOptions.alert , UNAuthorizationOptions.sound , UNAuthorizationOptions.badge], completionHandler: { (resule, error) in
                if(resule ){
//                    mylog("成功")
                }else{
//                    mylog("注册失败\(error)")
                }
            })
        }else{
            
            let setting = UIUserNotificationSettings(types: [UIUserNotificationType.alert ,UIUserNotificationType.badge , UIUserNotificationType.sound ], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(setting)
        }
        UIApplication.shared.registerForRemoteNotifications()
        
    }
    
    
    
    
    
    //MARK:////////////////////////////////////iOS10接收远程推送相关//////////////////////////////////////////
    
    @available(iOS 10.0, *)//程序在前台的通知
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void){
        let userInfo = notification.request.content.userInfo
//        GDAlertView.alert(userInfo.description, image: nil, time: 4, complateBlock: nil)
//        GDKeyVC.share.mainTabbarVC?.tabBar.items?.last?.badgeValue = ""
        GDKeyVC.share.settabBarItem(number: "" , index: 4)
        if notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self) ?? false {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        mylog("程序在前台时 : ios10 接收到的远程推送\(userInfo)")
        completionHandler(UNNotificationPresentationOptions.sound)
        //MARK:设置红点
//        GDKeyVC.share.mainTabbarVC?.tabBar.items?.last?.badgeValue = ""

    }
    
    
    // The method will be called on the delegate @objc @objc @objc @objc @objc @objc @objc @objc @objc when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from applicationDidFinishLaunching:.
    @available(iOS 10.0, *)//程序在后台或退出时的通知
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void){
        let userInfo = response.notification.request.content.userInfo
        // MARK: 注释 : 弹框调试信息
//        GDAlertView.alert(userInfo.description, image: nil, time: 4, complateBlock: nil)
        if response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self) ?? false {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        mylog("程序在后台时 : ios10 接收到的远程推送\(userInfo)")
        completionHandler()
        self.dealWithRemoteNotification(userInfo: userInfo)
    }
    
    
    
    
    //MARK:////////////////////////////////////iOS8,9接收远程推送相关//////////////////////////////////////////
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        JPUSHService.handleRemoteNotification(userInfo)
        mylog("iOS 8 , 9 接收到的远程推送\(userInfo)")
        completionHandler(UIBackgroundFetchResult.newData)
        if application.applicationState != UIApplicationState.active {//后台
//            GDKeyVC.share.mainTabbarVC?.tabBar.items?.last?.badgeValue = ""
            self.dealWithRemoteNotification(userInfo: userInfo)
        }else{//前台
            //MARK:设置红点
//            GDKeyVC.share.mainTabbarVC?.tabBar.items?.last?.badgeValue = ""
            GDKeyVC.share.settabBarItem(number: "" , index: 4)
        }
    }
    

    
    
    
    
    //MARK:////////////////////////////////////处理远程推送相关//////////////////////////////////////////
    func dealWithRemoteNotification(userInfo : [AnyHashable : Any]) {
//        if !Account.shareAccount.isLogin {
//            GDAlertView.alert("请登录", image: nil, time: 2, complateBlock: nil)
//        }
//        if UIApplication.shared.applicationIconBadgeNumber > 0  {
//            
//            GDKeyVC.share.mainTabbarVC?.tabBar.items?.last?.badgeValue = ""
//        }else{
//            GDKeyVC.share.mainTabbarVC?.tabBar.items?.last?.badgeValue = ""
//        }
        
        self.analysisData(userinfo: userInfo)
        

    }


    // MARK: 注释 : 解析推送消息
    func analysisData (userinfo : [AnyHashable : Any] ) {
        
        
        
        if let actionkey = userinfo["actionkey"] {
            
            if let actionkeyStr = actionkey as? String {
                if  actionkeyStr == "orderlist" {
                    if let value  = userinfo["value"] {
                        mylog("gaood成功\(value)")
//                        let subWebVC = SubOrderListVC(vcType : VCType.withBackButton)
//                        if let url  = value as? String {
//                            subWebVC.originUrl = url
//                            KeyVC.share.pushViewController(subWebVC, animated: true )
//                            
//                        }else{mylog("\(actionkeyStr)对应的value转字符串失败")}
                    }else{mylog("\(actionkeyStr)对应的value为空")}
                }else if (actionkeyStr == "im"){
                    
                    if let value  = userinfo["value"] {
                        mylog("good成功\(value)")
//                        let chatVC  = ChatVC()
                        if value is String {
//                            let jid : XMPPJID = XMPPJID.init(user: user , domain: "jabber.zjlao.com", resource: "ios")
//                            chatVC.userJid = jid
//                            KeyVC.share.pushViewController(chatVC, animated: true )
                        
                        }else{mylog("\(actionkeyStr)对应的value转字符串失败")}
                    }else{mylog("\(actionkeyStr)对应的value为空")}
                    
                }
            }else{mylog("actionkey  any类型转string类型失败")}
            
            
            
        }else {
            mylog("解析actinkey失败")
            //先跳到个人中心
            GDKeyVC.share.selectChildViewControllerIndex(index: 4)
        }
    }

    
    //MARK:////////////////////////////////////XXXXXX相关//////////////////////////////////////////
    
    
    
    
    
    
    //MARK:////////////////////////////////////通用链接相关//////////////////////////////////////////
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool{
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            let webPageUrl = userActivity.webpageURL
            let host = webPageUrl?.host
            if let hostStr = host  {
                if hostStr == "zjlao.com" || hostStr == "www.zjlao.com" || hostStr == "m.zjlao.com" || hostStr == "items.zjlao.com" {
                    
                    /*
                     //进行我们需要的处理
                     NSLog(@"_%d_%@",__LINE__,@"通用链接测试成功");
                     NSLog(@"_%d_%@",__LINE__,webpageURL.absoluteString);
                     NSURLComponents * components = [NSURLComponents componentsWithString:webpageURL.absoluteString];
                     NSArray * queryItems =  components.queryItems;
                     NSString * actionkey =  nil ;
                     NSString * ID = nil ;
                     for (NSURLQueryItem * item  in queryItems) {
                     if ([item.name isEqualToString:@"actionkey"]) {
                     if ([item.value isEqualToString:@"shop"]) {
                     actionkey = @"HShopVC";
                     }else if ([item.value isEqualToString:@"goods"]){
                     actionkey = @"HGoodsVC";
                     }else{
                     actionkey = item.value;
                     }
                     NSLog(@"_%d_%@",__LINE__,item.value);
                     }else if ([item.name isEqualToString:@"ID"]){
                     ID = item.value;
                     NSLog(@"_%d_%@",__LINE__,item.value);
                     }
                     
                     NSLog(@"_%d_%@",__LINE__,item.name);
                     NSLog(@"_%d_%@",__LINE__,item.value);
                     }
                     if (actionkey && ID ) {
                     BaseModel * model = [[[BaseModel alloc] init]initWithDict:@{@"actionkey":actionkey,@"paramete":ID}];
                     model.actionKey = actionkey;
                     model.keyParamete = @{@"paramete":ID};
                     [[SkipManager shareSkipManager] skipByVC:[KeyVC shareKeyVC] withActionModel:model];
                     }
                     
                     */
                    
                }else{
                    if UIApplication.shared.canOpenURL(webPageUrl!) {
                        UIApplication.shared.openURL(webPageUrl!)
                    }
                
                }
            }
        }
        
        return true
    }
    
    
    //MARK:////////////////////////////////////初始化一次//////////////////////////////////////////
    func initAccountInfo()  {
//        if   GDNetworkManager.shareManager.token != nil && GDNetworkManager.shareManager.token != "nil"{//不判断了,当手机在别处被找回时有问题
            GDNetworkManager.shareManager.QZFirstInit({ (model) in
                mylog("首次调用初始化接口成功 status:\(model.status) message:\(String(describing: model.message)) data:\(String(describing: model.data))")
                if model.status == 202 {
                    Account.shareAccount.resetAccountStatus(status: AccountStatus.authenticated)
                }else if (model.status == 310){
                    Account.shareAccount.resetAccountStatus(status: AccountStatus.unAuthenticated)
                }else if (model.status == 203){
                    Account.shareAccount.resetAccountStatus(status: AccountStatus.halfAuthenticated)
                }else if (model.status == 307){
                    Account.shareAccount.resetAccountStatus(status: AccountStatus.unAuthenticated)
                }else{
                    Account.shareAccount.resetAccountStatus(status: AccountStatus.unAuthenticated)
                }
            }) { (error) in
                mylog("首次调用初始化接口出错:\(error)")
                
            }
//        }

//        GDNetworkManager.shareManager.QZGetAuthcode(mobile: "", { (model) in
//            mylog("获取验证码成功:\(model.data)")
//
//        }) { (error) in
//             mylog("获取验证码出错:\(error)")
//        }
//        GDNetworkManager.shareManager.QZAuthentication(mobile: "", authCode: "", { (model) in
//            
//        }) { (error) in
//            
//        }

    }
    
    //MARK:////////////////////////////////////网络监测相关//////////////////////////////////////////
    func initnetWorkManager() {
                    NotificationCenter.default.addObserver(GDNetworkManager.self, selector: #selector(GDNetworkManager.noticeNetworkChanged(_:)), name: NSNotification.Name.AFNetworkingReachabilityDidChange, object: nil)
               AFNetworkReachabilityManager.shared().startMonitoring()
    }
    
    
    func setupRootVC() -> () {
        
            self.dealwithLocation()
        
//        self.window = nil
//        self.window = UIWindow(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
//        self.window!.rootViewController = GDKeyVC.share
//        self.window!.makeKeyAndVisible()

    }
    
    func dealwithLocation()  {
//        if !CLLocationManager.locationServicesEnabled() {//GPS不可用 ,设备不支持
//            self.window = nil
//            self.window = UIWindow(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
//            self.window!.rootViewController = GDSetupGPSVC()
//            //请打开gps定位功能
//            self.window!.makeKeyAndVisible()
//            mylog("gps定位功能不可用")
//        }else{//GPS可用
//            if GDLocationManager.share.authorizationStatus() == CLAuthorizationStatus.authorizedAlways || GDLocationManager.share.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse{//app定位功能可用
    
                self.initializationAccountInfo()
//                mylog("app定位功能可用")
//
//            }else{//app定位功能不可用 ,请前往设置中心打开app使用位置权限
//                NotificationCenter.default.addObserver(self , selector: #selector(authorizationStatusChanged(status:)), name: GDLocationManager.GDAuthorizationStatusChanged, object: nil)
//                GDLocationManager.share.startUpdatingLocation()
//
//                self.window = nil
//                self.window = UIWindow(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
//                self.window!.rootViewController = GDSetupLocationEnableVC()
//                //请打开gps定位功能
//                self.window!.makeKeyAndVisible()
//                mylog("app没有定位权限")
//            }
//        }
    

    }
    @objc func authorizationStatusChanged(status : CLAuthorizationStatus)  {
        
            if CLLocationManager.locationServicesEnabled() {
                switch CLLocationManager.authorizationStatus() {
                case CLAuthorizationStatus.authorizedAlways:
                    mylog("现在是前后 台定位服务")
                    GDLocationManager.share.startUpdatingLocation()
                    
                    self.initializationAccountInfo()
                case CLAuthorizationStatus.authorizedWhenInUse:
                    mylog("现在是前 台定位服务")
                    GDLocationManager.share.startUpdatingLocation()

                    self.initializationAccountInfo()
                    
                case CLAuthorizationStatus.denied:
                    mylog("现在是用户拒绝使用定位服务")
                case CLAuthorizationStatus.notDetermined:
                    mylog("用户暂未选择定位服务选项")
                case CLAuthorizationStatus.restricted:
                    mylog("现在是用户可能拒绝使用定位服务")
                }
            }else{
                mylog("请开启手机的定位服务")
            }
            
    }
    
    func initializationAccountInfo()  {
//        if Account.shareAccount.accountStatus == AccountStatus.authenticated {
//            if self.window?.rootViewController != GDKeyVC.share {
//                self.window = nil
//                self.window = UIWindow(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
//                self.window!.rootViewController = GDKeyVC.share
//                self.window!.makeKeyAndVisible()
//            }
//            return
//        }
        
//        GDLocationManager.share.startUpdatingLocation()
        GDNetworkManager.shareManager.QZFirstInit({ (model) in//之所以先初始化, 是怕手机在别的设备被找回
            mylog("首次调用初始化接口成功 status:\(model.status) message:\(String(describing: model.message)) data:\(String(describing: model.data))")
            if model.status == 202 {//用户已存在
                Account.shareAccount.resetAccountStatus(status: AccountStatus.authenticated)
            }else if (model.status == 310){//用户不存在
                Account.shareAccount.resetAccountStatus(status: AccountStatus.unAuthenticated)
            }else if (model.status == 203){
                Account.shareAccount.resetAccountStatus(status: AccountStatus.halfAuthenticated)
            }else if (model.status == 307){//设备id为空
                Account.shareAccount.resetAccountStatus(status: AccountStatus.unAuthenticated)
            }else{
                Account.shareAccount.resetAccountStatus(status: AccountStatus.unAuthenticated)
            }
            
            
            
            if Account.shareAccount.accountStatus == AccountStatus.authenticated {
                if self.window?.rootViewController != GDKeyVC.share {
                    self.window = nil
                    self.window = UIWindow(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
                    self.window!.rootViewController = GDKeyVC.share
                    self.window!.makeKeyAndVisible()
                }
            }else {//认证,上传头像和昵称
                if let _ =  self.window?.rootViewController as? GDSetupUserInfoVC {
                }else{
//                    GDNetworkManager.shareManager.QZFirstInit({ (result ) in
//                        mylog(result.data)
//                        mylog(result.status)
//                        if (result.status == 202){//用户名,头像手机都认证完毕
//                            if self.window?.rootViewController != GDKeyVC.share {
//                                self.window = nil
//                                self.window = UIWindow(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
//                                self.window!.rootViewController = GDKeyVC.share
//                                self.window!.makeKeyAndVisible()
//                            }
//                        }else{//从未认证 , 或者只认证手机 , 没上传头像和设置用户名
                            self.window = nil
                            self.window = UIWindow(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
                            self.window!.rootViewController = LoginVCFirstLaunch()
                            self.window!.makeKeyAndVisible()
//                        }
//                    }, failure: { (error ) in
//                        mylog(error)//网络连接失败
//                    })
                }
                
            }

            
            
            
        }) { (error) in
            mylog("首次调用初始化接口出错:\(error)")
            
        }
        
        
        
    }
    
    //MARK:////////////////////////////////////////////更改语言相关//////////////////////////////////////////////////////
    
    
    
    
    //    func performChangeLanguage(targetLanguage : String)  {
    //
    //
    //        let noticStr_currentLanguageIs = NSLocalizedString("currentLanguageIs", tableName: LanguageTableName, bundle: Bundle.main, value:"", comment: "") // 提示语 中文的话 :@"当前语言是"   , 英文的花 : @"currentLanguageIs" (提示语也要国际化)
    //        let noticeStr_changeing = NSLocalizedString("languageChangeing", tableName: LanguageTableName, bundle: Bundle.main, value:"", comment: "") // 提示语 中文的话 @"语言更改中"  英文的话 @"languageChangeing" (提示语也要国际化)
    //
    //
    //        if targetLanguage == LanguageTableName && targetLanguage == LFollowSystemLanguage {//切换前后语言相同 , 除了提示之外不做任何变化
    //            GDAlertView.alert("重启app以生效", image: nil, time: 2, complateBlock: nil)
    //        }else if targetLanguage == LanguageTableName {//切换前后语言相同 , 除了提示之外不做任何变化
    //            GDAlertView.alert("\(noticStr_currentLanguageIs)\(GDLanguageManager.titlebyKey(key: LLanguageID))", image: nil, time: 2, complateBlock: nil)
    //
    //        }else if (targetLanguage == LFollowSystemLanguage){//由自定义语言切换为跟随系统语言
    //            if targetLanguage ==  GDLanguageManager.gotcurrentSystemLanguage() {//当切换前的自定义语言跟当前系统语言一样时 ,只保存 ,不重新切换 (如何获取系统语言??)
    //                GDStorgeManager.standard.set(LFollowSystemLanguage, forKey: "LanguageTableName")
    //            }else{//否则即保存又重新切换
    //                UserDefaults.standard.set(LFollowSystemLanguage, forKey: "LanguageTableName")
    ////                performChangeTheLanguage(targetLanguageTableName:targetLanguage)
    ////                self.resetKeyVC()
    ////                //                alert("\(noticeStr_changeing)", time: 3)
    ////                self.showNotic(autoHide: false, showStr:"\(noticeStr_changeing)" )
    //            }
    //            GDAlertView.alert("重启app以生效", image: nil, time: 2, complateBlock: nil)
    //        }else{//切换为自定义语言
    //            let oldLanguageName = LanguageTableName
    //            UserDefaults.standard.set(targetLanguage, forKey: "LanguageTableName")
    //            if  GDLanguageManager.titlebyKey(key: LLanguageID)  != nil {
    //                if GDLanguageManager.titlebyKey(key: LLanguageID) == "languageID"  {//gotTitleStr(key:)这个方法如果找不到键所对应的值 , 就把键返回,同时也说明本地没有相应的语言包
    //                    GDAlertView.alert("没有相应的语言包", image: nil, time: 2, complateBlock: nil)
    //                    UserDefaults.standard.set(oldLanguageName, forKey: "LanguageTableName")//顺便改回原来的语言
    //                }else{
    //                     UserDefaults.standard.set(targetLanguage, forKey: "LanguageTableName")
    //                    self.resetKeyVC()
    //                    //                alert("\(noticeStr_changeing)", time: 3)
    //                    self.showNotic(autoHide: false, showStr:"\(noticeStr_changeing)" )
    //                }
    //            }else{
    //                GDAlertView.alert("没有相应的语言包", image: nil, time: 2, complateBlock: nil)
    //                UserDefaults.standard.set(oldLanguageName, forKey: "LanguageTableName")//顺便改回原来的语言
    //            }
    //
    //        }
    //
    //    }
    
//    func resetKeyVC() {
//        let mainTabbarVC = MainTabbarVC()
//        let keyVC = KeyVC(rootViewController: mainTabbarVC)
//        keyVC.keyVCDelegate = self
//        keyVC.mainTabbarVC = mainTabbarVC
//        mainTabbarVC.delegate = keyVC
//        UIApplication.shared.keyWindow!.rootViewController = keyVC
//    }
    var hub : MBProgressHUD?
    func showNotic(autoHide : Bool , showStr : String) -> () {
        //        changeLanguageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        if hub == nil {
            
        }
        hub  = MBProgressHUD.showAdded(to: window!, animated: true)
        hub?.detailsLabel.text = showStr
        hub?.mode = MBProgressHUDMode.text
        if autoHide {
            hub?.hide(animated: true, afterDelay: TimeInterval(3))
        }else{
            
        }
    }
    func hidNotice() -> () {
        hub?.hide(animated: true)
    }
    func languageHadChanged() {
        self.hidNotice()
    }
    
    //MARK:////////////////////////////////////appDelegate代理方法//////////////////////////////////////////
    func showTime()  {
        self.window = nil
        self.window = UIWindow(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        let showvc = GDLaunchVC()
        self.window!.rootViewController = showvc
        //请打开gps定位功能
        self.window!.makeKeyAndVisible()
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        print("\(UIDevice.current.identifierForVendor?.uuidString)")
//        self.showTime()//相册版先注释
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            //        UserDefaults.standard.set(nil, forKey: "LanguageTableName")
            self.setupRootVC()
            self.initnetWorkManager()
            //        self.initAccountInfo()
            self.setupJpush(launchOptions: launchOptions)
            self.setupOriginPushNotification()
            
//        }

        // Override point for customization after application launch.
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let device_ns = NSData.init(data: deviceToken)
        let token:String = device_ns.description.trimmingCharacters(in: CharacterSet(charactersIn: "<>" ))//需要传给服务器
//        GDNetworkManager.shareManager.saveDeviceTokenAndRegisterID(deviceToken: token , registerID: nil , { (respodsData) in
//            mylog("deviceToken\(respodsData.message)")
//        }, failure: { (error ) in
//            mylog("deviceToken保存失败\(error)")
//        })
        
        mylog(token)
        JPUSHService.registerDeviceToken(deviceToken)
        //        [registrationIDCompletionHandler:]?
        JPUSHService.registrationIDCompletionHandler { (respondsCode, registrationID) in
            mylog("极光注册远程通知成功后获取的注册ID\(String(describing: registrationID))\n\n状态码是\(respondsCode)")//需要传给服务器
            
            
            GDNetworkManager.shareManager.changeUserinfo( registration_id: registrationID, { (result) in
                mylog("保存极光id回调\(result.status)")
                mylog("保存极光id回调\(String(describing: result.data))")
            }, failure: { (error) in
                mylog("保存极光id失败\(error)")
            })
//            GDNetworkManager.shareManager.saveDeviceTokenAndRegisterID(deviceToken: nil , registerID: registrationID, { (respondsData) in
//                mylog("registrationID\(respondsData.message)")
//            }, failure: { (error ) in
//                mylog("registrationID保存失败\(error)")
//            })
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        mylog("注册远程推送失败\(error)")
    }

    
    
    func applicationWillResignActive(_ application: UIApplication) {
        isNeedReloadData = false
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        mylog("程序从后台状态即将进入前台")
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        mylog("程序变成活跃状态")
        JPUSHService.resetBadge()
        if UIApplication.shared.applicationIconBadgeNumber > 0  {
//            GDKeyVC.share.mainTabbarVC?.tabBar.items?.last?.badgeValue = ""
            GDKeyVC.share.settabBarItem(number: "" , index: 4)
        }
        application.applicationIconBadgeNumber = 0
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    
    
    
    //MARK:////////////////////////////////////coreData相关//////////////////////////////////////////
    
    
    
    
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.16lao.new.mh824appWithSwift" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "mh824appWithSwift", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
}

class GDSetupGPSVC: UIViewController{
    let tipLbl  = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tipLbl)
        self.view.backgroundColor = UIColor.white
        self.tipLbl.textAlignment = NSTextAlignment.center
        self.tipLbl.text = "gps功能不可用"
        self.tipLbl.frame = self.view.bounds
    }
    
}
class GDSetupLocationEnableVC: UIViewController{
    
    let tipLbl  = UIButton()
    let skipButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tipLbl)
        self.view.addSubview(skipButton)
        self.view.backgroundColor = UIColor.white
        //        self.tipLbl.textAlignment = NSTextAlignment.center
        //        self.tipLbl.text = "gps功能不可用"
        self.tipLbl.setTitle("开启定位", for: UIControlState.normal )
        self.skipButton.setTitle("跳过", for: UIControlState.normal)
        self.skipButton.titleLabel?.font = GDFont.systemFont(ofSize: 13)
        self.tipLbl.titleLabel?.font = GDFont.systemFont(ofSize: 13)
        self.tipLbl.titleLabel?.numberOfLines = 10
        self.tipLbl.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        self.skipButton.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        self.tipLbl.addTarget(self , action: #selector(gotoSetting), for: UIControlEvents.touchUpInside)
        self.skipButton.addTarget(self , action: #selector(performSkip), for: UIControlEvents.touchUpInside)
        self.tipLbl.bounds  = CGRect(x: 0, y: 0, width: self.view.bounds.size.width / 2 - 30, height: 30)
        self.skipButton.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.size.width / 2 - 30 , height: 30)
        self.skipButton.center = CGPoint(x: 10 + (self.view.bounds.size.width / 2 - 10 ) / 2, y: self.view.bounds.size.height / 2)
        self.tipLbl.center = CGPoint(x: self.view.bounds.size.width / 2  + (self.view.bounds.size.width / 2 - 10 ) / 2, y: self.view.bounds.size.height / 2)
        
        self.skipButton.backgroundColor = UIColor.init(red: 0.3, green: 0.8, blue: 0.8, alpha: 1)
        self.tipLbl.backgroundColor = self.skipButton.backgroundColor
    }
    @objc func performSkip()  {
        self.setKeyvcToMain()
    }
    @objc func gotoSetting(){
        //        UIApplicationOpenSettingsURLString
        //        NSURL *url= [NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
        //        if( [[UIApplicationsharedApplication]canOpenURL:url] ) {
        //
        //            [[UIApplicationsharedApplication]openURL:url];
        //        }
        let url : URL = URL(string: UIApplicationOpenSettingsURLString)!
        if UIApplication.shared.canOpenURL(url ) {
            UIApplication.shared.openURL(url)
        }
    }
    func setKeyvcToMain()  {
        let appDelegateOption = UIApplication.shared.delegate
        if let appDelegate  = appDelegateOption {
            if let realAppdelegate = appDelegate as? AppDelegate {
                if realAppdelegate.window?.rootViewController != GDKeyVC.share {
                    realAppdelegate.window = nil
                    realAppdelegate.window = UIWindow(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
                    realAppdelegate.window!.rootViewController = GDKeyVC.share
                    realAppdelegate.window!.makeKeyAndVisible()
                }
                
            }
            
        }
    }
}

enum GDSetInfoSatatus : Int {
    case Mobile
    case Name
}

class GDSetupUserInfoVC: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    let containerView = UIView()
    
    let titleLbl  = UILabel()
    let mobileOrNameInputTipLbl  = UILabel()
    let mobileOrNameInput = UITextField()
    
    let authCodeInputTipLbl = UILabel()
    let authCodeInput = UITextField()
    let getAuthCodeButton = UIButton()
    let provisionButton = UIButton()
    
    let czButton = UIButton()
    let czLeftButton = UIButton()
    let czRightButton = UIButton()
    
    let tipsMsgButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSubviewsFrame()

        
        if (Account.shareAccount.accountStatus == AccountStatus.unAuthenticated){//继续上传头像和昵称
            mylog("开始认证手机     和设置头像用户名了哦")
            self.bandMobile()
        }else if (Account.shareAccount.accountStatus == AccountStatus.halfAuthenticated){//执行头像用户名认证
            mylog("开始设置头像用户名了哦")
            self.setupIconAndName()
        }
        
        
    }
    func setupSubviewsFrame()  {
        self.view.backgroundColor = UIColor.black
        self.containerView.backgroundColor = UIColor.white
        self.titleLbl.textAlignment = NSTextAlignment.center
        self.titleLbl.textColor = UIColor.white
        self.view.addSubview(containerView)
        self.containerView.addSubview(titleLbl)
        self.containerView.addSubview(mobileOrNameInputTipLbl)
        self.containerView.addSubview(mobileOrNameInput)
        self.containerView.addSubview(authCodeInputTipLbl)
        
        getAuthCodeButton.backgroundColor = UIColor.orange
        getAuthCodeButton.setTitle("获取验证码", for: UIControlState.normal)
        getAuthCodeButton.setTitleColor(UIColor.black, for: UIControlState.disabled)
        getAuthCodeButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.containerView.addSubview(authCodeInput)
        self.containerView.addSubview(getAuthCodeButton)
        self.setupProvisionButton()
        self.containerView.addSubview(czButton)
        self.containerView.addSubview(czLeftButton)
        self.containerView.addSubview(czRightButton)
        self.containerView.addSubview(tipsMsgButton)
        
        
        
        self.czRightButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        self.czLeftButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        let margin : CGFloat  = 10
        let containerW = SCREENWIDTH - margin * 2
        let containerH = SCREENHEIGHT * 0.7
        let containerX = margin
        let containerY = SCREENHEIGHT * 0.3
        self.containerView.frame = CGRect(x: containerX, y: containerY, width: containerW, height: containerH)
        
        self.titleLbl.frame = CGRect(x: 0, y: -self.titleLbl.font.lineHeight * 1.8, width: containerW, height: self.titleLbl.font.lineHeight)
        
        let mobileInputW = containerW * 0.75
        self.mobileOrNameInputTipLbl.frame = CGRect(x: (containerW - mobileInputW ) / 2, y: 44, width: mobileInputW, height: self.mobileOrNameInputTipLbl.font.lineHeight)
        
        self.mobileOrNameInput.frame = CGRect(x: (containerW - mobileInputW ) / 2, y: self.mobileOrNameInputTipLbl.frame.maxY + 22, width: mobileInputW, height: 38)
        _ = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 10))
//        leftView.backgroundColor = UIColor.red
//        self.mobileOrNameInput.leftViewMode = UITextFieldViewMode.always
//        self.mobileOrNameInput.leftView = leftView
        self.mobileOrNameInput.borderStyle = UITextBorderStyle.roundedRect
            self.mobileOrNameInput.layer.borderWidth = 1
        self.mobileOrNameInput.layer.borderColor = UIColor.lightGray.cgColor
        
        self.authCodeInputTipLbl.frame = CGRect(x: (containerW - mobileInputW ) / 2, y: self.mobileOrNameInput.frame.maxY + 33, width: mobileInputW, height: self.mobileOrNameInputTipLbl.font.lineHeight)
        
        let authButtonW = (mobileInputW - 10 ) / 2
        self.authCodeInput.frame = CGRect(x: self.mobileOrNameInputTipLbl.frame.minX, y: self.authCodeInputTipLbl.frame.maxY + 22 , width: authButtonW, height: 38)
        self.authCodeInput.layer.borderWidth = 1
        self.authCodeInput.borderStyle = UITextBorderStyle.roundedRect
        self.authCodeInput.layer.borderColor = UIColor.lightGray.cgColor
        self.provisionButton.frame = CGRect(x: authCodeInput.frame.minX, y: authCodeInput.frame.maxY, width: authCodeInput.bounds.size.width * 2, height: authCodeInput.bounds.size.height)
        
        self.getAuthCodeButton.frame = CGRect(x: self.authCodeInput.frame.maxX + 10, y: self.authCodeInputTipLbl.frame.maxY + 22 , width: authButtonW, height: 38)
        
        self.czButton.frame = CGRect(x: containerW / 2 - 64 / 2, y: containerH - 64, width: 64, height: 64)
        self.czButton.setImage(UIImage(named: "logo"), for: UIControlState.normal)
        self.czButton.setImage(UIImage(named: "logoJoinGroup"), for: UIControlState.disabled)
        
        self.czLeftButton.frame = CGRect(x: 10, y: self.czButton.frame.minY, width: 64, height: 64)
        
        self.czRightButton.frame = CGRect(x: containerW - 10 - 64, y: self.czButton.frame.minY, width: 64, height: 64)
    }
    
    func setupProvisionButton()  {
        self.containerView.addSubview(provisionButton)
        provisionButton.setTitle("用户使用协议", for: UIControlState.normal)
        provisionButton.setTitleColor(UIColor.blue, for: UIControlState.normal)
        //        provisionButton.backgroundColor = UIColor.green
        provisionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        provisionButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        provisionButton.addTarget(self , action: #selector(provisionDetail), for: UIControlEvents.touchUpInside)
        
    }
    @objc func provisionDetail(){
        let model = GDBaseModel.init(dict: nil )
        model.actionkey = "ProvisionVC"
        model.keyparamete = "http://www.123qz.cn/yinsi.html" as AnyObject//
        GDSkipManager.skip(viewController: self , model: model)
    }
    func bandMobile()  {
        self.titleLbl.text = "验证手机号"
        self.mobileOrNameInputTipLbl.text = "请输入您的手机号码:"
        self.mobileOrNameInput.placeholder = "手机号码"
        self.authCodeInputTipLbl.text = "请输入验证码:"
        self.czLeftButton.setTitle("跳过", for: UIControlState.normal)
        self.czRightButton.setTitle("验证", for: UIControlState.normal)
        self.getAuthCodeButton.addTarget(self , action: #selector(getAuthClick(sender:)), for: UIControlEvents.touchUpInside)
        self.czRightButton.addTarget(self , action: #selector(performAuth(sender:)), for: UIControlEvents.touchUpInside)
        self.czLeftButton.addTarget(self , action: #selector(cancleAuth(sender:)), for: UIControlEvents.touchUpInside)
        self.czButton.isEnabled = false
    }
    
    @objc func cancleAuth(sender:UIButton)  {//取消认证
        
        let appDelegateOption = UIApplication.shared.delegate
        if let appDelegate  = appDelegateOption {
            if let realAppdelegate = appDelegate as? AppDelegate {
                if realAppdelegate.window?.rootViewController == GDKeyVC.share {
                    self.navigationController?.popViewController(animated: true)
                }else{
                    self.setKeyvcToMain()
                    
                }
                
            }
            
        }
    }
    
    func setupIconAndName()  {
        self.titleLbl.text = "请输入您的真实姓名"
        self.mobileOrNameInputTipLbl.text = "我的真实姓名:"
        self.mobileOrNameInput.text = nil
        self.mobileOrNameInput.placeholder = "姓名"
        self.czButton.isEnabled = true
        self.czButton.addTarget(self , action: #selector(getPicture), for: UIControlEvents.touchUpInside)
//        self.czRightButton.addTarget(self , action: #selector(uploadNameAndIcon), for: UIControlEvents.touchUpInside)
        self.authCodeInput.isHidden = true
        self.authCodeInputTipLbl.isHidden = true
        self.czRightButton.isHidden = true
        self.getAuthCodeButton.isHidden = true
        self.czLeftButton.isHidden = true
        
        
    }
//    
//    func uploadNameAndIcon()  {
//        
//    
//    }
    
    @objc func getPicture()  {
        mylog(self.mobileOrNameInput.text)
        if self.mobileOrNameInput.text == nil || self.mobileOrNameInput.text!.isEmpty {
            GDAlertView.alert("请输入您的姓名", image: nil , time: 2, complateBlock: nil)
            return
        }
        let picker = UIImagePickerController.init()
        picker.delegate = self
//        picker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
        if (UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.rear ) || UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.front )){
            picker.sourceType = UIImagePickerControllerSourceType.camera
        }else{
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        picker.allowsEditing = true ;
        UIApplication.shared.keyWindow!.rootViewController!.present(picker, animated: true, completion: nil)

    }
    
    @objc func performAuth(sender:UIButton)  {//验证手机
        //验证手机格式是否正确 todo
        if !self.mobileLawful(mobileStr: self.mobileOrNameInput.text ?? "") {//非法
            if self.mobileOrNameInput.text?.characters.count ?? 0 == 0 {
                GDAlertView.alert("手机号码不能为空", image: nil, time: 2, complateBlock: nil)
            }else{
                GDAlertView.alert("手机号码格式不正确", image: nil, time: 2, complateBlock: nil)
            }
            return
        }
        if !self.authcodeLawful(authCode: self.authCodeInput.text ?? "") {
            if self.authCodeInput.text?.characters.count ?? 0 == 0 {
                    GDAlertView.alert("验证码不能为空", image: nil, time: 2, complateBlock: nil)
            }else{
                GDAlertView.alert("验证码错误", image: nil, time: 2, complateBlock: nil)
            }
            return
        }
        GDNetworkManager.shareManager.QZAuthentication(mobile: self.mobileOrNameInput.text!, authCode: self.authCodeInput.text!, { (result) in
            mylog(result.status)
            mylog(result.data)
            
            if result.status == 200 {//验证通过,设置昵称和用户名
                self.afterAuthMobilePerformInit()
                
            }else if (result.status == 303){//验证码验证不通过
                GDAlertView.alert("验证码错误", image: nil, time: 2, complateBlock: nil)
            }else if (result.status == 306){//用户创建失败
                GDAlertView.alert("操作失败 请重试", image: nil, time: 2, complateBlock: nil)
            }else if (result.status == 314){//坐标不能为空
                GDAlertView.alert("gps异常,请检查定位权限", image: nil, time: 2, complateBlock: nil)
            }else if (result.status == 311){//手机号已被占用 调一下初始化接口,判断是否需要设置昵称和用户名 ,否的话直接跳到主页面
                self.afterAuthMobilePerformInit()
            }

        }) { (error ) in
            mylog(error)
            GDAlertView.alert("操作异常 请重试", image: nil, time: 2, complateBlock: nil )
        }
    }
    
    func afterAuthMobilePerformInit()  {
        GDNetworkManager.shareManager.QZFirstInit({ (result ) in

            if result.status == 202 {
                
                
                let appDelegateOption = UIApplication.shared.delegate
                if let appDelegate  = appDelegateOption {
                    if let realAppdelegate = appDelegate as? AppDelegate {
                        if realAppdelegate.window?.rootViewController == GDKeyVC.share {
//                            self.dismiss(animated: true , completion: {  })
                            self.navigationController?.popViewController(animated: true)
                        }else{
                            self.setKeyvcToMain()
                        }
                    }
                    
                }
            }else if (result.status == 310){
                GDAlertView.alert("操作异常 请重试", image: nil, time: 2, complateBlock: nil )
            }else if (result.status == 203){
                self.setupIconAndName()
            }else if (result.status == 307){
                GDAlertView.alert("操作异常 请重试", image: nil, time: 2, complateBlock: nil )
            }else{
                GDAlertView.alert("操作异常 请重试", image: nil, time: 2, complateBlock: nil )
            }
        }, failure: { (error ) in
            mylog(error )
            GDAlertView.alert("操作异常 请重试", image: nil, time: 2, complateBlock: nil )
        })
    }
    
    var time : Timer?
    var timeInterval : Int = 60
    
    func deleteTimer()  {
        if time?.isValid ?? false  {
            time?.invalidate()
            time = nil
        }
    }
    
    func addTimer()  {
        if time?.isValid ?? false  {
            time?.invalidate()
            time = nil
        }else{
            self.getAuthCodeButton.isEnabled = false
            self.getAuthCodeButton.setTitle("\(self.timeInterval)后重发", for: UIControlState.disabled)
            time = Timer.init(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil , repeats: true)
            RunLoop.main.add(time!, forMode: RunLoopMode.commonModes)
            self.getAuthCodeButton.backgroundColor = UIColor.lightGray
        }
        
    }
    
    @objc func countDown() {
        self.timeInterval -= 1
        if self.timeInterval <= 0  {
            self.getAuthCodeButton.isEnabled = true
            self.getAuthCodeButton.backgroundColor = UIColor.orange
            self.timeInterval = 60
            self.deleteTimer()
        }else{
            self.getAuthCodeButton.setTitle("\(self.timeInterval)后重发", for: UIControlState.disabled)
        }
    }
    
    @objc func getAuthClick(sender:UIButton)  {//获取验证码
        //验证手机格式是否正确 todo
        if !self.mobileLawful(mobileStr: self.mobileOrNameInput.text ?? "") {//非法
            if self.mobileOrNameInput.text?.characters.count ?? 0 == 0 {
                GDAlertView.alert("手机号码不能为空", image: nil, time: 2, complateBlock: nil)
            }else{
                GDAlertView.alert("手机号码格式不正确", image: nil, time: 2, complateBlock: nil)
            }
           _ = self.mobileOrNameInput.text?.trimmingCharacters(in: CharacterSet.whitespaces)
            return
        }
        self.addTimer()
        GDNetworkManager.shareManager.QZGetAuthcode(mobile: self.mobileOrNameInput.text!, { (result) in
            mylog(result.status)
            mylog(result.data)
            if result.status == 200 {//获取成功
//                GDAlertView.alert("验证码发送成功", image: nil, time: 2, complateBlock: nil)
            }else if (result.status == 308){//验证码获取失败
//                GDAlertView.alert("验证码获取失败,请重试", image: nil, time: 2, complateBlock: nil)
                
            }else if (result.status == 301){//手机号码格式不正确
//                GDAlertView.alert("手机号码格式不正确", image: nil, time: 2, complateBlock: nil)
            }else if (result.status == 311){//手机号已被占用, 输入验证码以找回之前账号,验证成功的话,直接跳到首页 , 不用设置用户名和头像
                
//                GDAlertView.alert("手机号已被占用 , 输入验证码以找回之前账号", image: nil, time: 2, complateBlock: nil)//不提示了
                //doNothing
            }else if (result.status == 300){//手机号码不能为空
//                GDAlertView.alert("手机号码不能为空", image: nil, time: 2, complateBlock: nil)
                //doNothing
            }else if (result.status == 303){
                //doNothing
            }
        }) { (error ) in
            mylog(error)
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        return
        
        
    }
    
    
    func setKeyvcToMain()  {
        let appDelegateOption = UIApplication.shared.delegate
        if let appDelegate  = appDelegateOption {
            if let realAppdelegate = appDelegate as? AppDelegate {
                if realAppdelegate.window?.rootViewController != GDKeyVC.share {
                    realAppdelegate.window = nil
                    realAppdelegate.window = UIWindow(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
                    realAppdelegate.window!.rootViewController = GDKeyVC.share
                    realAppdelegate.window!.makeKeyAndVisible()
                }
                
            }
            
        }
    }
    // MARK: 注释 : imagePickerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        mylog(info)
        
        let editImage = info[UIImagePickerControllerEditedImage]
        if let editImageAny  = editImage  {
            if let editImageReal  = editImageAny as? UIImage {
                
                //                let img = UIImage(named: "bg_collocation")
                DispatchQueue.global().async {
                    let data =   UIImageJPEGRepresentation(editImageReal, 0.0) //  UIImagePNGRepresentation(editImageReal)
//                     UIImage(data: data ?? Data())
                    
                    // MARK: 注释 : 插入七牛存储👇
                    GDNetworkManager.shareManager.getQiniuToken(success: { (model ) in
                        
                        if let token = model.data as? String {
                            mylog("获取七牛touken请求的状态码\(model.status)  , data数据 : \(token)")
                            GDNetworkManager.shareManager.uploadAvart(data: data! ,token : token , complite: { (responseInfo, theKey , successInfo) in
                                
                                if successInfo == nil {
                                    GDAlertView.alert("操作失败,请重试", image: nil, time: 2, complateBlock: nil)
                                }else{
                                    if let key = successInfo?["key"] as? String{
                                        print(key)//get avarta key
                                        
//                                      process something start
                                        let dataBase64 = data?.base64EncodedString()
                                        let size = dataBase64?.characters.count
                                        GDNetworkManager.shareManager.uploadAvatar(name: self.mobileOrNameInput.text!, original: key, size: "\(size!)", descrip: "", { (result) in
                                            mylog(result.data)
                                            mylog(result.status)
                                            if (result.status == 200){
                                                GDNetworkManager.shareManager.QZFirstInit({ (result ) in
                                                }, failure: { (error ) in
                                                })
                                                let appDelegateOption = UIApplication.shared.delegate
                                                if let appDelegate  = appDelegateOption {
                                                    if let realAppdelegate = appDelegate as? AppDelegate {
                                                        if realAppdelegate.window?.rootViewController == GDKeyVC.share {
                                                            self.navigationController?.popViewController(animated: true)
                                                        }else{
                                                            self.setKeyvcToMain()
                                                        }
                                                    }
                                                }
                                            }else if (result.status == 316){//用户名不能为空
                                                GDAlertView.alert("操作失败,请重试", image: nil, time: 2, complateBlock: nil)
                                            }else if (result.status == 309){//头像不能为空
                                                GDAlertView.alert("操作失败,请重试", image: nil, time: 2, complateBlock: nil)
                                            }else if (result.status == 319){//头像的大小不能为空
                                                
                                                GDAlertView.alert("操作失败,请重试", image: nil, time: 2, complateBlock: nil)
                                                
                                            }else if (result.status == 320){//头像的格式不能为空
                                                GDAlertView.alert("操作失败,请重试", image: nil, time: 2, complateBlock: nil)
                                            }else if (result.status == 323){//用户所在国家不能为空
                                                GDAlertView.alert("操作失败,请重试", image: nil, time: 2, complateBlock: nil)
                                            }else if (result.status == 314){//用户的坐标不能为空
                                                GDAlertView.alert("操作失败,请重试", image: nil, time: 2, complateBlock: nil)
                                            }else if (result.status == 306){//更新失败
                                                GDAlertView.alert("操作失败,请重试", image: nil, time: 2, complateBlock: nil)
                                            }else if (result.status == 339){//图片上传失败
                                                GDAlertView.alert("操作失败,请重试", image: nil, time: 2, complateBlock: nil)
                                            }
                                        }, failure: { (error) in
                                            mylog(error)
                                        })
                                        //process something end
                                        
                                        
                                    }else{
                                        GDAlertView.alert("操作失败,请重试", image: nil, time: 2, complateBlock: nil)
                                    }
                                }
                                
                            })
                            
                        }
                    }, failure: { (error ) in
                        //未知错误
                        GDAlertView.alert("操作失败,请重试", image: nil, time: 2, complateBlock: nil)
                        mylog(error )
                    })
                   
                    
                    // MARK: 注释 : 插入七牛存储👆
                    /*
                    let dataBase64 = data?.base64EncodedString()
                    let size = dataBase64?.characters.count
                    GDNetworkManager.shareManager.uploadAvatar(name: self.mobileOrNameInput.text!, original: dataBase64!, size: "\(size!)", descrip: "", { (result) in
                        mylog(result.data)
                        mylog(result.status)
                        if (result.status == 200){
                            GDNetworkManager.shareManager.QZFirstInit({ (result ) in
                            }, failure: { (error ) in
                            })
                            let appDelegateOption = UIApplication.shared.delegate
                            if let appDelegate  = appDelegateOption {
                                if let realAppdelegate = appDelegate as? AppDelegate {
                                    if realAppdelegate.window?.rootViewController == GDKeyVC.share {
                                        self.navigationController?.popViewController(animated: true)
                                    }else{
                                        self.setKeyvcToMain()
                                    }
                                }
                            }
                        }else if (result.status == 316){//用户名不能为空
                            GDAlertView.alert("操作失败,请重试", image: nil, time: 2, complateBlock: nil)
                        }else if (result.status == 309){//头像不能为空
                            GDAlertView.alert("操作失败,请重试", image: nil, time: 2, complateBlock: nil)
                        }else if (result.status == 319){//头像的大小不能为空
                            
                            GDAlertView.alert("操作失败,请重试", image: nil, time: 2, complateBlock: nil)
                            
                        }else if (result.status == 320){//头像的格式不能为空
                            GDAlertView.alert("操作失败,请重试", image: nil, time: 2, complateBlock: nil)
                        }else if (result.status == 323){//用户所在国家不能为空
                            GDAlertView.alert("操作失败,请重试", image: nil, time: 2, complateBlock: nil)
                        }else if (result.status == 314){//用户的坐标不能为空
                            GDAlertView.alert("操作失败,请重试", image: nil, time: 2, complateBlock: nil)
                        }else if (result.status == 306){//更新失败
                            GDAlertView.alert("操作失败,请重试", image: nil, time: 2, complateBlock: nil)
                        }else if (result.status == 339){//图片上传失败
                            GDAlertView.alert("操作失败,请重试", image: nil, time: 2, complateBlock: nil)
                        }
                    }, failure: { (error) in
                        mylog(error)
                    })*/
                }
            
            }
        }

        picker.dismiss(animated: true) {      }
    }

    
    
    
    
    
    /**  则匹配用户密码6-16位数字和字母组合*/
    
    func passwordLawful(password:String) -> Bool {
        let passwordRegex = "^\\S{6,16}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
    
    
    
    /**邮箱的有效性*/
    func emailLawful(email:String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    /** 判断验证码的合法性 */
    
    func authcodeLawful(authCode : String ) -> Bool{
        let  number="^\\d{6}$"
        let numberPre =  NSPredicate(format: "SELF MATCHES %@", number)
        return numberPre.evaluate(with:authCode)
    }

    
    /** 判断用户名的合法性 */
    
    func usernameLawful(username:String) -> Bool  {
        let usernameRegex = "^[a-zA-Z][a-zA-Z0-9-_:~]{5,31}$"
        let usernamePredicate = NSPredicate(format: "SELF MATCHES %@", usernameRegex)
        return usernamePredicate.evaluate(with: username)
        
    }
    /** 判断手机号的合法性 */
    func mobileLawful(mobileStr:String) -> Bool {
        let mobile = "^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
        let cm = "^13[0-9]{9}$|14[0-9]{9}|15[0-9]{9}$|18[0-9]{9}|17[0-9]{9}$"
        let cu = "^1(3[0-2]|5[256]|8[56])\\d{8}$"
        let ct = "^1((33|53|8[019])[0-9]|349)\\d{7}$"
        let regexMobile = NSPredicate(format: "SELF MATCHES %@", mobile)
        let regexCM = NSPredicate(format: "SELF MATCHES %@", cm)
        let regexCU = NSPredicate(format: "SELF MATCHES %@", cu)
        let regexCT = NSPredicate(format: "SELF MATCHES %@", ct)
        
        if regexMobile.evaluate(with: mobileStr) || regexCM.evaluate(with: mobileStr) || regexCU.evaluate(with: mobileStr) || regexCT.evaluate(with: mobileStr) {
            return true
        }else{return false}
        
    }
    

    
}


enum ShowTimeType {
    case day
    case week
    case yearmonth
}
class GDLaunchVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        let imageView = UIImageView()
        imageView.image = UIImage(named: "launchImage")
        self.view.addSubview(imageView)
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.frame = self.view.bounds
        self.configTimeLabel()
        
    }
    func configTimeLabel()  {
        self.view.addSubview(self.createLabel(type: ShowTimeType.day))
        self.view.addSubview(self.createLabel(type: ShowTimeType.yearmonth))
        self.view.addSubview(self.createLabel(type: ShowTimeType.week))
        
    }
    func createLabel(type:ShowTimeType) -> UILabel {
        let label = UILabel()
        label.textColor = UIColor.white
        let calander = Calendar.current
        let result = calander.dateComponents(in: TimeZone.current, from: Date())
//        mylog(result.day)
//        mylog(result.weekday)
//        mylog(result.month)
//        mylog(result.year)
        let dayH : CGFloat = 88.0
        let offset : CGFloat = 5.0 //年月和周 相对于水平中线的上下偏移量
        switch type {
        case .day:
            
            label.font = UIFont.boldSystemFont(ofSize: 70)
            label.textAlignment = NSTextAlignment.center
            if let day = result.day {
                label.text = day.description
                label.frame = CGRect(x: SCREENWIDTH / 2 - dayH, y: SCREENHEIGHT / 2 - dayH / 2, width: dayH *
                    1.1, height: dayH)
            }
        case .week:
            if let weekday = result.weekday {
                switch weekday {
                case 1:
                    label.text = "周日"
                case 2:
                    label.text = "周一"
                case 3:
                    label.text = "周二"
                case 4:
                    label.text = "周三"
                case 5:
                    label.text = "周四"
                case 6:
                    label.text = "周五"
                case 7:
                    label.text = "周六"
                default:
                    label.isHidden = true
                }
                label.frame = CGRect(x: SCREENWIDTH / 2, y: SCREENHEIGHT / 2 - offset, width: SCREENWIDTH / 2, height: dayH / 2)
                label.font = UIFont.systemFont(ofSize: 20)
            }
        case .yearmonth:
            var tempTxt  =  ""
            if let month = result.month {
                tempTxt = month.description + "月"
            }
            if let year = result.year {
                label.text = tempTxt + year.description
            }
            label.frame = CGRect(x: SCREENWIDTH / 2, y: SCREENHEIGHT / 2 - dayH / 2  + offset, width: SCREENWIDTH / 2, height: dayH / 2 )
            label.font = UIFont.systemFont(ofSize: 20)
        }
        
        
        return label
        
    }
}
