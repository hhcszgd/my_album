//
//  GDProfileEditVC.swift
//  zjlao
//
//  Created by WY on 2017/9/24.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit
import SDWebImage
class GDProfileEditVC: GDBaseVC {
    
    
//    let imageView = UIImageView()
    
    
    var picker : UIImagePickerController?

    
    
    let icon = GDRowView()
    let name = GDRowView()
    let mobile = GDRowView()
    let gender = GDRowView()
    let area = GDRowView()
    let descrip = GDRowView()
    let setting = GDRowView()
    var userInfo =  [String : AnyObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        self.view.addSubview(icon)
        self.view.addSubview(mobile)
        self.view.addSubview(name)
        self.view.addSubview(gender)
        self.view.addSubview(area )
        self.view.addSubview(descrip)
        self.view.addSubview(setting)
        self.setupNaviBar()
        var startY : CGFloat = 80
        self.configRowInfo(rowView: icon , title: "头像", y: startY , h : 64 )
        
        startY += (icon.bounds.height + 15)
        self.setRowContent(rowView: icon, subTitle: Account.shareAccount.head_images)
        self.icon.subImageView.layer.cornerRadius = self.icon.subImageView.bounds.height/2
        self.icon.subImageView.layer.masksToBounds = true
        
        
        self.configRowInfo(rowView: mobile , title: "手机号码", y: startY  )
        startY += (mobile.bounds.height + 2)
        self.configRowInfo(rowView: name , title: "姓名", y: startY )
        startY += (name.bounds.height + 2)
//        self.configRowInfo(rowView: gender, title: "性别", y: startY)
//        startY += (gender.bounds.height + 2)
//        self.configRowInfo(rowView: area, title: "地区", y: startY)
        startY += (area.bounds.height + 2)
//        self.configRowInfo(rowView: descrip, title: "个性签名", y: startY)
//        startY += (descrip.bounds.height + 12)
//        self.configRowInfo(rowView: setting, title: "其他设置", y: startY)
        self.requestNetwork()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestNetwork()
    }
    func setupNaviBar()  {
//        self.naviBar.backBtn.setImage(UIImage(named: "icon_classify_homepage"), for: UIControlState.normal)
        let  attritit = NSMutableAttributedString.init(string: "个人信息")
        attritit.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: NSRange.init(location: 0, length: attritit.string.characters.count))
        self.title = attritit.string
//        self.naviBar.backgroundColor = UIColor.black
    }
    func configRowInfo(rowView : GDRowView,title:String,y:CGFloat,h:CGFloat = 44)  {
        rowView.titleLabel.text = title
        rowView.frame = CGRect(x: 0, y: y , width: self.view.bounds.width , height: h)
        rowView.addTarget(self , action: #selector(rowAction(sender:)), for: UIControlEvents.touchUpInside)
    }
    func setRowContent(rowView : GDRowView ,subTitle: String?) {
        if (subTitle ?? "").hasPrefix("http") {
            if let url = URL(string : subTitle ?? ""){
//                rowView.subImageView.sd_setImage(with: url)
                rowView.subImageView.sd_setImage(with: url , placeholderImage: UIImage(named:"bg_nohead"), options: [SDWebImageOptions.retryFailed])
            }
        }else{
            rowView.subTitleLabel.text = subTitle
        }
        rowView.layoutIfNeeded()
    }
    @objc func rowAction(sender : GDRowView) {
        if let title = sender.titleLabel.text{
            let model = GDBaseModel.init(dict: nil )
            switch title {
            case "头像":
                mylog(title)
//                model.actionkey = "GDIconEditVC"
//                model.keyparamete = self.userInfo["avatar"]
//
                self.choseMediaType()
                return
            case "手机号码":
                mylog(title)
                
                
            case "姓名":
                mylog(title)
                let vc  = GDEditNameVC.init(title: "修改姓名", originalValue: (self.userInfo["name"] as? String ) ?? "")
                self.navigationController?.pushViewController(vc , animated: true )
                return
                
            case "性别":
                mylog(title)
                let vc  = GDEditNameVC.init(title: "修改性别", originalValue:"\( (self.userInfo["sex"] as? Int ) ?? 0 )")
                self.navigationController?.pushViewController(vc , animated: true )
                return 
                
            case "地区":
                mylog(title)
                
                
            case "个性签名":
                mylog(title)
                
                
            case "其他设置":
                mylog(title)
                
                
            default :
                break
            }
            GDSkipManager.skip(viewController: self , model: model )
        }
    }

    func requestNetwork() {
        GDNetworkManager.shareManager.getUserInfomation(userID: Account.shareAccount.member_id ?? "", success: { (model ) in
            if let userInfo = model.data as? [String : AnyObject]{
                self.userInfo = userInfo
                mylog(userInfo)
                /*
                 desctiption = ;
                 city = ;
                 province = ;
 */
                self.setRowContent(rowView: self.icon, subTitle: userInfo["avatar"] as? String)
                if let name = userInfo["name"] as? String {
                    if name.isEmpty{
                            self.setRowContent(rowView: self.name, subTitle: "未设置")
                    }else{
                         self.setRowContent(rowView: self.name, subTitle: name )
                    }
                }else{
                     self.setRowContent(rowView: self.name, subTitle: "未设置")
                }
//                self.setRowContent(rowView: self.name, subTitle: userInfo["name"] as? String)
                self.setRowContent(rowView: self.mobile, subTitle: userInfo["mobile"] as? String)
                if let gender = userInfo["sex"] as? NSNumber{
                    self.setRowContent(rowView: self.gender, subTitle: gender == 0 ? "男" : "女")
                }
                self.setRowContent(rowView: self.area, subTitle: userInfo["city"] as? String)
                self.setRowContent(rowView: self.descrip, subTitle: userInfo["desctiption"] as? String)
            }
        }) { (error ) in
            mylog("获取用户信息失败\(error)")
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}












import MobileCoreServices
extension GDProfileEditVC : UIImagePickerControllerDelegate , UINavigationControllerDelegate  {
    
    func choseMediaType() {
        let alertVC  = UIAlertController.init(title: nil , message: nil , preferredStyle: UIAlertControllerStyle.actionSheet)
        let alertAction1 = UIAlertAction.init(title: "拍摄", style: UIAlertActionStyle.default) { (action ) in
            
            self.setupCarame(type: 1)
            alertVC.dismiss(animated: true , completion: {
                //调用相机
            })
        }
        let alertAction2 = UIAlertAction.init(title: "相册", style: UIAlertActionStyle.default) { (action ) in
            
            self.setupCarame(type: 2)
            alertVC.dismiss(animated: true , completion: {
                //调用本地相册库
            })
        }
        let alertAction21 = UIAlertAction.init(title: "保存图片", style: UIAlertActionStyle.default) { (action ) in
            if let image = self.icon.subImageView.image{
                
                UIImageWriteToSavedPhotosAlbum(image , nil  ,nil , nil )
            }
            //todo  perform save image to library
            mylog(alertVC)
            
            alertVC.dismiss(animated: true , completion: {
                mylog(Thread.current)
            })
            GDAlertView.alert("保存成功", image: nil, time: 2, complateBlock: nil )
        }
        
//        let alertAction22 = UIAlertAction.init(title: "查看历史图片", style: UIAlertActionStyle.default) { (action ) in
////            if let image = self.icon.subImageView.image{
////
////                UIImageWriteToSavedPhotosAlbum(image , nil  ,nil , nil )
////            }
////            //todo  perform save image to library
////            mylog(alertVC)
//
//            alertVC.dismiss(animated: true , completion: {
//                mylog(Thread.current)
//            })
//            GDAlertView.alert("保存成功", image: nil, time: 2, complateBlock: nil )
//        }
        
        let alertAction3 = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel) { (action ) in
            alertVC.dismiss(animated: true , completion: {})
        }
        alertVC.addAction(alertAction1)
        alertVC.addAction(alertAction2)
//        alertVC.addAction(alertAction22)
        alertVC.addAction(alertAction3)
        self.present(alertVC, animated: true) {}
    }
    //    - (void)image:(UIImage *)image
    //    didFinishSavingWithError:(NSError *)error
    //    contextInfo:(void *)contextInfo;
    @objc func saveImageToAlbumSuccess()  {
        GDAlertView.alert("保存成功", image: nil, time: 2, complateBlock: nil )
    }
    func setupCarame (type : Int /**1 拍摄 , 2本地相册*/)  {//调用系统相机
        //return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
        //        if (!UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.rear ) || !UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.front )){
        //            GDAlertView.alert("摄像头不可用", image: nil , time: 2, complateBlock: nil)//摄像头专属
        //        }
        let picker = UIImagePickerController.init()
        self.picker = picker
        picker.delegate = self
        //        if (UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.rear ) || UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.front )){
        //            //            GDAlertView.alert("摄像头不可用", image: nil , time: 2, complateBlock: nil)//摄像头专属
        //
        //            picker.sourceType = UIImagePickerControllerSourceType.camera//这一句一定在下一句之前
        //        }else{
        //            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        //        }
        if (type == 1){
            //            GDAlertView.alert("摄像头不可用", image: nil , time: 2, complateBlock: nil)//摄像头专属
            if !(UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.rear ) && UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.front )){
                GDAlertView.alert("摄像头不可用", image: nil , time: 2, complateBlock: nil)//摄像头专属
                return
            }else{
                picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            }
            picker.sourceType = UIImagePickerControllerSourceType.camera//这一句一定在下一句之前
        }else{
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        picker.mediaTypes = [/*kUTTypeMovie as String , kUTTypeVideo as String ,*/ kUTTypeImage as String  , kUTTypeJPEG as String , kUTTypePNG as String]//kUTTypeMPEG4
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
                DispatchQueue.global().async {
                    
                    self.upload(data: data , type: "2")
                    //perform upload movie
                    //                    GDNetworkManager.shareManager.uploadMedia(circleID: self.currentCircleID, original: dataBase64, size: "\(size)",descrip :self.textField.text,formate : "MOV", { (model) in
                    //                        mylog("图片上传结果:\(model.status)")
                    //                        mylog(model.data)
                    //                        self.textField.text = nil
                    //
                    //                        //                    mylog(model.data)
                    //                    }) { (error ) in
                    //                        mylog("图片上传结果:\(error)")
                    //                    }
                }
                
                
                
            }catch{
                mylog(error)
            }
            
        }
    }
    
    
    
    func dealImage(info:[String : Any])  {
        
        var theImage : UIImage?
            if let editImageReal  = info[UIImagePickerControllerEditedImage] as? UIImage {
                    theImage = editImageReal
                    self.icon.subImageView.image = editImageReal
            }else{
                if let originlImage  = info[UIImagePickerControllerOriginalImage] as? UIImage {
                    theImage = originlImage
                    self.icon.subImageView.image = originlImage
                }
            }
        //perform upload image
        if theImage != nil  {
            let imageDate = UIImagePNGRepresentation(theImage!)
            if imageDate != nil {
                self.upload(data: imageDate!, rectSize : theImage!.size, type: "1")
                
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
                            GDNetworkManager.shareManager.editUserInfomation(avarta: key/*, format: "jpeg"*/, success: { (model ) in
                                if model.status == 200 {
                                    //修改成功
                                    NotificationCenter.default.post(name: NSNotification.Name.init("EditProfileSuccess"), object: Account.shareAccount)
                                    self.icon.subImageView.image = UIImage.init(data: data)
                                }
                            }, failure: { (error ) in
                                
                            })
                            //                            GDNetworkManager.shareManager.insertMediaToCircle(circleID: self.circleID, original: key , type: type , description: nil , media_spec:  rectSize, success: { (model ) in
                            //                                mylog("插入媒体到圈子 请求结果 : \(model.status) , 数据 :\(model.data)")
                            //                                self.getCircles()
                            //                            }, failure: { (error ) in
                            //                                mylog("插入媒体到圈子 请求结果 : \(error)")
                            //                            })
                        }else{
                            mylog("修改头像失败 : \(responseInfo)")
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
}
