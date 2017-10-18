//
//  GDSetUserinfoVC.swift
//  zjlao
//
//  Created by WY on 25/04/2017.
//  Copyright © 2017 com.16lao.zjlao. All rights reserved.
//

import UIKit
import SDWebImage
enum GDImageSourceType {
    case album
    case camera
}
class GDSetUserinfoVC: GDUnNormalVC {

    let blackView = UIView(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH, height: 188))
    let avatarImageView = UIButton()
    let nameLabel = UILabel()
    let nameTextField = UITextField()
    let mobileLabel = UILabel()
    let mobileTextField = UITextField()
    let save = UIButton()
    let bigTipsLabel = UILabel()
    let smallTipsLabel = UILabel()
    
    let provisionButton = UIButton()
    var  editProfileIcon = UIImageView(image: UIImage(named: "camera_icon_white"))

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(colorLiteralRed: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        self.setupSubviews()
        self.getUserInfo()

        // Do any additional setup after loading the view.
    }

    func setupSubviews()  {
        self.view.addSubview(blackView)
        self.view.addSubview(avatarImageView)
        self.view.addSubview(editProfileIcon )
        self.view.addSubview(nameLabel)
        self.view.addSubview(nameTextField)
        self.view.addSubview(mobileLabel)
        self.view.addSubview(mobileTextField)
        self.view.addSubview(bigTipsLabel)
        self.view.addSubview(smallTipsLabel)
        self.view.addSubview(save)
        self.setupProvisionButton()
        avatarImageView.addTarget(self , action: #selector(iconClick), for: UIControlEvents.touchUpInside)
        
        save.setTitle("保存", for: UIControlState.normal)
        save.addTarget(self , action: #selector(saveClick), for: UIControlEvents.touchUpInside)
        save.backgroundColor = UIColor.white
        save.setTitleColor(UIColor.gray, for: UIControlState.normal)
        blackView.backgroundColor = UIColor.black
        nameLabel.text = "姓名:"
        mobileLabel.text = "手机:"
        self.mobileTextField.isEnabled = false
        let margin : CGFloat = 10
        let avatarW : CGFloat = 100
        let avatarH = avatarW
        let avatarX = (SCREENWIDTH - avatarW ) * 0.5
        let avatarY : CGFloat = 70
        avatarImageView.frame = CGRect(x: avatarX, y: avatarY, width: avatarW, height: avatarH)
        avatarImageView.layer.cornerRadius = avatarW * 0.5
        avatarImageView.layer.masksToBounds = true
        editProfileIcon.contentMode = UIViewContentMode.scaleAspectFit
        let editProfileIconW : CGFloat = 20.0
        let editProfileIconH : CGFloat = 15.0
        editProfileIcon.frame = CGRect(x: avatarImageView.frame.maxX - editProfileIconW, y: avatarImageView.frame.maxY - editProfileIconH, width: editProfileIconW, height: editProfileIconH)
        let nameLabelX : CGFloat = 0
        let nameLabelY = blackView.frame.maxY + margin
        let nameLabelW : CGFloat = 64
        let nameLabelH : CGFloat = 44
        nameLabel.textAlignment = NSTextAlignment.center
        mobileLabel.textAlignment = NSTextAlignment.center
        nameLabel.frame = CGRect(x: nameLabelX, y: nameLabelY, width: nameLabelW, height: nameLabelH)
        nameLabel.backgroundColor = UIColor.white
        mobileLabel.frame = CGRect(x: nameLabelX, y: nameLabel.frame.maxY + margin , width: nameLabelW, height: nameLabelH)
        
        nameTextField.frame = CGRect(x: nameLabel.frame.maxX , y: nameLabelY, width: SCREENWIDTH - nameLabelW , height: nameLabelH)
        nameTextField.backgroundColor = UIColor.white
        mobileLabel.backgroundColor = UIColor.white
        mobileTextField.backgroundColor  = UIColor.white
        mobileTextField.frame = CGRect(x: nameLabel.frame.maxX , y: mobileLabel.frame.minY, width: SCREENWIDTH - nameLabelW , height: nameLabelH)
        
        bigTipsLabel.text = "账号复原"
        bigTipsLabel.font = GDFont.systemFont(ofSize: 20)
        bigTipsLabel.frame = CGRect(x: 15, y: mobileLabel.frame.maxY + margin * 2, width: SCREENWIDTH - 15 * 2, height: bigTipsLabel.font.lineHeight)
        
        smallTipsLabel.font = GDFont.systemFont(ofSize: 15)
        smallTipsLabel.text = "如果你遗失了你的手机,你可以通过你的手机号码找回,继续在新手机上使用"
        smallTipsLabel.frame = CGRect(x: 15, y: bigTipsLabel.frame.maxY , width: SCREENWIDTH - 15 * 2, height: smallTipsLabel.font.lineHeight * 3)
        smallTipsLabel.numberOfLines = 3
        bigTipsLabel.textColor = MainTitleColor
        smallTipsLabel.textColor = SubTitleColor
        
        let screenWidth =  UIScreen.main.bounds.size.height
        mylog(UIScreen.main.bounds)
        if(screenWidth == 480){//5,5s,5c不变
            save.frame = CGRect(x: SCREENWIDTH - 88, y: 20, width: 88, height: 44)
            save.backgroundColor = UIColor.clear
        }else{//
           save.frame = CGRect(x: (SCREENWIDTH - 200) * 0.5, y: smallTipsLabel.frame.maxY + margin * 3, width: 200, height: 44)
        }
        
        
        
    }
    func setupProvisionButton()  {
        self.view.addSubview(provisionButton)
        provisionButton.setTitle("用户使用协议", for: UIControlState.normal)
        provisionButton.setTitleColor(UIColor.blue, for: UIControlState.normal)
        //        provisionButton.backgroundColor = UIColor.green
//        provisionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        provisionButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        provisionButton.addTarget(self , action: #selector(provisionDetail), for: UIControlEvents.touchUpInside)
        self.provisionButton.bounds = CGRect(x: 0, y: 0, width: 100, height: 40)
        self.provisionButton.center = CGPoint(x: self.view.bounds.size.width / 2 , y: self.view.bounds.size.height - 80 )
        
    }
    func provisionDetail(){
        let model = GDBaseModel.init(dict: nil )
        model.actionkey = "webpage"
        model.keyparamete = "http://www.123qz.cn/yinsi.html" as AnyObject//
        GDSkipManager.skip(viewController: self , model: model)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUserInfo()  {
        mylog("打印用户ididididid\(Account.shareAccount.member_id)")
        GDNetworkManager.shareManager.getUserinfo(userid: Account.shareAccount.member_id ?? "", { (result ) in
            mylog("获取个人信息:\(result.status)")
            mylog("获取个人信息:\(result.data)")
            if let dict = result.data as? [String : AnyObject]{
                if let name = dict["name"] as? String{
                    self.nameTextField.text = name
                }
                if let avatar = dict["avatar"] as? String{
                 self.avatarImageView.sd_setImage(with: URL(string: avatar), for: UIControlState.normal, placeholderImage: placePolderImage, options:  [SDWebImageOptions.cacheMemoryOnly , SDWebImageOptions.retryFailed])
                }
                if let mobile = dict["mobile"] as? String{
                    self.mobileTextField.text = mobile
                }
                if let mobile = dict["mobile"] as? NSNumber{
                    self.mobileTextField.text = "\(mobile)"
                }
            }
        }) { (error ) in
            mylog("获取个人信息错误\(error)")
        }
    }
    
    
    
    func performChange()  {
        GDNetworkManager.shareManager.changeUserinfo(name: nil , avatar: nil , { (result ) in
            
        }) { (error ) in
            
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func iconClick()  {
        mylog("头像点击")
        self.chooseImageSourceType()
    }
    
    func chooseImageSourceType() {
        let alertVC : UIAlertController = UIAlertController.init()
        let cameraAction : UIAlertAction = UIAlertAction.init(title: "相机", style: UIAlertActionStyle.default) { (action) in
            self.setupCarame(type : GDImageSourceType.camera)
        }
        let albumAction : UIAlertAction = UIAlertAction.init(title: "相册", style: UIAlertActionStyle.default) { (action) in
            self.setupCarame(type : GDImageSourceType.album)
        }
        
        let cancleAction : UIAlertAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel) { (action) in
            
        }
        alertVC.addAction(cameraAction)
        alertVC.addAction(albumAction)
        alertVC.addAction(cancleAction)
        self.present(alertVC, animated: true) { 
            
        }
    }
    
    func saveClick() {
        mylog("保存点击")
          GDNetworkManager.shareManager.changeUserinfo(name: self.nameTextField.text, { (result ) in
            mylog("修改用户名成功\(result.status)")
            self.popToPreviousVC()
          }) { (error ) in
            mylog("修改用户名失败\(error)")
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIApplication.shared.isStatusBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isStatusBarHidden = false
    }

}



import MobileCoreServices

extension GDSetUserinfoVC : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    /*
     func setupCarame ()  {
     //return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
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
     //        UIApplication.shared.keyWindow!.rootViewController!.present(FilterDisplayViewController(), animated: true, completion: nil)//自定义照相机 , todo
     }
     
     
     */
    
    func setupCarame(type : GDImageSourceType)  {
        //return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
        //        if (!UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.rear ) || !UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.front )){
        //            GDAlertView.alert("摄像头不可用", image: nil , time: 2, complateBlock: nil)//摄像头专属
        //        }
        let picker = UIImagePickerController.init()
        picker.delegate = self
        if (UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.rear ) || UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.front )){
            //            GDAlertView.alert("摄像头不可用", image: nil , time: 2, complateBlock: nil)//摄像头专属
            switch type  {
            case .album:
                 picker.sourceType = UIImagePickerControllerSourceType.photoLibrary//这一句一定在下一句之前
            case .camera:
                 picker.sourceType = UIImagePickerControllerSourceType.camera//这一句一定在下一句之前
            }
//            picker.sourceType = UIImagePickerControllerSourceType.camera//这一句一定在下一句之前
        }else{
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        //        picker.mediaTypes = [kUTTypeMovie as String , kUTTypeVideo as String , kUTTypeImage as String  , kUTTypeJPEG as String , kUTTypePNG as String]//kUTTypeMPEG4
        picker.allowsEditing = true ;
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
        
        let editImage = info[UIImagePickerControllerEditedImage]
        
        if let editImageReal  = editImage as? UIImage {
            self.avatarImageView.setImage(editImageReal, for: UIControlState.normal)
            DispatchQueue.global().async {
                let data =   UIImageJPEGRepresentation(editImageReal, 1) //  UIImagePNGRepresentation(editImageReal)
                let dataBase64 = data?.base64EncodedString()
                let size = dataBase64?.characters.count
                
                
                
                self.updateAvatar(data: data ?? Data(), rectSize: editImageReal.size , type: "1", format: "jpeg")
                
                

                
            }

//            self.setupDescripForImage(image: editImageReal)

        }

        
        picker.dismiss(animated: true) {      }
    }
    
    
    
    
    
    func updateAvatar(data : Data ,rectSize : CGSize = CGSize(width: 100, height: 100) ,  type : String /**1:image  , 2 movie*/ ,format : String = "jpeg")  {
        // MARK: 注释 : 插入七牛存储👇
        GDNetworkManager.shareManager.getQiniuToken(success: { (model ) in
            
            if let token = model.data as? String {
                mylog("获取七牛touken请求的状态码\(model.status)  , data数据 : \(token)")
                GDNetworkManager.shareManager.uploadMediaToQiniu(data: data ,token : token , complite: { (responseInfo, theKey , successInfo) in
                    mylog("上传到七牛的请求结果 responseInfo: \(responseInfo) , theKey : \(theKey) , successInfo \(successInfo) ")
                    if successInfo == nil {
                        GDAlertView.alert("操作失败,请重试", image: nil, time: 2, complateBlock: nil)
                    }else{
                        if let key = successInfo?["key"] as? String{

                            GDNetworkManager.shareManager.changeUserinfo(   avatar: key, { (model) in
                                mylog("头像上传结果:\(model.status)")
//                                self.avatarImageView.sd_setImage(with: URL(string: Account.shareAccount.head_images ?? ""), for: UIControlState.normal, placeholderImage: placePolderImage, options:  [SDWebImageOptions.cacheMemoryOnly , SDWebImageOptions.retryFailed])
                                self.avatarImageView.setImage(UIImage(data: data ), for: UIControlState.normal)
                                //                    mylog(model.data)
                            }) { (error ) in
                                mylog("头像上传结果:\(error)")
                            }
                            
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
            mylog("获取七牛token失败\(error)" )
        })
        
    }
    
    
    
    //    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
    //
    //
    //    }
    
    /*
    func setupDescripForImage(image:UIImage)  {
        self.prepareForSetupDescripViews(image:image)
     
    }
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
                
                self.customViewContainer.frame = window.bounds
                self.imageView.frame = CGRect(x: 0, y: 64, width: SCREENWIDTH, height: SCREENWIDTH)
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
        UIView.animate(withDuration: realTime) {
            self.textFieldContainer.frame = CGRect(x: 0, y: self.imageView.frame.maxY, width: SCREENWIDTH, height: SCREENHEIGHT  - (self.imageView.frame.maxY))
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
            let data =  UIImagePNGRepresentation(self.captureEditImage ?? UIImage())
            let dataBase64 = data?.base64EncodedString()
            let size = dataBase64?.characters.count
            GDNetworkManager.shareManager.uploadMedia(circleID: self.currentCircleID, original: dataBase64!, size: "\(size!)",descrip :self.textField.text, { (model) in
                mylog("图片上传结果:\(model.status)")
                self.textField.text = nil
                
                //                    mylog(model.data)
            }) { (error ) in
                mylog("图片上传结果:\(error)")
            }
        }
        //执行上传 , base64在子线程
    }
    func performRrmoveNitification()  {
        NotificationCenter.default.removeObserver(self)
        self.textField.resignFirstResponder()
        self.customViewContainer.isHidden = true
    }
    */
    
}
