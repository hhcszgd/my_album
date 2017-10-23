//
//  GDNetworkManager.swift
//  zjlao
//
//  Created by WY on 16/12/12.
//  Copyright © 2016年 com.16lao.zjlao. All rights reserved.
//



import UIKit
import Qiniu

import Photos
import AFNetworking
enum RequestType: String {
    case POST = "POST"
    case GET = "GET"
    case PUT = "PUT"
}
//private let hostName = "http://api.123qz.cn/"//新
//private let hostName = "http://api2.123qz.cn/v2/"//二版接口
private let hostName = "http://albumapi.123qz.cn/v1/"//相册接口
//private let hostName =    "http://123qz.ugshop.cn/"//旧
private let dataErrorDomain = "com.someThingError"
class GDNetworkManager: AFHTTPSessionManager {

    // MARK: 注释 : 上传媒体成功的通知
   static let GDUpLoadMediaSuccess = Notification.Name.init("UpLoadMediaSuccess")
    //MARK:当前网络状态
    var gdNetWorkStatus : AFNetworkReachabilityStatus  {
        return AFNetworkReachabilityManager.shared().networkReachabilityStatus
        
    }
    var alert : GDAlertView = GDAlertView.networkLoading()
    var token : String? {
        get{
            if let result  = GDStorgeManager.standard.value(forKey: "token") {
                if  let token_temp =  result as? String   {
                    if token_temp.characters.count>0 {
                        if token_temp == "nil" {
                            return nil
                        }else{
                            return token_temp
                        }
                    }
                }
            }
            return nil
        }
        set{
            if newValue == nil  {
                GDStorgeManager.standard.setValue("nil", forKey: "token")
            }else{
                GDStorgeManager.standard.setValue(newValue!, forKey: "token")
            }
        }
    }
    
//    override class func initialize(){
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(noticeNetworkChanged(_:)), name: NSNotification.Name.AFNetworkingReachabilityDidChange, object: nil)
//        
//    }
    

    static let shareManager : GDNetworkManager = {
        let url = URL(string: hostName)!
        let mgr = GDNetworkManager(baseURL: url)
//        mgr.session.configuration.timeoutIntervalForRequest = 6 //timeoutIntervalForRequest时间内, 如果没有请求数据发送,则请求超时
        mgr.session.configuration.timeoutIntervalForResource = 6//timeoutIntervalForResource时间内,如果没有返回响应,则响应超时
        //添加支持的反序列化格式
        mgr.responseSerializer.acceptableContentTypes?.insert("text/plain")
//        mgr.requestSerializer.setValue("2", forHTTPHeaderField: "APPID")
//        mgr.requestSerializer.setValue("1", forHTTPHeaderField: "VERSIONID")
//        mgr.requestSerializer.setValue("20160501", forHTTPHeaderField: "VERSIONMINI")
//        mgr.requestSerializer.setValue((UIDevice.current.identifierForVendor?.uuidString)!, forHTTPHeaderField: "DID")
        mgr.responseSerializer.acceptableContentTypes = Set<String>(arrayLiteral: "application/json", "text/json", "text/javascript","text/html")
        //        mgr.requestSerializer.setValue("383B255B-87F7-466C-914A-0B1A35AA5DC3", forHTTPHeaderField: "DID")//先把UID写死
        
        
        
        return mgr
//        NotificationCenter.default.addObserver(self, selector: #selector(locationChanged(info:)), name: GDLocationManager.GDLocationChanged, object: nil)
    }()
    static var isFirst = false//第一次监听不提示
    
    @objc class func noticeNetworkChanged(_ note : Notification) -> () {
        if !isFirst  {
            isFirst = true
            return
        }
        guard (note as NSNotification).userInfo != nil else {return}
//        let currentNetworkStatus = userInfo[AFNetworkingReachabilityNotificationStatusItem] as! Int
        /**
         AFNetworkReachabilityStatusUnknown          = -1,
         AFNetworkReachabilityStatusNotReachable     = 0,
         AFNetworkReachabilityStatusReachableViaWWAN = 1,
         AFNetworkReachabilityStatusReachableViaWiFi = 2,*/
        /*不提示了
        if currentNetworkStatus == -1 {//AFNetworkReachabilityStatus.Unknown
            GDAlertView.alert("网络连接失败\n请检查网络", image: nil, time: 2, complateBlock: nil)
        }else if (currentNetworkStatus == 0){//AFNetworkReachabilityStatus.notReachable
            GDAlertView.alert("网络错误", image: nil, time: 2, complateBlock: nil)
        }else if (currentNetworkStatus == 1){//AFNetworkReachabilityStatus.reachableViaWWAN
            GDAlertView.alert("当前网络环境为移动蜂窝网络", image: nil, time: 2, complateBlock: nil)
        }else if (currentNetworkStatus == 2){//AFNetworkReachabilityStatus.reachableViaWiFi
            GDAlertView.alert("当前网络环境为wifi", image: nil, time: 2, complateBlock: nil)
        }
        */
    }
    func locationChanged(info:[String : AnyObject])  {

        
    }
    func printMessage(_ urlString : String , paramete : AnyObject?) -> () {
        #if DEBUG
            
            
            if let obj :AnyObject = paramete {
                
                print("📩原始数据[\(urlString)] <-->  \n\(obj)")
            }
            
            
            if let error : NSError = paramete as? NSError {
                print("📩原始数据[\(urlString)] <-->  \n\(error)")
                
            }
        #endif
    }
    
    
    // MARK: 注释 : 茄子begain
    // MARK: 注释 : 还是服务器来获取吧 , 太费劲了
//    func getuploadToken(image:UIImage) -> String {
//        let accessKey = "2q79UsVcc6c-y5rRn-3qpPg9G1QVAF1d5lrRJWwE"
//        let secretKey = "GQylQ1SUjr6OlTd7Lg7qjbIK_WnYJnI0wgE_l0Kl"
//        let buket = "hhcszgd"
//        let currentTimeStamp = Date().timeIntervalSince1970
//        let deadLine = currentTimeStamp + 600
//        let imgW = image.size.width
//        let imgH = image.size.height
//        let hash = image.hash
//        let size = UIImageJPEGRepresentation(image, 1)!.count
//        
//        let c = secretKey.hmacSHA1String(withKey:"")
//        
//        
//        return ""
//    }
    
    
    // MARK: 注释 : 修改用户信息
    func changeUserinfo( name : String? = nil /*, deviceid : String? = nil*/,  mobile: String? = nil , coordinate : String? = nil , avatar : String?  = nil , registration_id : String? = nil , _ success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ())  {
        let url = "users"
        var para = [
            "token" : self.token ?? "看看",
            ] as [String : Any]
        
        if let nameStr  = name {
            para["name"] = nameStr
        }
        
        if let deviceidStr  =  UIDevice.current.identifierForVendor?.uuidString {
            para["deviceid"] = deviceidStr
        }
        if let coordinateStr  = coordinate {
            para["coordinate"] = coordinateStr
        }
        if let avatarStr  = avatar {
            para["avatar"] = avatarStr
            para["format"] = "jpeg"
        }
        if let mobileStr  = mobile {
            para["mobile"] = mobileStr
        }
        if let registrationID  = registration_id {
            para["registration_id"] = registrationID
        }
        self.QZRequestJSONDict(RequestType.POST, urlString: url , parameters: para as [String : AnyObject] , success: { (result) in
            success(result)
            self.QZFirstInit({ (result ) in}, failure: { (error) in})
        }) { (error) in
            
            failure(error)
        }
        
        
    }
    
    
    
    // MARK: 注释 : 获取用户信息
    func getUserinfo( userid : String , _ success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ())  {
        mylog("打印用户id\(userid)")
        let url = "users/" + userid
        let para = [
            "token" : self.token ?? "看看",
            ] as [String : Any]
        
        self.QZRequestJSONDict(RequestType.GET, urlString: url , parameters: para as [String : AnyObject] , success: { (result) in
            success(result)
        }) { (error) in
            
            failure(error)
        }
        
        
    }
    
    
    
    // MARK: 注释 : 获取朋友们
    func getFriends( page : Int , _ success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ())  {
        let url = "friend"
        
        let para = [
            "page" : page,//媒体base64
            "token" : self.token ?? "看看",
            ] as [String : Any]
        
        self.QZRequestJSONDict(RequestType.GET, urlString: url , parameters: para as [String : AnyObject] , success: { (result) in
            success(result)
        }) { (error) in
            
            failure(error)
        }
        
        
    }
    
    
    
    
    // MARK: 注释 : 查看评论点赞动态
    func getReceivedTrends( page : Int , _ success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ())  {
//        let url = "comment"
         let url = "users_message"
        let para = [
            "page" : page,//媒体base64
            "token" : self.token ?? "看看",
            ] as [String : Any]
        
        self.QZRequestJSONDict(RequestType.GET, urlString: url , parameters: para as [String : AnyObject] , success: { (result) in
            success(result)
        }) { (error) in
            
            failure(error)
        }
        
        
    }
    
    
    
    
    // MARK: 注释 : 点击大图后 , 进入圈子详情纵向列表页
    func getCircleMediasList(circleID : String , offset : Int , _ success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ())  {
        let url = "media/\(circleID)"
        
        var para = [
            "circle_id" : circleID,//媒体base64
            "token" : self.token ?? "看看",
            ] as [String : Any]
        if GDKeyVC.share.initializationAccountInfo() {  return  }
        if offset != 0 {
            para["offset"] = offset
        }
        
        self.QZRequestJSONDict(RequestType.GET, urlString: url , parameters: para as [String : AnyObject] , success: { (result) in
            success(result)
        }) { (error) in
            
            failure(error)
        }
        
        
    }
    
    //: mark  举报
    func report(mediaID : String , _ success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ())  {
        let url = "media_informed/\(mediaID)"
        
        let para = [
            "token" : self.token ?? "看看",
            ] as [String : Any]
//        if GDKeyVC.share.initializationAccountInfo() {  return  }
        
        self.QZRequestJSONDict(RequestType.POST, urlString: url , parameters: para as [String : AnyObject] , success: { (result) in
            success(result)
        }) { (error) in
            
            failure(error)
        }
        
        
    }
    //: mark  拉黑
    
    func block(userID : String , _ success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ())  {
        let url = "friend/\(userID)"
        
        let para = [
            "token" : self.token ?? "",
            ] as [String : Any]
        //        if GDKeyVC.share.initializationAccountInfo() {  return  }
        
        self.QZRequestJSONDict(RequestType.POST, urlString: url , parameters: para as [String : AnyObject] , success: { (result) in
            success(result)
        }) { (error) in
            
            failure(error)
        }
        
        
    }

 
    // MARK: 注释 : 查看全部评论
    
    //第一版媒体详情
    func seeMoreComments(circleID : String?/*圈子详情点进去时要传*/ ,messageID : String?/*回复别人是传*/,mediaID : String , offset : Int?/*左右分页时传,暂定-1*/ ,create_at : String?/*回去时传*/ , _ success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ())  {
        let url =  "media_comment/" + mediaID
        var para : [String : Any] = [
            "token" : self.token ?? "",
            "message_id" : messageID ?? "nil"
            ]
        if let circleIDStr = circleID {
            para["circle_id"] = circleIDStr
        }else{
        }
        if let offSetInt = offset {
            para["offset"] = offSetInt
        }else{
            para["offset"] = -1
        }
        if let messageIDStr = messageID {
            para["message_id"] = messageIDStr
        }
        if let creatTime = create_at {
            para["create_at"] = creatTime
        }
        self.QZRequestJSONDict(RequestType.GET, urlString: url , parameters: para as [String : AnyObject] , success: { (result) in
            success(result)
        }) { (error) in
            
            failure(error)
        }
        
        
    }


    // MARK: 注释 : 删除媒体
    
    func deleteMedia(mediaID : String ,  _ success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ())  {
        let url =  "media/" + mediaID
        let para = [
            "token" : self.token,
            ]
        self.QZRequestJSONDict(RequestType.POST, urlString: url , parameters: para as [String : AnyObject] , success: { (result) in
            success(result)
        }) { (error) in
            
            failure(error)
        }
        
        
    }
    
    
    
    
    
    // MARK: 注释 : 评论点赞
    
    func commentAndLike(mediaID : String , isLike : String ,content : String?, _ success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ())  {
        let url =  "comment"
        var para = [
            "media_id" : mediaID,
            "is_good" : isLike ,
            "token" : self.token,
            ]
        if let contentStr = content {
            para["content"] = contentStr
        }
        self.QZRequestJSONDict(RequestType.POST, urlString: url , parameters: para as [String : AnyObject] , success: { (result) in
            success(result)
        }) { (error) in
            
            failure(error)
        }
        
        
    }
    

    
    
    
    
    
    
    // MARK: 注释 : 圈子动态
    
    func getCircleTrends(page : String , _ success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ())  {
        let url =  "circles"
        let para = [
            "page" : page,//
            "token" : self.token,
            ]
        
        self.QZRequestJSONDict(RequestType.GET, urlString: url , parameters: para as [String : AnyObject] , success: { (result) in
            success(result)
        }) { (error) in
            
            failure(error)
        }
        
        
    }
    
    
    
    
    // MARK: 注释 : 好友历史记录
    
    func getOthersHistory(userID : String , page : String , createAt : String? , _ success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ())  {
        let url =  "friend/" + userID
        var para = [
            "page" : page,//
            "token" : self.token,
            ]
        if let creat_at = createAt {
            para["create_at"] = creat_at
        }
        self.QZRequestJSONDict(RequestType.GET, urlString: url , parameters: para as [String : AnyObject] , success: { (result) in
            success(result)
        }) { (error) in
            mylog("上传头像的请求失败")
            failure(error)
        }
        
        
    }

    
    
    // MARK: 注释 : 个人历史记录
    
    func getPersonalHistory(page : String , createAt : String? , _ success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ())  {
        let url =  "users"
        var para = [
            "page" : page,//
            "token" : self.token,
            ]
        if let creat_at = createAt {
            para["create_at"] = creat_at
        }
        self.QZRequestJSONDict(RequestType.GET, urlString: url , parameters: para as [String : AnyObject] , success: { (result) in
            success(result)
        }) { (error) in
            mylog("上传头像的请求失败")
            failure(error)
        }
        
        
    }
    
// MARK: 注释 : 上传头像和设置姓名(v1 , v2 ) 把七牛上传真是图片后的图片标识传给服务器
    func uploadAvatar(name : String ,original : String,size : String , descrip : String?, _ success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ()) {
        //        GDLocationManager.share.gotCurrentLocation { (location , error) in
        let location = GDLocationManager.share.locationManager.location
//        let longtitude = String.init(format: "%.08f", arguments: [(location?.coordinate.longitude)!])
//        let latitude = String.init(format: "%.08f", arguments: [(location?.coordinate.latitude)!])
        //            mylog("定位成功")
//        mylog(location?.coordinate.longitude)
//        mylog(location?.coordinate.latitude)
//        mylog(longtitude)
//        mylog(latitude)
        if location != nil {
            var para = [
//                "coordinate" : "\(longtitude),\(latitude)" ,
//                "coordinate" : "\(latitude),\(longtitude)" ,
//                "size" : size,
//                "location" : "china",
//                "format" : "jpeg",
                "name" : name,
                "avatar" : original,//媒体base64
                "token" : self.token,
                ]
            
            if descrip != nil  {
                para["description"] = descrip!
            }
            //                let para = ["coordinate" : "\(116.293954),\(39.83799)" ]
            let url =  "users"
            
//            if let memberid  = Account.shareAccount.member_id {//v2 不要userid了
//                url = url + "/\(memberid)"
//                
//            }
            self.QZRequestJSONDict(RequestType.POST, urlString: url , parameters: para as [String : AnyObject] , success: { (result) in
                success(result)
            }) { (error) in
                mylog("上传头像的请求失败")
                failure(error)
            }
        }else{
            let gdError = NSError(domain: "wrongDomain.com", code: -10001, userInfo: ["reason" : "LocationFaiure"])
            failure(gdError)
        }
        //        }
        
        
        
    }
    
    
    // MARK: 注释 : 上传媒体(图片或者视频)
    func uploadMedia(circleID : String ,original : String,size : String ,descrip : String?,formate : String = "jpeg",  _ success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ()) {
//        GDLocationManager.share.gotCurrentLocation { (location , error) in
        let location = GDLocationManager.share.locationManager.location
            let longtitude = String.init(format: "%.08f", arguments: [(location?.coordinate.longitude) ?? 0])
            let latitude = String.init(format: "%.08f", arguments: [(location?.coordinate.latitude) ?? 0])
//            mylog("定位成功")
//            mylog(location?.coordinate.longitude)
//            mylog(location?.coordinate.latitude)
//            mylog(longtitude)
//            mylog(latitude)
            if location != nil {
                var para = [
                    "coordinate" : "\(latitude),\(longtitude)" ,
                    "size" : size,
                    "location" : "china",
                    "format" : formate,
                    "circle_id" : circleID,
                    "original" : original,//媒体base64
//                    "add_circle" : "1",
                    "token" : self.token,
                ]
                if descrip != nil  {
                    para["description"] = descrip!
                }
                
//                let para = ["coordinate" : "\(116.293954),\(39.83799)" ]
                let url = "media"
                self.QZRequestJSONDict(RequestType.POST, urlString: url , parameters: para as [String : AnyObject] , success: { (result) in
                    
                    success(result)
                    if (result.status == 200){
                        NotificationCenter.default.post(name: GDNetworkManager.GDUpLoadMediaSuccess, object: nil , userInfo: nil)
                    }
                }) { (error) in
                    mylog("上传媒体的请求失败")
                    failure(error)
                }
            }else{
                let gdError = NSError(domain: "wrongDomain.com", code: -10001, userInfo: ["reason" : "LocationFaiure"])
                failure(gdError)
            }
//        }
        

        
    }
    // MARK: 注释 : 获取圈子详情
    func getCircleDetail(circleID : String , page : String , _ success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ()) {
//        mylog(circleID)
        let para = ["page": page]
        let url = "circle/\(circleID)"
        self.QZRequestJSONDict(RequestType.GET, urlString: url , parameters: para as [String : AnyObject] , success: { (result) in
            success(result)
        }) { (error) in
            mylog("获取圈子详情的请求失败")
            failure(error)
        }

        
        
    }
    
    // MARK: 注释 : 获取附近圈子
    
    func getNearbycircal( _ success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ())  {
//        GDLocationManager.share.gotCurrentLocation { (location , error) in
        let location = GDLocationManager.share.locationManager.location
            let longtitude = String.init(format: "%.08f", arguments: [location?.coordinate.longitude ?? "0"])
            let latitude = String.init(format: "%.08f", arguments: [location?.coordinate.latitude ?? "0"])
            if location != nil {
//                mylog("获取位置成功")
//                mylog(location?.coordinate.longitude)
//                mylog(location?.coordinate.latitude)
                mylog(longtitude)
                mylog(latitude)

//                let para = ["coordinate" : "\(116.293954),\(39.83799)" ]
                var para = ["coordinate" : "\(longtitude),\(latitude)" ]
                if self.token != nil  {
                    para["token"] = self.token!
                }
                let url = "circle"
                self.QZRequestJSONDict(RequestType.GET, urlString: url , parameters: para as [String : AnyObject] , success: { (result) in
                    success(result)
                }) { (error) in
                    mylog("获取圈子的请求失败")
                    failure(error)
                }
            }else{
                let gdError = NSError(domain: "wrongDomain.com", code: -10001, userInfo: ["reason" : "LocationFaiure"])
                failure(gdError)
            }
//        }

        
    }

    
    //MARK: 验证验证码和手机号
    func QZAuthentication(mobile : String , authCode : String,  _ success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ()) -> () {
        let url = "message"
        let did = UIDevice.current.identifierForVendor?.uuidString
//        coordinate
//        GDLocationManager.share.gotCurrentLocation { (location , error) in
//        let location = GDLocationManager.share.locationManager.location
//            let longtitude = String.init(format: "%.08f", arguments: [(location?.coordinate.longitude)!])
//            let latitude = String.init(format: "%.08f", arguments: [(location?.coordinate.latitude)!])
////             mylog("定位成功")
//            mylog(location?.coordinate.longitude)
//            mylog(location?.coordinate.latitude)
//            mylog(longtitude)
//            mylog(latitude)
//            if location != nil {
                let para = ["mobile" : mobile , "verify" :  authCode ,"deviceid" : did ]
                self.QZRequestJSONDict(RequestType.POST, urlString: url , parameters: para as [String : AnyObject] , success: { (result) in
                    mylog(result.data)
                    if result.status == 200 {
                        if let info = result.data as? Dictionary<String, Any> {
                            
                            if let infoAny = info["id"] {
                                Account.shareAccount.member_id = "\(infoAny)"
                            }
                            
                            
                            let token = info["token"] as? String
                            if let tokenStr = token{
//                                    GDStorgeManager.standard.setValue(tokenStr, forKey: "token")
                                self.token = tokenStr
                                    self.QZFirstInit({ (model) in //认证成功以后 通过初始化接口重置用户状态
                                    }, failure: { (error ) in
                                        mylog("初始化失败")
                                    })
                            }else{
                                mylog("取token值失败")
                            }
                            
                        }else{
                            mylog("取data值失败")
                        }
                        
                    }else if (result.status == 303){//验证码验证不通过
                    
                    }else if (result.status == 306){//用户创建失败
                        
                    }else if (result.status == 314){//坐标不能为空
                        
                    }else if (result.status == 311){//手机号已被占用
                        
                    }
                    success(result)
                }) { (error) in
                    failure(error)
                }
//            }else{
//                let gdError = NSError(domain: "wrongDomain.com", code: -10001, userInfo: ["reason" : "LocationFaiure"])
//                failure(gdError)
//                mylog("定位失败")
//            }
//        }

        
        
    }

    
    
    
    
    //MARK: 获取短信验证码
    func QZGetAuthcode(mobile : String ,  _ success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ()) -> () {
        let url = "message"
        let para = ["mobile" : mobile ]
        QZRequestJSONDict(RequestType.GET, urlString: url , parameters: para as [String : AnyObject] , success: { (result) in
            if result.status == 200 {//获取成功
                if (result.data  as? String) != nil{

                }
            }else if (result.status == 308){//验证码获取失败

                
            }else if (result.status == 301){//手机号码格式不正确

            }else if (result.status == 311){//手机号已被占用
                //doNothing
            }else if (result.status == 300){//手机号码不能为空
                //doNothing
            }else if (result.status == 303){
                //doNothing
            }
            success(result)
        }) { (error) in
            failure(error)
        }

    }
    
    
    //MARK: 初始化token
    func QZFirstInit(_ success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ()) -> () {
        let url = "init"
        let did = UIDevice.current.identifierForVendor?.uuidString
        let para = ["deviceid" : did , "app_type" : "2" ]
        QZRequestJSONDict(RequestType.POST, urlString: url , parameters: para as [String : AnyObject] , success: { (result) in
            mylog("初始化状态码\(result.status)")
            if result.status == 202 {
                Account.shareAccount.resetAccountStatus(status: AccountStatus.authenticated)
                if let info = result.data as? [String : AnyObject] {
//                    Account.shareAccount.name = info["name"] as! String?
                    if let name = info["name"] as? String{
                        Account.shareAccount.name = name
                    }
                    if let id = info["id"] as? String{
                        Account.shareAccount.member_id = id
                        
                    }
                    if let idNum = info["id"] as? NSNumber {
                        Account.shareAccount.member_id = "\(idNum)"
                    }
                    if let avatar = info["avatar"] as? String{
                     Account.shareAccount.head_images = avatar
                    }
//                    Account.shareAccount.member_id =  "\(info["id"])"
//                    Account.shareAccount.head_images = info["avatar"] as! String?
                    if let token = info["token"] {
                        if let tokenStr = token as? String {
//                            GDStorgeManager.standard.setValue(tokenStr, forKey: "token")
                            self.token = tokenStr
                        }
                    
                    }
                }
            }else if (result.status == 310){
                Account.shareAccount.resetAccountStatus(status: AccountStatus.unAuthenticated)
            }else if (result.status == 203){
                Account.shareAccount.resetAccountStatus(status: AccountStatus.halfAuthenticated)
                if let info = result.data as? Dictionary<String, Any> {
                    if let idStr = info["id"] as? String  {
                        Account.shareAccount.member_id = idStr
                    }
                    if let idNum = info["id"] as? NSNumber {
                        Account.shareAccount.member_id = "\(idNum)"
                    }
                    
                    if let token = info["token"] {
                        if let tokenStr = token as? String {
//                            GDStorgeManager.standard.setValue(tokenStr, forKey: "token")
                            self.token = tokenStr
                        }
                        
                    }
                    
                }
            }else if (result.status == 307){
                Account.shareAccount.resetAccountStatus(status: AccountStatus.unAuthenticated)
            }else{
                //doNothing
            }
            success(result)
        }) { (error) in
            failure(error)
        }

    
    }
    
    
    
    
    
    //次终极自定义请求 // 闭包参数result 保证只要回调 就一定有值
    func QZRequestDataFromNewWork(_ method: RequestType, urlString: String,parameters:[String : AnyObject],success: @escaping (_ result:OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) ->()) {
        
        if token != nil  && token! != "nil" {
            var para  = parameters
            
            para["token"] = token! as AnyObject?
            mylog(para)
            self.requestJSONDict(method, urlString: urlString, parameters: para, success: { (result) in
                success(result)
            }, failure: { (error) in
                failure(error)
            })
        }else{
            initToken({ (result) in
                mylog(self.token)
                var para  = parameters
                
                if let tempToken = self.token {
                    
                    
                    para["token"] =  tempToken as AnyObject?
                    self.requestJSONDict(method, urlString: urlString, parameters: para, success: { (result) in
                        success(result)
                    }, failure: { (error) in
                        failure(error)
                    })
                    
                }else{
                    GDAlertView.alert("初始化失败 , 请重试", image: nil, time: 2, complateBlock: nil)
                    let gdError = NSError(domain: "wrongDomain.com", code: -10001, userInfo: ["reason" : "netWorkError"])
                    failure(gdError)
                }
                
            }, failure: { (error) in
                //初始化失败,
                let gdError = NSError(domain: "wrongDomain.com", code: -10001, userInfo: ["reason" : "netWorkError"])
                failure(gdError)
            })
            
        }
        
        
    }
    
    //(终极自定义)基于核心网络框架的核心方法 进行封装  以后所有的网络请求 都走这个方法(初始化方法除外)
    private  func QZRequestJSONDict(_ method: RequestType, urlString: String,parameters:[String : AnyObject],success: @escaping (_ result:OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) ->()) {
        
        
        //MARK:在失败回调里 ,如果错误码是-11111  , 代表网络错误  , 测试在自定义控制器里就可以执行showErrorView
        
//        if gdNetWorkStatus == AFNetworkReachabilityStatus.notReachable || gdNetWorkStatus == AFNetworkReachabilityStatus.unknown {
//            GDAlertView.alert("请求失败 , 请检查网络", image: nil, time: 2, complateBlock: nil)
//            let gdError = NSError(domain: "wrongDomain.com", code: -11111, userInfo: ["reason" : "netWorkError"])
//            failure(gdError)
//            
//            return
//        }
        if urlString != "LoginOut" { self.alert.gdShow()}//退出是立即生效的, 不转圈
//        mylog( UIDevice.current.identifierForVendor?.uuidString)
//        mylog("\(urlString)\(parameters)")
        var  para : [String : AnyObject]? = [String : AnyObject]()
        for key in parameters.keys {
            //                let keyStr = key as String
            //                para["keyStr"] = parameters[keyStr]
            para?[key] = parameters[key]
        }
        
        if (para?.isEmpty)! {
            para = nil
        }
        mylog("-*请求链接*->\(urlString)--*请求类型*-->\(method)--*请求参数*-->\(String(describing: para))<--*****--")
//        mylog("ddddddddasdfasdf\(para)")
        var url   =  hostName
        url = url + urlString
        
        if method == RequestType.GET {
            //实现GET请求
            
            get(url, parameters: para, progress: nil , success: { (_, result) in
                //                mylog(result)
                self.alert.gdHide()///////////////////////////
//                self.printMessage(urlString, paramete: result as AnyObject?)
                if let dict = result as? [String : AnyObject] {
                    //执行成功回调
                    let model = OriginalNetDataModel.init(dict: dict)
                    success(model)
                    
                    return
                }
                //如果程序走到这里  成功回调的结果 无法转换为字典形式的数据
                let error = NSError(domain: dataErrorDomain, code: -10000, userInfo: [NSLocalizedDescriptionKey : "(手动判断)数据格式错误"])
                self.printMessage(urlString, paramete: error)
                failure(error)
            }, failure: { (_, error) in
                self.alert.gdHide()////////////////////////////////
                //执行失败的回调
                self.printMessage(urlString, paramete: error as AnyObject?)
                failure( error as NSError)
                
            })
            
        } else if method == RequestType.POST{
            //实现POST请求
            
            post(url, parameters: para, progress: nil, success: { (task, result) in
//                mylog("请求参数:\(para) , 请求结果:\(result)")
                self.printTaskInfo(task: task)
                self.alert.gdHide()///////////////////////////
//                self.printMessage(urlString, paramete: result as AnyObject?)
//                mylog("测试打印数据 : \(result)")
                if let dict = result as? [String : AnyObject] {
                    //执行成功回调
//                    let model = OriginalNetDataModel.init(dict: dict)
                    let model = OriginalNetDataModel.init(dictionary: dict)
                    success(model)
                    return
                }
                //如果程序走到这里  成功回调的结果 无法转换为字典形式的数据
                let error = NSError(domain: dataErrorDomain, code: -10000, userInfo: [NSLocalizedDescriptionKey : "(手动判断)数据格式错误"])
                self.printMessage(urlString, paramete: error)
                failure(error)
            }, failure: { (task, error) in
                self.printTaskInfo(task: task)
                self.alert.gdHide()///////////////////
                //执行失败的回调
                self.printMessage(urlString, paramete: error as AnyObject?)
                failure( error as NSError)
                
            })
            
        }else if method == RequestType.PUT {
            put(url, parameters: para, success: { (_, result) in
                self.alert.gdHide()//////////////////////
//                self.printMessage(urlString, paramete: result as AnyObject?)
                if let dict = result as? [String : AnyObject] {
                    //执行成功回调
                    let model = OriginalNetDataModel.init(dict: dict)
                    success(model)
                    return
                }
                //如果程序走到这里  成功回调的结果 无法转换为字典形式的数据
                let error = NSError(domain: dataErrorDomain, code: -10000, userInfo: [NSLocalizedDescriptionKey : "(手动判断)数据格式错误"])
                self.printMessage(urlString, paramete: error)
                failure(error)
            }, failure: { (_, error) in
                self.alert.gdHide()//////////////////////////////
                //执行失败的回调
                self.printMessage(urlString, paramete: error as AnyObject?)
                failure( error as NSError)
                
            })
        }
    }
    

    
    
    
    
    
    
    // MARK: 注释 : 打印task数据
    func printTaskInfo(task : URLSessionDataTask?)  {
        if task == nil  {return}
        //                URLSessionDataTask /
        //                URLResponse
        //                HTTPURLResponse
        if let response  = task?.response as? HTTPURLResponse {
            mylog("网络任务:\(String(describing: response.suggestedFilename)) 请求状态:\(HTTPURLResponse.localizedString(forStatusCode: response.statusCode))")
        }
        
    }
    
    
    
    // MARK: 注释 : 茄子end
    
    
    
    //次终极自定义请求 // 闭包参数result 保证只要回调 就一定有值
    func requestDataFromNewWork(_ method: RequestType, urlString: String,parameters:[String : AnyObject],success: @escaping (_ result:OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) ->()) {
        
        if token != nil  && token! != "nil" {
            var para  = parameters
            
            para["token"] = token! as AnyObject?
            mylog(para)
            self.requestJSONDict(method, urlString: urlString, parameters: para, success: { (result) in
                success(result)
            }, failure: { (error) in
                failure(error)
            })
        }else{
            initToken({ (result) in
                mylog(self.token)
                var para  = parameters
                
                if let tempToken = self.token {
                    
                    
                    para["token"] =  tempToken as AnyObject?
                    self.requestJSONDict(method, urlString: urlString, parameters: para, success: { (result) in
                        success(result)
                    }, failure: { (error) in
                        failure(error)
                    })
                    
                }else{
                    GDAlertView.alert("初始化失败 , 请重试", image: nil, time: 2, complateBlock: nil)
                    let gdError = NSError(domain: "wrongDomain.com", code: -10001, userInfo: ["reason" : "netWorkError"])
                    failure(gdError)
                }
                
            }, failure: { (error) in
                //初始化失败,
                let gdError = NSError(domain: "wrongDomain.com", code: -10001, userInfo: ["reason" : "netWorkError"])
                failure(gdError)
            })
            
        }
        
        
    }
    
    //(终极自定义)基于核心网络框架的核心方法 进行封装  以后所有的网络请求 都走这个方法(初始化方法除外)
    private  func requestJSONDict(_ method: RequestType, urlString: String,parameters:[String : AnyObject],success: @escaping (_ result:OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) ->()) {
        //MARK:在失败回调里 ,如果错误码是-11111  , 代表网络错误  , 测试在自定义控制器里就可以执行showErrorView
        
        if gdNetWorkStatus == AFNetworkReachabilityStatus.notReachable || gdNetWorkStatus == AFNetworkReachabilityStatus.unknown {
            GDAlertView.alert("请求失败 , 请检查网络", image: nil, time: 2, complateBlock: nil)
            let gdError = NSError(domain: "wrongDomain.com", code: -11111, userInfo: ["reason" : "netWorkError"])
            failure(gdError)
            
            return
        }
        if urlString != "LoginOut" { self.alert.gdShow()}//退出是立即生效的, 不转圈
        mylog( UIDevice.current.identifierForVendor?.uuidString)
        mylog("\(urlString)\(parameters)")
        var  para : [String : AnyObject] = [String : AnyObject]()
        for key in parameters.keys {
            //                let keyStr = key as String
            //                para["keyStr"] = parameters[keyStr]
            para[key] = parameters[key]
        }
        mylog("ddddddddasdfasdf\(para)")
        var url   =  "V2/"
        url = url + urlString
        url = url + "/rest"
        
        if method == RequestType.GET {
            //实现GET请求
                        
            get(url, parameters: para, progress: nil , success: { (_, result) in
                //                mylog(result)
                self.alert.gdHide()///////////////////////////
//                self.printMessage(urlString, paramete: result as AnyObject?)
                if let dict = result as? [String : AnyObject] {
                    //执行成功回调
                    let model = OriginalNetDataModel.init(dict: dict)
                    success(model)
                    
                    return
                }
                //如果程序走到这里  成功回调的结果 无法转换为字典形式的数据
                let error = NSError(domain: dataErrorDomain, code: -10000, userInfo: [NSLocalizedDescriptionKey : "(手动判断)数据格式错误"])
                self.printMessage(urlString, paramete: error)
                failure(error)
            }, failure: { (_, error) in
                self.alert.gdHide()////////////////////////////////
                //执行失败的回调
                self.printMessage(urlString, paramete: error as AnyObject?)
                failure( error as NSError)
                
            })
            
        } else if method == RequestType.POST{
            //实现POST请求
            mylog("zzzzzzzzz\(para)")
            post(url, parameters: para, progress: nil, success: { (_, result) in
                self.alert.gdHide()///////////////////////////
//                self.printMessage(urlString, paramete: result as AnyObject?)
                if let dict = result as? [String : AnyObject] {
                    //执行成功回调
                    let model = OriginalNetDataModel.init(dict: dict)
                    success(model)
                    return
                }
                //如果程序走到这里  成功回调的结果 无法转换为字典形式的数据
                let error = NSError(domain: dataErrorDomain, code: -10000, userInfo: [NSLocalizedDescriptionKey : "(手动判断)数据格式错误"])
                self.printMessage(urlString, paramete: error)
                failure(error)
            }, failure: { (_, error) in
                self.alert.gdHide()///////////////////
                //执行失败的回调
                self.printMessage(urlString, paramete: error as AnyObject?)
                failure( error as NSError)
                
            })
            
        }else if method == RequestType.PUT {
            put(url, parameters: para, success: { (_, result) in
                self.alert.gdHide()//////////////////////
//                self.printMessage(urlString, paramete: result as AnyObject?)
                if let dict = result as? [String : AnyObject] {
                    //执行成功回调
                    let model = OriginalNetDataModel.init(dict: dict)
                    success(model)
                    return
                }
                //如果程序走到这里  成功回调的结果 无法转换为字典形式的数据
                let error = NSError(domain: dataErrorDomain, code: -10000, userInfo: [NSLocalizedDescriptionKey : "(手动判断)数据格式错误"])
                self.printMessage(urlString, paramete: error)
                failure(error)
            }, failure: { (_, error) in
                self.alert.gdHide()//////////////////////////////
                //执行失败的回调
                self.printMessage(urlString, paramete: error as AnyObject?)
                failure( error as NSError)
                
            })
        }
    }

    func testtesttest ()  {
        post("URLString", parameters: "parameters", progress: { (progress) in
            
        }, success: { (tase , resultData) in
            
        }) { (task , error ) in
            
        }
    }
    
    //MARK: 初始化token
    func initToken(_ success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ()) -> () {
        
        if token != nil && token != "nil" {
            mylog(token)
            success(OriginalNetDataModel.init(dict: ["data": "" as AnyObject , "msg" : "" as AnyObject, "status" : "0" as AnyObject]))
            return;
        }
        let url  = "InitKey"
        let para = [String : AnyObject]()
        self.requestJSONDict(RequestType.GET, urlString: url, parameters: para, success: { (result) in
            var tempToken =  (UIDevice.current.identifierForVendor?.uuidString)! + (result.data as? String ?? "")
            //            tempToken = tempToken?.md5()
            //            var tempToken = "383B255B-87F7-466C-914A-0B1A35AA5DC3" + (result.data as! String)//先把token写死
            tempToken = tempToken.md5()
            
//            GDStorgeManager.standard.setValue(tempToken, forKey: "token")
            self.token = tempToken
            success(result)
        }) { (error) in
            failure(error)
            GDAlertView.alert("初始化失败 , 请检查网络", image: nil, time: 2, complateBlock: nil)
        }
        
    }
    //MARK: 退出登录
    func loginOut(_ success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ()) -> () {
        let url = "LoginOut"
        let para = [String : AnyObject]()
        Account.shareAccount.deleteAccountFromDisk()//有没有联网都退出
//        GDStorgeManager.standard.setValue("nil", forKey: "token")//token 赋值为空//不管有没有联网
        self.token = nil
        self.requestDataFromNewWork(RequestType.POST, urlString: url, parameters: para, success: { (result) in
            if result.status > 0 {
                //                Account.shareAccount.deleteAccountFromDisk()
                //                UserDefaults.standard.setValue("nil", forKey: "token")//token 赋值为空
            }
            success(result)
        }) { (error) in
            failure(error)
        }
    }
    //MARK: 登录
    
    func login(_ name : String , password : String , success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ()) -> () {
        let url = "Login"
        let para = ["username" : name ,  "password" : password ]
        requestDataFromNewWork(RequestType.POST, urlString: url , parameters: para as [String : AnyObject] , success: { (result) in
                if result.status > 0 {
                    if let data = result.data {//登录成功 , 先把memberID放到内存中 , 方便其他类取用(此处是用来判断登录状态)
                        if let memberid = data as? String {
                            Account.shareAccount.member_id = memberid
                        }
                    }
                    self.gotPersonalData({ (result) in
                        
                    }, failure: { (error) in
                    })
                }
                
            
            
            success(result)
        }) { (error) in
            failure(error)
        }
    }
    
    
    //MARK: 获取个人资料
    
    func gotPersonalData(_ success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ())  -> () {
        let url = "UserInfo"
        let para = [String : AnyObject]()
        requestDataFromNewWork(RequestType.GET, urlString: url, parameters: para, success: { (result) in
            
            if result.status == 30 {
                if let strMessage = result.data as? String{
                    mylog(strMessage)
                }
                if let dictMessage = result.data as? [String : AnyObject]{
                    mylog(dictMessage)
                    Account.init(dict: dictMessage).saveAccount()
                }
                if let arrMessage = result.data as? [AnyObject]{
                    mylog(arrMessage)
                    let arr = arrMessage.first
                    if let subDictMessage = arr as? [String : AnyObject]{
                        mylog(subDictMessage)
                        Account.init(dict: subDictMessage).saveAccount()
                    }
                    if let subArrMessage = arr as? [AnyObject]{
                        mylog(subArrMessage)
                    }
                    if let subStrMessage = arr as? String{
                        mylog(subStrMessage)
                    }
                }
                
            }
            
            success(result)
            
        }) { (error) in
            failure(error)
        }
        
    }
    
    //MARK: 获取个人中心页面数据
    
    func gotProfilePageData(_ success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ()) -> () {
        let url = "MyPage"
        let para = [String : AnyObject]()
        requestDataFromNewWork(RequestType.GET, urlString: url, parameters: para, success: { (result) in
            success(result)
        }) { (error) in
            failure(error)
        }
    }
    
    
    //MARK: 获取购物车
    func gotShopCarData(_ success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ()) -> () {
        /**GET: http://api.zjlao.com/V2/ShopCart/rest*/
        let url = "ShopCart"
        //        let para = ["username" : name ,  "password" : password ]
        let para = [String : AnyObject]()
        requestDataFromNewWork(RequestType.GET, urlString: url, parameters: para, success: { (result) in
            success(result)
        }) { (error) in
            failure(error)
        }
    }
    
    //MARK: 商品规格
    func gotGoodsSpecification(goodsID : String , _ success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ())  {
        /**GET: http://api.zjlao.com/V2/SelectSpec/rest*/
        
        let url = "SelectSpec"
        //        let para = ["username" : name ,  "password" : password ]
        let para = ["goods_id":goodsID]
        requestDataFromNewWork(RequestType.GET, urlString: url, parameters: para as [String : AnyObject], success: { (result) in
            success(result)
        }) { (error) in
            failure(error)
        }
        
    }
    
    
    //MARK: 保存deviceToken和registerID
    func saveDeviceTokenAndRegisterID(deviceToken : String? , registerID : String? ,  _ success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ()) -> () {
        
        if deviceToken == nil && registerID == nil  {
            failure(NSError.init())
            return
        }
        /**POST: http://api.zjlao.com/V2/Push/rest*/
        let url = "Push"
        //        let para = ["username" : name ,  "password" : password ]
        var para = [String : AnyObject]()
        if let deviceTokenStr = deviceToken  {
            para["devicetoken"] = deviceTokenStr as AnyObject
        }
        if let registerIDStr  = registerID {
            para["registrationID"] = registerIDStr as AnyObject
        }
        requestDataFromNewWork(RequestType.POST, urlString: url, parameters: para, success: { (result) in
            success(result)
        }) { (error) in
            failure(error)
        }
    }
    // MARK: 注释 : v2 👇
    
    
    // MARK: 注释 : 七牛文件上传管理类
    lazy var qnUploadManager: QNUploadManager = {
        let config  = QNConfiguration.build { (builder ) in
            builder?.setZone(QNZone.zone1())
        }
        let mgr = QNUploadManager.init(configuration: config!)
        return mgr!
        
    }()
    
    
    
    
    
    
    
    
    /**
     3.获取系统广告
     接口地址：sys_advert
     请求方式：get
     
     */
    func getAD( success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ())  {
        let url =  "sys_advert"
        let para = ["token" : self.token ]
        mylog("获取广告是 , 打印token \(self.token)")
        self.QZRequestJSONDict(RequestType.GET, urlString: url , parameters: para as [String : AnyObject] , success: { (result) in
            success(result)
        }) { (error) in
            mylog("获取广告的请求失败")
            failure(error)
        }
        
        
    }
    
    
    
    
    func generateQNUploadMgr()  -> QNUploadManager{
        let config  = QNConfiguration.build { (builder ) in
            builder?.setZone(QNZone.zone1())
        }
        let mgr = QNUploadManager.init(configuration: config!)
        return mgr!
        
    }
    func getQiniuToken(success : @escaping (OriginalNetDataModel )->() , failure : @escaping (NSError)->()) {
        
        let url = "qiniu"
        let para = [
            "token" : self.token ?? "看看",
            ] as [String : Any]
        
        self.QZRequestJSONDict(RequestType.GET, urlString: url , parameters: para as [String : AnyObject] , success: { (result) in
            success(result)
        }) { (error) in
            
            failure(error)
        }
        
    }
    /**
     传七牛获取图片链接
     */
    
    func uploadAvart(data:Data ,token : String , complite : @escaping QNUpCompletionHandler) {
        qnUploadManager.put(data , key: nil , token: token, complete: { (responseInfo, theKey, successInfo) in
            complite(responseInfo , theKey , successInfo)
        }, option: nil )
        
    }
    
    func testUpload(asset:PHAsset) {
        
        /**
         *    上传完成后的回调函数
         *
         *    @param info 上下文信息，包括状态码，错误值
         *    @param key  上传时指定的key，原样返回
         *    @param resp 上传成功会返回文件信息，失败为nil; 可以通过此值是否为nil 判断上传结果
         public typealias QNUpCompletionHandler = (QNResponseInfo?, String?, [AnyHashable : Any]?) -> Swift.Void
         */
        
        qnUploadManager.put(asset , key: asset.localIdentifier, token: "", complete: { (responseInfo, Str , info ) in
            //            QNResponseInfo
            
        }, option: nil )
    }
    
    /**
     1.获取附近的圈子
        接口地址：circle
        请求方式：get

     
     */
    func getNearbyCircles(circleNum : String = "6" , success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ())  {
        let url =  "circle"
        let location = GDLocationManager.share.locationManager.location
        let longtitude = String.init(format: "%.08f", arguments: [(location?.coordinate.longitude)!])
        let latitude = String.init(format: "%.08f", arguments: [(location?.coordinate.latitude)!])
        let para = ["token" : self.token , "circle_number" : circleNum , "coordinate" : "\(longtitude),\(latitude)" ,]
        self.QZRequestJSONDict(RequestType.GET, urlString: url , parameters: para as [String : AnyObject] , success: { (result) in
            success(result)
        }) { (error) in
            mylog("上传头像的请求失败")
            failure(error)
        }
        
        
    }
    /**
     3.创建圈子
     接口地址：circle
     请求方式：post
     请求参数：
     
     */
    func createNewCircle(name : String ,memberNum : String? = "20" , password : String? ,  success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ())  {
        let url =  "circle"
        let location = GDLocationManager.share.locationManager.location
        let longtitude = String.init(format: "%.08f", arguments: [(location?.coordinate.longitude)!])
        let latitude = String.init(format: "%.08f", arguments: [(location?.coordinate.latitude)!])
        var para = ["token" : self.token ?? "" , "circle_member_number" : memberNum ?? "20" , "coordinate" : "\(longtitude),\(latitude)" ,  "circle_name" : name] as [String : Any]
        if let pwd   = password{
            para["circle_password"] = pwd
        }
        self.QZRequestJSONDict(RequestType.POST, urlString: url , parameters: para as [String : AnyObject] , success: { (result) in
            success(result)
        }) { (error) in
            mylog("上传头像的请求失败")
            failure(error)
        }
        
        
    }
    
    /**
     2.获取圈子的详情
     接口地址：circle/<id>
     请求方式：get
     
     */
    func getCircleDetail(circleID : String , page : String = "0" , password : String? ,  success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ())  {
        let url =  "circle/" + circleID
//        let location = GDLocationManager.share.locationManager.location
//        let longtitude = String.init(format: "%.08f", arguments: [(location?.coordinate.longitude)!])
//        let latitude = String.init(format: "%.08f", arguments: [(location?.coordinate.latitude)!])
        var para = ["token" : self.token ?? "" , "page" : page ] as [String : Any]
        if let pwd   = password{
            para["circle_password"] = pwd
        }
        self.QZRequestJSONDict(RequestType.GET, urlString: url , parameters: para as [String : AnyObject] , success: { (result) in
            success(result)
        }) { (error) in
            mylog("获取圈子详情 请求失败")
            failure(error)
        }
        
        
    }
    /**
     1.插入媒体到相册
     接口地址：media
     请求方式：post
     请求参数：
     media_type    int    媒体类型(1、图片 2、视频)
     */
    func insertMediaToAlbum(albumID : String ,original:String ,  type : String  ,success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ())  {
        let url =  "media"
        var para = [ "album_id" : albumID  , "token" : self.token ?? "" , "original" : original , "media_type" : type  ] as [String : Any]

        self.QZRequestJSONDict(RequestType.POST, urlString: url , parameters: para as [String : AnyObject] , success: { (result) in
            success(result)
        }) { (error) in
            mylog("插入媒体 请求失败")
            failure(error)
        }
        
        
    }
    
    
    
    /**
     1.创建媒体
     接口地址：media
     请求方式：post
     请求参数：
     
     */
    func insertMediaToCircle(circleID : String ,original:String ,  type : String  , description : String? ,  media_spec : CGSize ,success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ())  {
        let url =  "media"
        var para = [ "circle_id" : circleID  , "token" : self.token ?? "" , "original" : original , "media_type" : type ,"media_width":media_spec.width , "media_height":media_spec.height  ] as [String : Any]
        if let descrip   = description{
            para["description"] = descrip
        }
        self.QZRequestJSONDict(RequestType.POST, urlString: url , parameters: para as [String : AnyObject] , success: { (result) in
            success(result)
        }) { (error) in
            mylog("插入媒体 请求失败")
            failure(error)
        }
        
        
    }
    
    
    /**
     5.我的首页
     接口地址：users
     请求方式：get
     */
    
    func myHistory( page : String?  , create_at : String? ,success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ())  {
        let url =  "media"
        var para = [  "token" : self.token ?? ""  ] as [String : Any]
        if let create_at   = create_at{
            para["create_at"] = create_at
        }
        if let page   = page{
            para["page"] = page
        }
        self.QZRequestJSONDict(RequestType.GET, urlString: url , parameters: para as [String : AnyObject] , success: { (result) in
            success(result)
        }) { (error) in
            mylog("获取我的发布历史 请求失败")
            failure(error)
        }
        
        
    }

    /**
     2.查看媒体
     接口地址：media/<id>
     请求方式：get
     
     */
    func getMediaDetail(circleID : String?/*圈子详情点进去时要传*/ ,messageID : String?/*回复别人是传*/,mediaID : String , offset : Int?/*左右分页时传,暂定-1*/  = nil ,create_at : String?/*回去时传*/ = nil  , _ success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ())  {
        let url =  "media/" + mediaID
        var para : [String : Any] = [
            "token" : self.token ?? ""
        ]
        
        if let circleIDStr = circleID {
            para["circle_id"] = circleIDStr
        }
        if let offSetInt = offset {
            para["offset"] = offSetInt
        }
        if let messageIDStr = messageID {
            para["message_id"] = messageIDStr
        }
        if let creatTime = create_at {
            para["create_at"] = creatTime
        }
        self.QZRequestJSONDict(RequestType.GET, urlString: url , parameters: para as [String : AnyObject] , success: { (result) in
            success(result)
        }) { (error) in
            
            failure(error)
        }
        
        
    }
    
    
    func uploadPHAssets(albumID:String ,type : String = "1", assets:[PHAsset]?)  {
        
        self.getQiniuToken(success: { (model ) in
            if let token = model.data as? String {
                for ( _ , asset) in (assets ?? []).enumerated() {
                    
                    self.qnUploadManager.put(asset, key: nil , token: token, complete: { (response, key , info ) in
                    //1185
                        if let key = info?["key"] as? String{
                            self.insertMediaToAlbum(albumID: albumID, original: key, type: type, success: { (result ) in
                                 mylog("插入媒体到相册 请求结果 : \(model.status) , 数据 :\(model.data)")
                            }, failure: { (error ) in
                                 mylog("插入媒体到相册 请求结果 : \(model.status) , 数据 :\(model.data)")
                            })
                        }
                    }, option: nil )
                    
                }
            }
        }) { (error ) in
            mylog("获取七牛token失败\(error)")
        }
    }
    /**
     7.点赞/取消点赞
     接口地址：good
     请求方式：post
     请求参数：
     
 */
    func performZan(mediaID  : String  , success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ())  {
        let url =  "good"
     
        let para = ["token" : self.token , "media_id" : mediaID ]
        self.QZRequestJSONDict(RequestType.POST, urlString: url , parameters: para as [String : AnyObject] , success: { (result) in
            success(result)
        }) { (error) in
            mylog("点赞的请求失败")
            failure(error)
        }
        
        
    }
    
    
    /**
 4.评论
 接口地址：comment
 请求方式：post
 */
    func performComment(mediaID  : String , content : String , success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ())  {
        let url =  "comment"
        
        let para = ["token" : self.token , "media_id" : mediaID , "content" : content ]
        self.QZRequestJSONDict(RequestType.POST, urlString: url , parameters: para as [String : AnyObject] , success: { (result) in
            success(result)
        }) { (error) in
            mylog("评论的请求失败")
            failure(error)
        }
        
        
    }
    /**
 6.我的信息
 接口地址：users_message
 请求方式：get
 请求参数：
 */
    
    func getMessageList(mediaID  : String , page : Int , success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ())  {
        let url =  "users_message"
        
        let para = ["token" : self.token , "page" : page ] as [String : Any]
        self.QZRequestJSONDict(RequestType.GET, urlString: url , parameters: para as [String : AnyObject] , success: { (result) in
            success(result)
        }) { (error) in
            mylog("消息列表的请求失败")
            failure(error)
        }
        
        
    }
    /*
 3.我的好友
 接口地址：friend
 请求方式：get
 */
    func getFriendList( page : Int , success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ())  {
        let url =  "friend"
        let para = ["token" : self.token , "page" : page ] as [String : Any]
        self.QZRequestJSONDict(RequestType.GET, urlString: url , parameters: para as [String : AnyObject] , success: { (result) in
            success(result)
        }) { (error) in
            mylog("好友列表的请求失败")
            failure(error)
        }
        
        
    }
    /**
     2.查看用户信息
     接口地址：users/<id>
     请求方式：get
     请求参数：
     
 */
    
    func getUserInfomation(userID: String , success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ())  {
        let url =  "user" //+ userID
        let para = ["token" : self.token  ] as [String : Any]
        self.QZRequestJSONDict(RequestType.GET, urlString: url , parameters: para as [String : AnyObject] , success: { (result) in
            success(result)
        }) { (error) in
            mylog("个人信息的请求失败")
            failure(error)
        }
        
        
    }
    /**
 
 1.修改用户信息
 接口地址：users
 请求方式：POST
*/
    func editUserInfomation(avarta: String? = nil , name : String? = nil ,gender:String? = nil , mobile : String? = nil , format : String? = nil , description : String? = nil , success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ())  {
        let url =  "user"
        var para  = ["token" : self.token ?? ""  ] as [String : Any]
        if let avarta = avarta /*, let format = format*/{
            para["avatar"] = avarta
//            para["format"] = format
        }
        if let name  = name {
            para["name"] = name
        }
        if let mobile  = mobile {
            para["mobile"] = mobile
        }
        if let description = description {
            para["desctiption"] = description
        }
        if let gender = gender  {
            para["sex"] = gender
        }
        self.QZRequestJSONDict(RequestType.POST , urlString: url , parameters: para as [String : AnyObject] , success: { (result) in
            if result.status == 200 {
                self.QZFirstInit({ (model ) in
                    
                }, failure: { (error ) in
                    
                })
            }
            success(result)
        }) { (error) in
            mylog("修改个人信息的请求失败")
            failure(error)
        }
        
        
    }
    /*接口地址：album
     请求方式：get
     */
    
    func getAlbums( album_type : Int ,create_at : String ,page : Int , success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ())  {
        let url =  "album"
        var para  = ["token" : self.token ?? "" , "album_type" : album_type , "create_at" : create_at , "page" : page ] as [String : Any]
       
        self.QZRequestJSONDict(RequestType.GET , urlString: url , parameters: para as [String : AnyObject] , success: { (result) in
            success(result)
        }) { (error) in
            mylog("获取所有相册的请求失败")
            failure(error)
        }
        
        
    }
    
    /*3.创建相册
     接口地址：album
     请求方式：post
     请求参数：
     */
    
    func creatAlbum( albumName : String, success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ())  {
        let url =  "album"
        var para  = ["token" : self.token ?? "" , "album_name" : albumName ] as [String : Any]
        
        self.QZRequestJSONDict(RequestType.POST , urlString: url , parameters: para as [String : AnyObject] , success: { (result) in
            success(result)
        }) { (error) in
            mylog("创建请求失败")
            failure(error)
        }
        
        
    }
    // MARK: 注释 : v2 👆
    //MARK:
    //MARK:
    //MARK:
    //MARK:
    //MARK:
    //MARK:
    //MARK:
}
