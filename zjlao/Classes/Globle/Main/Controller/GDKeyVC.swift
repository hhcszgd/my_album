//
//  GDKeyVC.swift
//  zjlao
//
//  Created by WY on 17/1/15.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit
import CoreGraphics
//import GPUImage
import CoreLocation
import MapKit
class GDKeyVC: UINavigationController  ,UITabBarControllerDelegate , LoginDelegate  {

    var avPlayerVC : AVPlayerViewController?
    lazy var customViewContainer = UIControl()
    lazy var imageView = UIImageView()
    lazy var sendTimeAndLocation = UILabel()
    lazy var textFieldContainer = UIView()
    lazy var sendButton = UIButton()
    lazy var cancleButton = UIButton()
    lazy var descripLabel = UILabel()
    lazy var textField = UITextField()//UITextView()
    lazy var filtersView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var currentCircleID : String = "0"
    var captureOriginalImage : UIImage?//拍摄的原图片
    var captureEditImage : UIImage?{
        willSet{
        
        }
    }//拍摄的编辑后的图片
    
    // MARK: 注释 : filters
    var selectedItem  : GDFilterCell?
    
    lazy var filterModels : [GDFilterCellModel] = {
        var tempFilters = [GDFilterCellModel]()
        
        let origin = GPUImageSepiaFilter()//原图
        let originModel = GDFilterCellModel()
        originModel.title = "原图"
        tempFilters.append(originModel)
        
        let beauty = GPUImageBeautifyFilter.init()
        let beautyModel = GDFilterCellModel()
        beautyModel.title = "人物"
        beautyModel.filter = beauty
        tempFilters.append(beautyModel)
        
        let sepia = GPUImageSepiaFilter()//怀旧
        let sepiaModel = GDFilterCellModel()
        sepiaModel.filter = sepia
        sepiaModel.title = "怀旧"
        tempFilters.append(sepiaModel)
        
        let grayScale  = GPUImageGrayscaleFilter()//灰度
        let grayScaleModel = GDFilterCellModel()
        grayScaleModel.filter = grayScale
        grayScaleModel.title = "灰度"
        tempFilters.append(grayScaleModel)
        
//        let  glassSphere = GPUImageGlassSphereFilter()//水晶球效果
//        let glassSphereModel = GDFilterCellModel()
//        glassSphereModel.title = "水晶球"
//        glassSphereModel.filter = glassSphere
//        tempFilters.append(glassSphereModel)
        
        let stretchDistortion = GPUImageStretchDistortionFilter()//哈哈镜
        let stretchDistortionModel = GDFilterCellModel()
        stretchDistortionModel.title = "哈哈镜"
        stretchDistortionModel.filter = stretchDistortion
        tempFilters.append(stretchDistortionModel)
        
//        let beautiful = GPUImageBeautifyFilter.init()
//        let beautyModel = GDFilterCellModel()
//        beautyModel.filter = beautiful
//        beautyModel.title = "美颜"

        
        
        
        
        return tempFilters
    }()
    
    var priviousVC = UINavigationController() //记录上一次控制器
    var captureCallback : ((UIImage?) -> ())?
    var mainTabbarVC : GDMainTabbarVC? {
        
        if self.childViewControllers.count > 0 {
            if let vc = self.childViewControllers[0] as? GDMainTabbarVC{
                return vc
            }else{
                return nil
            }
        }else{
            return nil
        }
        
    }
    weak var keyVCDelegate : AfterChangeLanguageKeyVCDidApear?
    static let share: GDKeyVC = {
        let tempMainTabbarVC = GDMainTabbarVC()
        let tempKeyVC = GDKeyVC(rootViewController: tempMainTabbarVC)
        tempMainTabbarVC.delegate = tempKeyVC
        
        return tempKeyVC
    }()
    //    override init(rootViewController: UIViewController) {
    //
    //    }
    //
    //    required init?(coder aDecoder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    
    //    init(rootVC: UIViewController?) {
    //        super.init(rootViewController: mainTabbarVC)
    //        mainTabbarVC.delegate = self
    //    }
    //
    //    required init?(coder aDecoder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    //    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    //        super.init(nibName: nil, bundle: nil)
    //    }
    func restartAfterChangedLanguage()  {
        for vc in self.childViewControllers {
            if let targetVC = vc as? GDMainTabbarVC {
                targetVC.restartAfterChangeLanguage()
            }
        }
        
    }
    var currentTabbarIndex : Int {
        if self.childViewControllers.count > 0 {
            if let vc = self.childViewControllers[0] as? GDMainTabbarVC{
                return vc.selectedIndex
            }else{
                return 0
            }
        }else{
            return 0
        }
        
        //        if let tabbarvc  = mainTabbarVC {
        //            return tabbarvc.selectedIndex
        //        }else{
        //            return 0
        //        }
    }
    var currentSubVC : UIViewController?{
        
        if self.childViewControllers.count > 0 {
            if let vc = self.childViewControllers[0] as? GDMainTabbarVC{
                return vc.selectedViewController
            }else{
                return nil
            }
        }else{
            return nil
        }
        //        if let tabbarvc  = mainTabbarVC {
        //            return tabbarvc.selectedViewController
        //        }else{
        //            return nil
        //        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.isHidden = true;
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: tabbarViewControllerDelegate
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool{
//        GDKeyVC.share.mainTabbarVC?.tabBar.items?.first?.badgeValue = nil

//        self.priviousVC = self.mainTabbarVC?.selectedViewController as! UINavigationController //记录上一次控制器
//        
//        mylog(viewController)
//        
//        guard  let _ =  viewController as? ShopCarNaviVC else {  return true}
//        
//        if Account.shareAccount.isLogin {
//            return true
//        }else{
//            let loginVC = LoginVC()
//            loginVC.loginDelegate = self
//            let loginNaviVC = LoginNaviVC.init(rootViewController: loginVC)
//            loginNaviVC.navigationBar.isHidden = true
//            UIApplication.shared.keyWindow!.rootViewController!.present(loginNaviVC, animated: true, completion: nil)
//            return false
//        }
        
        
        self.priviousVC = self.mainTabbarVC?.selectedViewController as! UINavigationController //记录上一次控制器
        
        
        
//        mylog(viewController)
        func juge() -> Bool{
            if Account.shareAccount.accountStatus == AccountStatus.authenticated {
                return true
            }else{
                
                self.initializationAccountInfo()
                return false
            }
        }
        if let _ = viewController as? LaoNaviVC {
            if juge() {self.setupCarame()}
//            if juge() {self.setupCustomCarame()}
            return false
        }
        if let _ = viewController as? ClassifyNaviVC {
            return juge()
        }
        if let _ = viewController as? ShopCarNaviVC {
            return juge()
        }
        if let _ = viewController as? ProfileNaviVC {
//            GDKeyVC.share.mainTabbarVC?.tabBar.items?.last?.badgeValue = nil
            GDKeyVC.share.settabBarItem(number: nil , index: 4)
            
            return juge()
        }
        return  true
//        guard  let _ =  viewController as? LaoNaviVC else {
//            return true
//        }
//        self.setupCarame()
//       
//        return false

    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController){
        if let bool = self.mainTabbarVC?.selectedViewController?.isKind(of: HomeVaviVC.self) {
            if bool && self.priviousVC == viewController{
                
                mylog("发送首页重复点击通知")
                NotificationCenter.default.post(name: GDHomeTabBarReclick, object: nil, userInfo: nil)
            }
        }
        if let bool = self.mainTabbarVC?.selectedViewController?.isKind(of: ClassifyNaviVC.self) {
            if bool && self.priviousVC == viewController {
                NotificationCenter.default.post(name: GDClassifyTabBarReclick, object: nil, userInfo: nil)
                mylog("发送分类重复点击通知")
            }
        }
        if let bool = self.mainTabbarVC?.selectedViewController?.isKind(of: LaoNaviVC.self) {
            if bool && self.priviousVC == viewController {
                NotificationCenter.default.post(name: GDLaoTabBarReclick, object: nil, userInfo: nil)
                mylog("发送lao重复点击通知")
            }
        }
        if let bool = self.mainTabbarVC?.selectedViewController?.isKind(of: ShopCarNaviVC.self) {
            if bool && self.priviousVC == viewController {
                NotificationCenter.default.post(name: GDShopcarTabBarReclick, object: nil, userInfo: nil)
                mylog("发送购物车重复点击通知")
            }
        }
        if let bool = self.mainTabbarVC?.selectedViewController?.isKind(of: ProfileNaviVC.self) {
            if bool && self.priviousVC == viewController {
                NotificationCenter.default.post(name: GDProfileTabBarReclick, object: nil, userInfo: nil)
                mylog("发送我的重复点击通知")
            }
        }
        
//        mylog(self.mainTabbarVC?.selectedViewController)
    }
    
    // MARK: 注释 :
    
    /*判断是否认证 , 不认证就弹出 //返回值代表是否弹出认证 ,true弹出,false不弹(网络请求里用返回值)*/
    func initializationAccountInfo() -> Bool {
        if Account.shareAccount.accountStatus != AccountStatus.authenticated {
            DispatchQueue.main.async {
//                let vc  = GDSetupUserInfoVC()
//                GDKeyVC.share.pushViewController(vc , animated: true)
                self.dealwithLocation()
            }
            return true
        }
        return false
    }

    
    
    func dealwithLocation()  {
        if !CLLocationManager.locationServicesEnabled() {//GPS不可用 ,设备不支持
            mylog("gps定位功能不可用")
        }else{//GPS可用
            if GDLocationManager.share.authorizationStatus() == CLAuthorizationStatus.authorizedAlways || GDLocationManager.share.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse{//app定位功能可用
                let vc  = GDSetupUserInfoVC()
                //                let vc = GDSetupLocationEnableVC()
                GDKeyVC.share.pushViewController(vc , animated: true)
                mylog("app定位功能可用")
                
            }else{//app定位功能不可用 ,请前往设置中心打开app使用位置权限
                self.alertmessage(message: "开启定位权限")
//                NotificationCenter.default.addObserver(self , selector: #selector(authorizationStatusChanged(status:)), name: GDLocationManager.GDAuthorizationStatusChanged, object: nil)
//                GDLocationManager.share.startUpdatingLocation()
//                
//                self.window = nil
//                self.window = UIWindow(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
//                self.window!.rootViewController = GDSetupLocationEnableVC()
//                //请打开gps定位功能
//                self.window!.makeKeyAndVisible()
                mylog("app没有定位权限")
            }
        }
        
        
    }

    func alertmessage(message : String )  {
        let alertvc = UIAlertController.init(title: message, message: nil , preferredStyle: UIAlertControllerStyle.alert)
        let action1 = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.default) { (action ) in
            alertvc.dismiss(animated: true , completion: nil )
//            self.dealwithLocation()
        }
        let action2 = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default) { (action ) in
            let url : URL = URL(string: UIApplicationOpenSettingsURLString)!
            if UIApplication.shared.canOpenURL(url ) {
                UIApplication.shared.openURL(url)
            }
        }
        alertvc.addAction(action1)
        alertvc.addAction(action2)

        self.present(alertvc, animated: true , completion: nil )
    }
    
    
    
    
    
    
    
    
    
    public func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        let ani : TabBarVCAnimat = TabBarVCAnimat()
        //mylog(fromVC)
        //mylog(toVC)
        //mylog(self.mainTabbarVC?.selectedViewController)
        return ani
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.keyVCDelegate?.languageHadChanged()
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    func selectChildViewControllerIndex(index : Int) -> () {
        
        var selectedIndex = index
        
        if selectedIndex < 0  {
            selectedIndex = 0
        }else if selectedIndex > 4{
            selectedIndex = 4
        }else if selectedIndex == 3 {
            if Account.shareAccount.isLogin {
                mainTabbarVC?.selectedIndex = selectedIndex
            }else{
                let loginVC = LoginVC()
                loginVC.loginDelegate = self
                let loginNaviVC = LoginNaviVC.init(rootViewController: loginVC)
                UIApplication.shared.keyWindow!.rootViewController!.present(loginNaviVC, animated: true, completion: nil)
                
            }
        }
        mainTabbarVC?.selectedIndex = selectedIndex
    }
    
    //登录结果代理
    func loginResult(result: Bool) {
        if result {
            mainTabbarVC?.selectedIndex = 3
        }
    }
    
    func  settabBarItem(number : String? , index : Int ){
        if index < 0 || index > 4 {return}
        if let numStr  = number {
            self.setnum(num: numStr, index: index)
        }else{
            self.setnum(num: nil , index: index)
        }
    }
    private  func setnum (num : String? , index : Int )  {
        if let items = mainTabbarVC?.tabBar.items {
            let tabBarItem : UITabBarItem = items[index]
            tabBarItem.badgeValue = num
        }
    }
    

}
import MobileCoreServices
import AVKit
extension GDKeyVC : UIImagePickerControllerDelegate , UINavigationControllerDelegate , UICollectionViewDelegate , UICollectionViewDataSource{

    func setupCustomCarame()  {//调用自定义照相机
        //return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
        /*
        if (!UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.rear ) || !UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.front )){
            GDAlertView.alert("摄像头不可用", image: nil , time: 2, complateBlock: nil)
        }
        let picker = UIImagePickerController.init()
        picker.delegate = self 
        picker.sourceType = UIImagePickerControllerSourceType.camera//这一句一定在下一句之前
//        picker.mediaTypes = [kUTTypeMovie as String , kUTTypeVideo as String , kUTTypeImage as String  , kUTTypeJPEG as String , kUTTypePNG as String]//kUTTypeMPEG4
        picker.allowsEditing = true ;
        picker.showsCameraControls = true
//        picker.cameraOverlayView = UISwitch()
        //  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureMode.photo
        //            pickerVC.navigationBar.isHidden = true
        UIApplication.shared.keyWindow!.rootViewController!.present(picker, animated: true, completion: nil)
        */
        UIApplication.shared.keyWindow!.rootViewController!.present(FilterDisplayViewController(type: GDCameraType.video), animated: true, completion: nil)//自定义摄像头
//                UIApplication.shared.keyWindow!.rootViewController!.present(FilterDisplayViewController(), animated: true, completion: nil)//自定义照相机 , todo
        
    }
    
    
 
    
    func setupCarame ()  {//调用系统相机
        //return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
//        if (!UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.rear ) || !UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.front )){
//            GDAlertView.alert("摄像头不可用", image: nil , time: 2, complateBlock: nil)//摄像头专属
//        }
        let picker = UIImagePickerController.init()
        picker.delegate = self
        if (UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.rear ) || UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.front )){
            //            GDAlertView.alert("摄像头不可用", image: nil , time: 2, complateBlock: nil)//摄像头专属
            
            picker.sourceType = UIImagePickerControllerSourceType.camera//这一句一定在下一句之前
        }else{
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        picker.mediaTypes = [kUTTypeMovie as String , kUTTypeVideo as String , kUTTypeImage as String  , kUTTypeJPEG as String , kUTTypePNG as String]//kUTTypeMPEG4
        picker.allowsEditing = true ;
        picker.videoMaximumDuration = 12 
//        picker.showsCameraControls = true//摄像头专属
        //        picker.cameraOverlayView = UISwitch()
//        picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureMode.photo
        //            pickerVC.navigationBar.isHidden = true
        UIApplication.shared.keyWindow!.rootViewController!.present(picker, animated: true, completion: nil)
        //        UIApplication.shared.keyWindow!.rootViewController!.present(FilterDisplayViewController(), animated: true, completion: nil)//自定义照相机 , todo
    }

    // MARK: 注释 : imagePickerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        mylog(info)
        if let type  = info[UIImagePickerControllerMediaType] as? String{
            mylog(type)
            picker.dismiss(animated: true) {}
            if type == "public.movie" {
                self.dealModie(info: info)
            }else if type == "public.image" {
                self.dealImage(info: info)
            }
        }
    }
    
    func upload(data : Data ,rectSize : CGSize = CGSize(width: 100, height: 100) ,  type : String /**1:image  , 2 movie*/)  {
        // MARK: 注释 : 插入七牛存储👇
        GDNetworkManager.shareManager.getQiniuToken(success: { (model ) in
            
            if let token = model.data as? String {
                mylog("获取七牛touken请求的状态码\(model.status)  , data数据 : \(token)")
                GDNetworkManager.shareManager.uploadAvart(data: data ,token : token , complite: { (responseInfo, theKey , successInfo) in
                    mylog("上传到七牛的请求结果 responseInfo: \(responseInfo) , theKey : \(theKey) , successInfo \(successInfo) ")
                    if successInfo == nil {
                        GDAlertView.alert("操作失败,请重试", image: nil, time: 2, complateBlock: nil)
                    }else{
                        if let key = successInfo?["key"] as? String{
                            print(key)//get avarta key
                            //save  mediaKey to our server
                            GDNetworkManager.shareManager.insertMediaToCircle(circleID: self.currentCircleID, original: key , type: type , description: nil , media_spec:  rectSize, success: { (model ) in
                                mylog("插入媒体到圈子 请求结果 : \(model.status) , 数据 :\(model.data)")
//                                self.getCircles()
                            }, failure: { (error ) in
                                mylog("插入媒体到圈子 请求结果 : \(error)")
                            })
                        }else{
                            mylog("插入媒体到圈子失败 : \(responseInfo)")
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
        
    }
    
    
    
    
    
    
    func dealModie(info:[String : Any])  {
        if let url  = info[UIImagePickerControllerMediaURL] as? URL {
            //file:///private/var/mobile/Containers/Data/Application/6142A42C-BDE9-43CF-8C2E-B04F06945925/tmp/51711806175__214B5E6E-8AD3-4AF0-9CA0-EF891A4B4543.MOV
//                let avPlayer : AVPlayer = AVPlayer.init(url: url)
//                let avPlayerVC : AVPlayerViewController  = AVPlayerViewController.init()
//                self.avPlayerVC = avPlayerVC
//                avPlayerVC.player = avPlayer
//                self.present(avPlayerVC, animated: true  , completion: { })
            
            
            do{
                let data : Data = try Data.init(contentsOf: url)
                mylog(data)
                mylog(data.count)
                
                DispatchQueue.global().async {
                    let dataBase64 = data.base64EncodedString()
                    let size = dataBase64.characters.count
                    mylog(size)
                    GDNetworkManager.shareManager.uploadMedia(circleID: self.currentCircleID, original: dataBase64, size: "\(size)",descrip :self.textField.text,formate : "MOV", { (model) in
                        mylog("图片上传结果:\(model.status)")
                        mylog(model.data)
                        self.updateCurrentCircleID(model: model)
                        self.textField.text = nil
                        
                        //                    mylog(model.data)
                    }) { (error ) in
                        mylog("图片上传结果:\(error)")
                    }
                }

                
                
            }catch{
                mylog(error)
            }
            
            }
    }
    
    func updateCurrentCircleID(model : OriginalNetDataModel) -> Void {
        if let any   = model.data {
            
            if let circleIdDict  = any as? [String : AnyObject] {
                if let circleidAny =  circleIdDict["circle_id"]{
                    self.currentCircleID = "\(circleidAny)"
                }
            }
        }

    }
    
    
    func dealImage(info:[String : Any])  {
        
        var theImage : UIImage?
        if let editImageReal  = info[UIImagePickerControllerEditedImage] as? UIImage {
            theImage = editImageReal
        }else{
            if let originlImage  = info[UIImagePickerControllerOriginalImage] as? UIImage {
                theImage = originlImage
            }
        }
        
//        let imgCompress1 =  self.perfromCompress(image: theImage ?? UIImage())
//        let imgCompress1 =  self.changeImageSize(image: theImage!, size: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width))
//        let imgCompressTemp =  self.compressImageWithC(image: theImage!, size:CGSize(width: UIScreen.main.bounds.size.width/3, height: UIScreen.main.bounds.size.width/3))
//        let imgCompressDestination =  self.compressImageWithC(image: imgCompressTemp, size:CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width))
        let aa = self.perfromCompress(image: theImage!)
        self.captureEditImage = aa
//        let dataBase64 = data?.base64EncodedString()
        self.setupDescripForImage(image: self.captureEditImage ?? UIImage())

    }
    
    
    
    
    func compressImageWithC(image : UIImage , size : CGSize /**按点, 不按像素*/) -> UIImage  {
        var size  = size
        if UIScreen.main.bounds.size.width == 375 {
            size.width *= 2
            size.height *= 2
        }else if (UIScreen.main.bounds.size.width == 414){
            size.width *= 3
            size.height *= 3
        }
        let  scale : CGFloat = min(size.width/image.size.width, size.height/image.size.height)
        mylog(scale)
        let width : size_t = size_t(image.size.width)
        let height : size_t = size_t(image.size.height)
//        let cs = CGColorSpaceCreateDeviceCMYK()
        let cs = CGColorSpaceCreateDeviceRGB()
        let temp : CGFloat = 1
        var bitmapRef =   CGContext.init(data: nil , width: size_t( CGFloat(size.width) * temp) , height: size_t(CGFloat(size.height)  * temp) , bitsPerComponent: 8, bytesPerRow: 0, space: cs , bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue /*CGImageAlphaInfo.alphaOnly.rawValue*/)
        mylog(size_t(CGFloat(height)  * temp))
//        CGImageAlphaInfo
        //        CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone)
        bitmapRef?.setTextDrawingMode(CGTextDrawingMode.fill)
        bitmapRef!.interpolationQuality = CGInterpolationQuality.low
        bitmapRef!.scaleBy(x: scale   , y: scale   ) //OC 对应的方法 CGContextScaleCTM(bitmapRef!, scale , scale)
//        free(&bitmapRef!)
        bitmapRef!.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: size.width * 1, height: size.height * 1 ))//设置图片在画布上的位置和大小,区分2x  3x
        let scaledImage = bitmapRef!.makeImage()
        let resultImage = UIImage(cgImage: scaledImage!)
        mylog(resultImage)
        return resultImage
    }
    
/*    func compressImageWithC(image : UIImage , size : CGSize ) -> UIImage  {
        var size  = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        if UIScreen.main.bounds.size.width == 375 {
            size.width *= 2
            size.height *= 2
        }else if (UIScreen.main.bounds.size.width == 414){
            size.width *= 3
            size.height *= 3
        }
        let ciimage : CIImage = CIImage.init(cgImage: image.cgImage!)
        let extent = ciimage.extent
        let  scale : CGFloat = min(size.width/extent.width, size.height/extent.height)
        mylog(scale)
        let width : size_t = size_t(extent.width)
        let height : size_t = size_t(extent.height)
        let cs = CGColorSpaceCreateDeviceCMYK()
        let temp : CGFloat = 1
        let bitmapRef =   CGContext.init(data: nil , width: size_t( CGFloat(width) * temp) , height: size_t(CGFloat(height)  * temp) , bitsPerComponent: 8, bytesPerRow: 0, space: cs , bitmapInfo: CGImageAlphaInfo.none.rawValue)
        mylog(size_t(CGFloat(height)  * temp))
        let context = CIContext(options: nil )
        let bitmapImage = context.createCGImage(ciimage, from: CGRect(x: 0, y: 0, width: size_t( CGFloat(width) * 1), height: size_t( CGFloat(width) * 1))) // 取要显示的区域在原图上的坐标
//        CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone)
        bitmapRef?.setTextDrawingMode(CGTextDrawingMode.fill)
        bitmapRef!.interpolationQuality = CGInterpolationQuality.low
        bitmapRef!.scaleBy(x: scale * 1  , y: scale * 1   ) //OC 对应的方法 CGContextScaleCTM(bitmapRef!, scale , scale)
       bitmapRef!.draw(bitmapImage!, in: CGRect(x: 0, y: 0, width: 375 * 2, height: 375 * 2 ))//设置图片在画布上的位置和大小
        let scaledImage = bitmapRef!.makeImage()
        return UIImage(cgImage: scaledImage!)
    }
  */
    func changeImageSize(image : UIImage , size : CGSize ) -> UIImage  {
        var size  = size
        
        if UIScreen.main.bounds.size.width == 375 {
            size.width *= 2
            size.height *= 2
        }else if (UIScreen.main.bounds.size.width == 414){
            size.width *= 3
            size.height *= 3
        }
        UIGraphicsBeginImageContextWithOptions(size , true , 0.5)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width , height: size.height  ))
       
        let  newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return newImage ?? UIImage()
        
    }
    func perfromCompress(image : UIImage) -> UIImage {
        var img = image
        for _  in 0...8 {
            let data =   UIImageJPEGRepresentation(img , 0.0) //  UIImagePNGRepresentation(editImageReal)
            img =  UIImage(data: data ?? Data()) ?? UIImage()
        }
        return img
        
    }
    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
//        
//    
//    }

    func setupDescripForImage(image:UIImage)  {
        self.prepareForSetupDescripViews(image:image)
        
    }
    func configCollectionView ()  {
        self.filtersView.register(GDFilterCell.self , forCellWithReuseIdentifier: "filterCell")
        self.customViewContainer.addSubview(self.filtersView)
        
        let margin : CGFloat = 20
        self.filtersView.frame  = CGRect(x: margin, y: self.textFieldContainer.frame.maxY + margin / 5 , width: SCREENWIDTH - margin * 2 , height: 100)
        self.filtersView.delegate = self
        self.filtersView.dataSource = self
        
        if let flowLayout  = self.filtersView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize  = CGSize(width: 64, height: 100)
            flowLayout.minimumInteritemSpacing = 10
            flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        mylog(filterModels.count)
        return self.filterModels.count
    }
    
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath)
        if let filterCell  = item as? GDFilterCell {
            let model = filterModels[indexPath.item]
            model.image = self.captureEditImage
            filterCell.model = model
            
            return filterCell
        }
        item.backgroundColor = UIColor.randomColor()
        return item
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        mylog(indexPath)
//        self.selectedFilter = self.filters[indexPath.item];
        if let item  = collectionView.cellForItem(at: indexPath) as? GDFilterCell {
            self.selectedItem = item
            self.imageView.image = item.imageview.image
        }
    }
    func prepareForSetupDescripViews(image:UIImage)  {
        let margin : CGFloat = 20


        if self.customViewContainer.superview == nil  {
            
            if let window = UIApplication.shared.keyWindow {
                window.addSubview(self.customViewContainer)
                self.customViewContainer.backgroundColor = UIColor.black
                self.customViewContainer.addTarget(self , action: #selector(whiteSpaceClick), for: UIControlEvents.touchUpInside)
                self.textFieldContainer.backgroundColor = UIColor.init(colorLiteralRed: 0.92, green: 0.92, blue: 0.92, alpha: 1)
                self.textField.backgroundColor = UIColor.black
                self.customViewContainer.addSubview(self.imageView)
                self.customViewContainer.addSubview(self.sendTimeAndLocation)
                self.customViewContainer.addSubview(self.textFieldContainer)
                self.customViewContainer.addSubview(self.cancleButton)
                self.customViewContainer.addSubview(self.sendButton)
//                self.textFieldContainer.addSubview(self.descripLabel)
                self.textFieldContainer.addSubview(self.textField)
                
                
                self.cancleButton.setTitle("取消", for: UIControlState.normal)
                self.sendButton.setTitle("发送", for: UIControlState.normal)
                self.sendButton.titleLabel?.textAlignment = NSTextAlignment.right
//                self.textField.placeholder = "请为您的照片做一些备注"
                var attriStr = NSMutableAttributedString.init(string: "此刻的心情 ")
                let attach = NSTextAttachment()
                attach.bounds = CGRect(x: 0, y: -2, width: self.textField.font?.lineHeight ?? 10, height: self.textField.font?.lineHeight ?? 10)
                attach.image = UIImage.init(named: "mediaNote")
                let attachStr = NSAttributedString.init(attachment: attach)
                attriStr.append(attachStr)
                self.textField.textColor = UIColor.white
                attriStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSRange.init(location: 0, length: attriStr.string.count - 1))
                self.textField.attributedPlaceholder = attriStr
                self.customViewContainer.frame = window.bounds
                self.imageView.frame = CGRect(x: margin, y: margin, width: SCREENWIDTH - margin * 2, height: SCREENWIDTH - margin * 2)
//                if(UIScreen.main.bounds.size.height == 480){//5,5s,5c不变
//                    self.textFieldContainer.frame = CGRect(x: margin, y: self.imageView.frame.maxY + margin / 5 , width: SCREENWIDTH - margin  * 2, height: margin * 1.3)
//
//                }else{//
//                    self.textFieldContainer.frame = CGRect(x: margin, y: self.imageView.frame.maxY + margin , width: SCREENWIDTH - margin  * 2, height: margin * 3)
//                }
//                self.configCollectionView()//取消滤镜
                let result = Calendar.current.dateComponents(in: TimeZone.current, from: Date())
                mylog(result.day)
                mylog(result.weekday)
                mylog(result.month)
                mylog(result.year)
                GDLocationManager.share.gotCity(location: GDLocationManager.share.locationManager.location ?? CLLocation.init(), result: { (error , placeMarks ) in
                    let placemark = placeMarks?.first
                    self.sendTimeAndLocation.text = "\(result.month ?? 00)月\(result.day ?? 00),\(result.year ?? 0000)   \(placemark?.locality ?? "" ) \(placemark?.administrativeArea ?? "") \(placemark?.country ?? "")"
                })
//                self.sendTimeAndLocation.text = "\(result.month ?? 00)月\(result.day ?? 00),\(result.year ?? 0000)"
                self.sendTimeAndLocation.textColor = UIColor.white
                if(UIScreen.main.bounds.size.height == 480){//5,5s,5c不变
                    self.sendTimeAndLocation.frame = CGRect(x: margin, y: self.imageView.frame.maxY + margin * 2  , width: SCREENWIDTH - margin  * 2, height: margin * 1.3)
                    
                    self.textFieldContainer.frame = CGRect(x: margin, y: self.sendTimeAndLocation.frame.maxY + margin / 5 , width: SCREENWIDTH - margin  * 2, height: margin * 1.3)
                    
                }else{//
                    self.sendTimeAndLocation.frame = CGRect(x: margin, y: self.imageView.frame.maxY + margin * 2 , width: SCREENWIDTH - margin  * 2, height: margin * 1.3)
                    
                    self.textFieldContainer.frame = CGRect(x: margin, y: self.sendTimeAndLocation.frame.maxY + margin , width: SCREENWIDTH - margin  * 2, height: margin * 3)
                }
                self.textFieldContainer.backgroundColor = UIColor.white
                self.cancleButton.frame = CGRect(x: 10, y: SCREENHEIGHT - margin * 1.5, width: margin * 2, height:  margin * 1.5)
                
                self.sendButton.frame = CGRect(x: SCREENWIDTH - 10 - 44, y: SCREENHEIGHT - (margin * 1.5), width:  margin * 2, height:  margin * 1.5)
                let textfiledMargin : CGFloat  = 0
                self.textField.frame = CGRect(x: textfiledMargin, y: 0, width: self.textFieldContainer.frame.size.width - textfiledMargin * 2, height: self.textFieldContainer.frame.size.height)
                
                self.cancleButton.addTarget(self , action: #selector(cancleClick), for: UIControlEvents.touchUpInside)
                
                
                self.sendButton.addTarget(self , action: #selector(sendClick), for: UIControlEvents.touchUpInside)
            }
        }else{
            self.customViewContainer.isHidden = false
//            self.imageView.frame = CGRect(x: 0, y: margin , width: SCREENWIDTH, height: SCREENWIDTH)
        }
        self.imageView.image = self.captureEditImage
        NotificationCenter.default.addObserver(self , selector: #selector(keyboardWillHide(info:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self , selector: #selector(keyboardWillShow(info:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        self.filtersView.reloadData()
    }

    /*
    func prepareForSetupDescripViews(image:UIImage)  {

        if self.customViewContainer.superview == nil  {

            if let window = UIApplication.shared.keyWindow {
                window.addSubview(self.customViewContainer)
                self.customViewContainer.backgroundColor = UIColor.black
                self.customViewContainer.addTarget(self , action: #selector(whiteSpaceClick), for: UIControlEvents.touchUpInside)
                self.textFieldContainer.backgroundColor = UIColor.init(colorLiteralRed: 0.92, green: 0.92, blue: 0.92, alpha: 1)
                self.textField.backgroundColor = UIColor.white
                self.customViewContainer.addSubview(self.imageView)
            self.customViewContainer.addSubview(self.textFieldContainer)
                self.textFieldContainer.addSubview(self.cancleButton)
                self.textFieldContainer.addSubview(self.sendButton)
                self.textFieldContainer.addSubview(self.descripLabel)
                self.textFieldContainer.addSubview(self.textField)
                self.cancleButton.setTitle("取消", for: UIControlState.normal)
                self.sendButton.setTitle("发送", for: UIControlState.normal)
                self.cancleButton.setTitleColor(UIColor.black, for: UIControlState.normal)
                self.sendButton.setTitleColor(UIColor.black, for: UIControlState.normal)
                self.sendButton.titleLabel?.textAlignment = NSTextAlignment.right
                self.descripLabel.textAlignment = NSTextAlignment.center
                self.descripLabel.text = "请为您的照片做一些备注"
                let margin : CGFloat = 20
                self.customViewContainer.frame = window.bounds
                self.imageView.frame = CGRect(x: margin, y: margin, width: SCREENWIDTH - margin * 2, height: SCREENWIDTH - margin * 2)
                self.textFieldContainer.frame = CGRect(x: 0, y: self.imageView.frame.maxY, width: SCREENWIDTH, height: SCREENHEIGHT  - (self.imageView.frame.maxY))
                self.cancleButton.frame = CGRect(x: 10, y: 10, width: 44, height: 44)
                self.sendButton.frame = CGRect(x: SCREENWIDTH - 10 - 44, y: 10, width: 44, height: 44)
                self.descripLabel.frame = CGRect(x: self.cancleButton.bounds.width + 10, y: 10, width: SCREENWIDTH - (self.cancleButton.bounds.width + 10) * 2 , height: 44)
                self.textField.frame = CGRect(x: 10, y: 44 + 10, width: SCREENWIDTH - 10 * 2 , height: self.textFieldContainer.bounds.size.height - 10 - 44 - 10)
                
                self.cancleButton.addTarget(self , action: #selector(cancleClick), for: UIControlEvents.touchUpInside)
                
                
                self.sendButton.addTarget(self , action: #selector(sendClick), for: UIControlEvents.touchUpInside)
            }
        }else{
            self.customViewContainer.isHidden = false
             self.imageView.frame = CGRect(x: 0, y: 64, width: SCREENWIDTH, height: SCREENWIDTH)
        }
        self.imageView.image = image
        NotificationCenter.default.addObserver(self , selector: #selector(keyboardWillHide(info:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self , selector: #selector(keyboardWillShow(info:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
     */

    func whiteSpaceClick() {
        self.textField.resignFirstResponder()
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool  {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(noti:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        mylog(UIApplication.shared.windows)
        return true
    }
    func keyboardWillHide(info:NSNotification)  {
        var realTime : TimeInterval = 0.25
        let timeInterval = info.userInfo?[UIKeyboardAnimationDurationUserInfoKey]
        if let timeAny  = timeInterval  {
            if let time  = timeAny as? TimeInterval {
                realTime = time
            }
        }
        let margin :CGFloat = 20
        UIView.animate(withDuration: realTime) {
           self.textFieldContainer.frame =  CGRect(x: margin, y: self.sendTimeAndLocation.frame.maxY + margin / 10 , width: SCREENWIDTH - margin  * 2, height: margin * 3)
        }
        
    }
    func keyboardWillShow(info:NSNotification)  {
        var realTime : TimeInterval = 0.25
        let timeInterval = info.userInfo?[UIKeyboardAnimationDurationUserInfoKey]
        let keyboardEndFrame = info.userInfo?[UIKeyboardFrameEndUserInfoKey] ; // as CGRect
        if let timeAny  = timeInterval  {
            if let time  = timeAny as? TimeInterval {
                realTime = time
            }
        }
        
        if let keyboardFrame = keyboardEndFrame {
            if let keyboardFrameRect = keyboardFrame as? CGRect {
                mylog(keyboardFrameRect)
                UIView.animate(withDuration: realTime) {
                    self.textFieldContainer.center = CGPoint(x: self.customViewContainer.bounds.size.width / 2, y: keyboardFrameRect.origin.y - self.textFieldContainer.bounds.size.height / 2)
                }
            }
            
        }
        
    }
    func cancleClick()  {
        self.performRrmoveNitification()
        self.textField.text = nil
        

    }
    func sendClick()  {
        self.performRrmoveNitification()
        DispatchQueue.global().async {
            var image = UIImage()
            if let img = self.captureEditImage{
                image = img
            }
//            if let img = self.addImageFilter(image: image){
//                image = img
//            }
            if let img = self.selectedItem?.imageview.image{
                image = img
            }

            let data =  UIImagePNGRepresentation(image)
            let dataBase64 = data?.base64EncodedString()
            let size = dataBase64?.characters.count
            self.upload(data: data ?? Data(), rectSize: image.size, type: "1")
//            GDNetworkManager.shareManager.uploadMedia(circleID: self.currentCircleID, original: dataBase64!, size: "\(size!)",descrip :self.textField.text, { (model) in
//                mylog("图片上传结果:\(model.status)")
//                mylog(model.data)
//                self.updateCurrentCircleID(model: model)
//                self.textField.text = nil
//
//                //                    mylog(model.data)
//            }) { (error ) in
//                mylog("图片上传结果:\(error)")
//            }
        }
        //执行上传 , base64在子线程
    }
    func performRrmoveNitification()  {
        NotificationCenter.default.removeObserver(self)
        self.textField.resignFirstResponder()
        self.customViewContainer.isHidden = true
    }

    
    
//    func addImageFilter(image : UIImage )  -> UIImage?{
//        //, filter : GPUImageOutput = GPUImageBeautifyFilter.init()
//        if let currentFilter  = self.selectedFilter {
//            let stillImageSource = GPUImagePicture.init(image: image)
//            stillImageSource?.addTarget(currentFilter as GPUImageInput)
//            currentFilter.useNextFrameForImageCapture()
//            stillImageSource?.processImage()
//            let currentFilteredImage = currentFilter.imageFromCurrentFramebuffer()
//            return  currentFilteredImage
//        }else{return image }
//    }
    
    
    
}
class GDFilterCellModel: NSObject {
    var filter  : GPUImageOutput?
    var title  : String?
    var image  : UIImage?
    
}
class GDFilterCell : UICollectionViewCell {
    let imageview  = UIImageView()
    let titlelabel = UILabel()
    var model  : GDFilterCellModel?{
        willSet{
            self.imageview.image = nil 
        }
        didSet{
            mylog(model?.image)
            mylog(model?.filter)
            self.titlelabel.text = model?.title
            if model?.image != nil && model?.filter != nil  {
                self.addImageFilter(image: (model?.image)!, filter: (model?.filter)!)
            }else if(model?.image != nil){
                imageview.image = model?.image!
            }
            self.layoutIfNeeded()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(imageview)
        self.contentView.addSubview(titlelabel)
        imageview.contentMode  = UIViewContentMode.scaleAspectFit
        titlelabel.textColor = UIColor.white
        titlelabel.textAlignment = NSTextAlignment.center
        titlelabel.font = GDFont.systemFont(ofSize: 14)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageview.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.width)
        self.titlelabel.frame = CGRect(x: 0, y: self.bounds.size.width, width: self.bounds.size.width, height: self.bounds.size.height - self.bounds.size.width)
    }
    func addImageFilter(image : UIImage , filter  : GPUImageOutput){
        //, filter : GPUImageOutput = GPUImageBeautifyFilter.init()

            /*
            let stillImageSource = GPUImagePicture.init(image: image)
            stillImageSource?.addTarget(filter as! GPUImageInput)
            filter.useNextFrameForImageCapture()
            stillImageSource?.processImage()
            let currentFilteredImage = filter.imageFromCurrentFramebuffer()
            return  currentFilteredImage
            */
            DispatchQueue.global().async {
                let stillImageSource = GPUImagePicture.init(image: image)
                stillImageSource?.addTarget(filter as! GPUImageInput)
                filter.useNextFrameForImageCapture()
                stillImageSource?.processImageUp(toFilter: filter, withCompletionHandler: { (img ) in
                    mylog(Thread.current)
                    DispatchQueue.main.async {
                        self.imageview.image = img
                    }
                })
            }
        }
    

    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
