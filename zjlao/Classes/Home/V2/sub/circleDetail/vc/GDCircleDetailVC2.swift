//
//  GDCircleDetailVC2.swift
//  zjlao
//
//  Created by WY on 2017/9/14.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//
/**
 
 {
 media = (
 );
 datetime = 2017-09-13;
 media_count = 20;
 permission = 1;
 members = (
 你猜,
 李福海,
 );
 address = 北京市;
 }
 */
import UIKit
import MJRefresh
class GDCircleDetailVC2: GDNormalVC {
    let qieziButton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
    var circleID  = "0"
    var picker : UIImagePickerController?
    var models : [GDCircleDetailItemModel]?
    var page  : Int = 1
    var pwd : String?
    var circleInfoModel : GDCircleSessionHeaderModel?

    var circleName : String = "" {
        didSet{
            let attritit = NSMutableAttributedString.init(string: circleName)
            attritit.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: NSRange.init(location: 0, length: attritit.string.characters.count))
        self.naviBar.attributeTitle = attritit
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        self.setupNaviBar()
        mylog(keyModel?.keyparamete)
        if let para  = keyModel?.keyparamete as? [String:String] {
            circleName = para["title"] ?? "nil"
            self.circleID = para["id"]!
            self.pwd = para["password"]
        }
        // Do any additional setup after loading the view.
        self.prepareSubViews()
        self.setupQZButton()
        self.getCircles()
        self.collectionView.mj_footer = GDRefreshGifFooter(refreshingTarget: self , refreshingAction: #selector(loadMore))
        self.collectionView.mj_header = GDRefreshHeader(refreshingTarget: self, refreshingAction: #selector(refreshOrInit))
        // Do any additional setup after loading the view.
    }
    @objc override func loadMore() {
        getCircles(loadType: LoadDataType.loadMore)
    }
    @objc func refreshOrInit() {
        getCircles(loadType: LoadDataType.initialize)
    }
    func setupQZButton() {
        self.view.addSubview(qieziButton)
        qieziButton.setImage(UIImage(named:"logo"), for: UIControlState.normal)
        qieziButton.center = CGPoint(x: self.view.bounds.size.width / 2 , y: self.view.bounds.size.height - (qieziButton.bounds.size.height) / 2 )
        qieziButton.addTarget(self , action: #selector(createMedia), for: UIControlEvents.touchUpInside)
    }
    func setupNaviBar() {
        self.naviBar.backgroundColor = UIColor.black

        self.naviBar.backBtn.setImage(UIImage(named: "icon_classify_homepage"), for: UIControlState.normal)
    }
    @objc func createMedia()  {
        mylog("I'm going to create media")
        self.choseMediaType()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func prepareSubViews()  {
        
        ///:circleView
        //        guard let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
        //            return
        //        }
        collectionView.register(GDCircleDetailItem.self , forCellWithReuseIdentifier: "GDCircleDetailItem")
        collectionView.register(GDCircleSessionHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "GDCircleSessionHeader")
        let layout =  GDFlowLayout.init()
        collectionView.collectionViewLayout = layout
        layout.delegate = self
        let cellMargin : CGFloat = 11
        let circleNameH : CGFloat = 25
        //        flowLayout.minimumLineSpacing = cellMargin
        //        flowLayout.minimumInteritemSpacing = cellMargin
        let collectionW = self.view.bounds.size.width
        let itemW = (collectionW - cellMargin * 4 ) / 3
        let collectionH = UIScreen.main.bounds.size.height - 20
        //        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        collectionView.frame =  CGRect(x : 0 , y : 20 , width : collectionW  , height : collectionH)
        collectionView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
        self.collectionView.backgroundColor = UIColor.init(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
        ///:createCircle
        
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
//        UICollectionViewDelegate
        
        if kind == UICollectionElementKindSectionHeader {
            let header =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "GDCircleSessionHeader", for: indexPath)
//            let header = GDCircleSessionHeader.init(frame: CGRect(x: 0, y: 0, width: 200, height: 64))
//            header.backgroundColor = UIColor.red
            if let realHeader = header as? GDCircleSessionHeader, self.circleInfoModel != nil {
                realHeader.model = self.circleInfoModel
            }
            return header
        }
        return GDCircleSessionHeader.init(frame: CGRect(x: 0, y: 0, width: 200, height: 64))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        return CGSize(width: collectionView.bounds.width, height: 64)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        mylog(models?.count ?? 0)
        return  models?.count ?? 0
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "GDCircleDetailItem", for: indexPath)
        let itemIndex  = indexPath.item % models!.count
        if let realItem  = item as? GDCircleDetailItem {
            realItem.model = models![itemIndex]
        }
        return item
    }
}

extension GDCircleDetailVC2 : GDFlowLayoutProtocol{
    func provideSessionHeaderHeight(layout: GDFlowLayout?) -> CGFloat {
        return 64
    }
    func provideColumnCount(layout: GDFlowLayout?) -> Int {return 2}
    func provideRowMargin(layout: GDFlowLayout?) -> CGFloat {return 0}
    func provideColumnMargin(layout: GDFlowLayout?) -> CGFloat {return 10}
    func provideEdgeInsets(layout: GDFlowLayout?) -> UIEdgeInsets {return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)}
    func provideItemWidth(layout: GDFlowLayout?) -> CGFloat {
        if self.models != nil  {
            let insetWidth = self.provideEdgeInsets(layout: nil).left * 2
            let columnCount = self.provideColumnCount(layout: nil)
            let marginsWidth = self.provideColumnMargin(layout: nil) * (CGFloat(columnCount - 1))
            let imageShowWidth = (self.collectionView.bounds.size.width - insetWidth - marginsWidth ) / CGFloat(columnCount)
            return imageShowWidth
        }
        return 0
    }
    func provideItemHeight(layout: GDFlowLayout?, indexPath: IndexPath) -> CGFloat {
        if self.models != nil  {
            let model = self.models![indexPath.item]
            let imageMargin : CGFloat = 0
            let tempWidth = Float.init(model.media_width ?? "0")
            let imageWidth = CGFloat.init(tempWidth ?? 0.0)
            let tempHeight = Float.init(model.media_height ?? "0")
            if tempWidth == 0 || tempHeight == 0 {
                return 0
            }
            let imageHeight = CGFloat.init(tempHeight ?? 0.0)
            let insetWidth = self.provideEdgeInsets(layout: nil).left * 2
            let columnCount = self.provideColumnCount(layout: nil)
            let marginsWidth = self.provideRowMargin(layout: nil) * CGFloat(columnCount)
            let imageShowWidth = (self.collectionView.bounds.size.width - insetWidth - marginsWidth ) / CGFloat(columnCount)
            
            let imageShowHeidht =  imageShowWidth / imageWidth * imageHeight //* (self.bounds.size.height - bottomH - 2 * imageMargin)
//            imageView.frame = CGRect(x: imageMargin, y: imageMargin, width: imageShowWidth, height: imageShowHeidht )
            let bottomH  : CGFloat =  44
            return bottomH + imageShowHeidht
        }
        
        return 0
    }
}

extension GDCircleDetailVC2 {
//    func prepareSubViews()  {
//
//        ///:circleView
////        guard let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
////            return
////        }
//        let layout =  GDFlowLayout.init()
//        collectionView.collectionViewLayout = layout
//        layout.delegate = self
//        let cellMargin : CGFloat = 11
//        let circleNameH : CGFloat = 25
////        flowLayout.minimumLineSpacing = cellMargin
////        flowLayout.minimumInteritemSpacing = cellMargin
//        let collectionW = self.view.bounds.size.width
//        let itemW = (collectionW - cellMargin * 4 ) / 3
//        let collectionH = UIScreen.main.bounds.size.height
//        //        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
//        collectionView.frame =  CGRect(x : 0 , y : 20 , width : collectionW  , height : collectionH)
//        collectionView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
//        self.collectionView.backgroundColor = UIColor.init(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
//        collectionView.register(GDCircleDetailItem.self , forCellWithReuseIdentifier: "GDCircleDetailItem")
//        ///:createCircle
//
//    }
//
//
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
//        return  models?.count ?? 0
//    }
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
//        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "GDCircleDetailItem", for: indexPath)
//        let itemIndex  = indexPath.item % models!.count
//        if let realItem  = item as? GDCircleDetailItem {
//            realItem.model = models![itemIndex]
//        }
//        return item
//    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = models![indexPath.item % models!.count]
//        getMediaDetail
        model.actionkey = "GDMideaDetailVC"
        let keyParamete : [String : String ] = ["circleID":self.circleID , "mediaID":model.id ?? ""]
        model.keyparamete = keyParamete as AnyObject
        GDSkipManager.skip(viewController: self , model: model)
        
        
    }
    
    
    func getCircles(loadType : LoadDataType = .initialize) {

        switch loadType {
        case LoadDataType.initialize , LoadDataType.reload:
            self.page  = 1
            break
        case LoadDataType.loadMore:
            self.page  = self.page + 1
            break
        }
        
        GDNetworkManager.shareManager.getCircleDetail(circleID: circleID, page: "\(page)" , password: pwd, success: { (model ) in
            mylog("获取圈子详情 : \(model.data)")
            if let outSideDict = model.data as? [String : AnyObject]{
                let tempCircleModel = GDCircleSessionHeaderModel.init(dict: nil  )
                if let datetime = outSideDict["datetime"] as? String{
                    tempCircleModel.datetime = datetime
                }
                
                if let media_count = outSideDict["media_count"] as? NSNumber{
                    tempCircleModel.media_count  = media_count
                }
                if let permission = outSideDict["permission"] as? NSNumber{
                    tempCircleModel.permission = permission
                }
                if let address = outSideDict["address"] as? String{
                    tempCircleModel.address = address
                }
                mylog(outSideDict["members"])
                if let members = outSideDict["members"] as? [String]{
                    tempCircleModel.members = members
                }
                self.circleInfoModel = tempCircleModel
                var tempModels = [GDCircleDetailItemModel]()
                if let arr = outSideDict["media"] as? [[String : AnyObject]]{
                    for (_ , dict ) in arr.enumerated(){
//                        mylog(dict)
                        let tempModel = GDCircleDetailItemModel.init(dict: dict )
//                        dump(tempModel)
                        tempModels.append(tempModel)
                    }

                }
                
                
                
                if(tempModels.count == 0 ){
                    self.collectionView.mj_header.endRefreshing()
                    self.collectionView.mj_footer.state = MJRefreshState.noMoreData
                    return
                }
                switch loadType {
                case LoadDataType.initialize , LoadDataType.reload:
                    self.models = tempModels
                    break
                case LoadDataType.loadMore:
                    self.models?.append(contentsOf: tempModels)
                    break
                }
                
                self.collectionView.reloadData()
                self.collectionView.mj_header.endRefreshing()
                self.collectionView.mj_footer.state = MJRefreshState.idle
                
                
                
                
                
                
                
                
                /**
                 ["circle_image": , "id": 1125, "circle_type": 2, "circle_name": 圈子11112222, "circle_member_count": 1, "circle_member_number": 80, "permission": 0]
                 */
            }else{
                mylog("获取圈子详情 类型转换失败")
            }
        }) { (error ) in
            mylog("获取圈子详情失败: \(error)")
        }
       
        
        
    }
    
}

import MobileCoreServices
extension GDCircleDetailVC2 : UIImagePickerControllerDelegate , UINavigationControllerDelegate  {
    
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
        let alertAction3 = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel) { (action ) in
            alertVC.dismiss(animated: true , completion: {})
        }
        alertVC.addAction(alertAction1)
        alertVC.addAction(alertAction2)
        alertVC.addAction(alertAction3)
        self.present(alertVC, animated: true) {}
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
        picker.mediaTypes = [kUTTypeMovie as String , kUTTypeVideo as String , kUTTypeImage as String  , kUTTypeJPEG as String , kUTTypePNG as String]//kUTTypeMPEG4
//        picker.allowsEditing = true ;
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
            DispatchQueue.main.async {
                if type == "public.movie" {
                    self.dealModie(info: info)
                }else if type == "public.image" {
                    self.dealImage(info: info)
                }
                
            }
            picker.dismiss(animated: true) {}
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
//        if let editImageReal  = info[UIImagePickerControllerEditedImage] as? UIImage {
//            theImage = editImageReal
//        }else{
            if let originlImage  = info[UIImagePickerControllerOriginalImage] as? UIImage {
                theImage = originlImage
            }
//        }
        //perform upload image
        if theImage != nil  {
//            let imageDate = UIImagePNGRepresentation(theImage!)
            let imageData = UIImageJPEGRepresentation(theImage!, 0.5)
            if imageData != nil {
                self.upload(data: imageData!, rectSize : theImage!.size, type: "1")
                
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
                            GDNetworkManager.shareManager.insertMediaToCircle(circleID: self.circleID, original: key , type: type , description: nil , media_spec:  rectSize, success: { (model ) in
                                mylog("插入媒体到圈子 请求结果 : \(model.status) , 数据 :\(model.data)")
                                self.getCircles()
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
}
class GDCircleSessionHeaderModel: GDBaseModel {
    var datetime : String?
    var media_count : NSNumber?
    var permission : NSNumber?
    var address : String?
    var members : [String]?
}
class GDCircleSessionHeader: UICollectionReusableView {
    let label1 = UILabel()
    let label2 = UILabel()
    var model : GDCircleSessionHeaderModel? {
        didSet{
            let upAttributeStr = NSMutableAttributedString.init()
            let locationAtchment = NSTextAttachment.init()
            locationAtchment.bounds = CGRect(x: 0, y: -3, width: label1.font.lineHeight , height: label1.font.lineHeight  )
            locationAtchment.image = UIImage(named: "mediaDetaillocation")
            let timeAtchment = NSTextAttachment.init()
            timeAtchment.image = UIImage(named: "mediaDetailTime")
            timeAtchment.bounds = CGRect(x: 0, y: -3, width: label1.font.lineHeight , height: label1.font.lineHeight  )
            upAttributeStr.append(NSAttributedString.init(attachment: locationAtchment))
            upAttributeStr.append(NSAttributedString.init(string: model?.address ?? ""))
            upAttributeStr.append(NSAttributedString.init(attachment: timeAtchment))
            upAttributeStr.append(NSAttributedString.init(string: model?.datetime ?? ""))
            
            label1.attributedText  = upAttributeStr
            let downAttributeStr = NSMutableAttributedString.init()
            let cameraAtchment = NSTextAttachment.init()
            cameraAtchment.image = UIImage(named: "camera_icon_black")
            cameraAtchment.bounds = CGRect(x: 0, y: 0, width: label1.font.lineHeight , height: label1.font.lineHeight  * 0.8 )
            downAttributeStr.append(NSAttributedString.init(attachment: cameraAtchment))
            var tempStr  = ""
            mylog(model)
            mylog(model?.members)
            if let arr  = model?.members {
                var  result = arr.reduce("", { (result , item ) -> String in
                    result  + item + "&"
                })
                result.removeLast()
                tempStr = result
                mylog(result)
            }
//            for (index  , str ) in ((model?.members ?? []).enumerated()) {
//                if index != (model?.members?.count ?? 0) - 1{
//                    tempStr.append(str  + "&")
//                }else{                tempStr.append(str)}
//
//            }
            downAttributeStr.append(NSAttributedString.init(string: tempStr))
            
            label2.attributedText = downAttributeStr
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame )
        self.addSubview(label1)
        label1.font = UIFont.systemFont(ofSize: 12)
        label1.textColor = UIColor.lightGray
        self.addSubview(label2)
        label2.textColor = UIColor.gray
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        label1.frame = CGRect(x: 20, y: 0, width: self.bounds.width - 20 * 2, height: self.bounds.height * 0.5)
        label2.frame = CGRect(x: 20, y: self.bounds.height * 0.4, width: self.bounds.width - 20 * 2, height: self.bounds.height * 0.5)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class GDCircleDetailItem: UICollectionViewCell {
    let  imageView = UIImageView()
    let nameLabel  = UILabel()
    let zanAndCommentLabel = UILabel()
    let locationAndTime = UILabel()
    
    var model :  GDCircleDetailItemModel = GDCircleDetailItemModel.init(dict: nil){
        didSet{
            if let url  = URL(string: model.thumbnail ?? "") {
                imageView.sd_setImage(with: url)
            }
            let upAttributeStr = NSMutableAttributedString.init()
            let locationAtchment = NSTextAttachment.init()
            locationAtchment.bounds = CGRect(x: 0, y: -3, width: zanAndCommentLabel.font.lineHeight , height: zanAndCommentLabel.font.lineHeight  )
            locationAtchment.image = UIImage(named: "mediaDetaillocation")
            let timeAtchment = NSTextAttachment.init()
            timeAtchment.image = UIImage(named: "mediaDetailTime")
            timeAtchment.bounds = CGRect(x: 0, y: -3, width: zanAndCommentLabel.font.lineHeight , height: zanAndCommentLabel.font.lineHeight  )
            upAttributeStr.append(NSAttributedString.init(attachment: locationAtchment))
            upAttributeStr.append(NSAttributedString.init(string:model.media_good_count ?? ""))
            upAttributeStr.append(NSAttributedString.init(attachment: timeAtchment))
            upAttributeStr.append(NSAttributedString.init(string: model.media_comment_count ?? ""))
            
            zanAndCommentLabel.attributedText  = upAttributeStr
            
            nameLabel.text = model.create_user_name
            locationAndTime.text = (model.country ?? "")/* + (model.province ?? "")*/ + (model.city ?? "" )  + (model.create_date ?? "")
            self.layoutIfNeeded()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame )
        self.setupSubviews()
    }
    func setupSubviews()  {
        self.contentView.addSubview(imageView)
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(zanAndCommentLabel)
        self.contentView.addSubview(locationAndTime)
        zanAndCommentLabel.textAlignment = NSTextAlignment.right
        zanAndCommentLabel.font = UIFont.systemFont(ofSize: 13)
        nameLabel.font = UIFont.systemFont(ofSize: 13)
        locationAndTime.font = UIFont.systemFont(ofSize: 13)
        zanAndCommentLabel.textColor = UIColor.lightGray
        nameLabel.textColor = UIColor.lightGray
        locationAndTime.textColor = UIColor.lightGray
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageMargin : CGFloat = 0
        
        let tempWidth = Float.init(model.media_width ?? "0")
        let imageWidth = CGFloat.init(tempWidth ?? 0.0)
        let tempHeight = Float.init(model.media_height ?? "0")
        if tempWidth == 0 || tempHeight == 0 {
            return
        }
        let imageHeight = CGFloat.init(tempHeight ?? 0.0)
        let imageShowWidth = self.bounds.size.width - imageMargin * 2
        
        let imageShowHeidht =  imageShowWidth / imageWidth * imageHeight //* (self.bounds.size.height - bottomH - 2 * imageMargin)
        imageView.frame = CGRect(x: imageMargin, y: imageMargin, width: imageShowWidth, height: imageShowHeidht )
        let buttomY  =  imageView.frame.maxY + imageMargin
        let bottomH  : CGFloat =  self.bounds.size.height - buttomY
        
        nameLabel.frame = CGRect(x: 0, y: buttomY, width: self.bounds.width * 0.5, height: bottomH * 0.6)
        zanAndCommentLabel.frame = CGRect(x: self.bounds.width * 0.5, y: buttomY, width: self.bounds.width * 0.5, height: bottomH * 0.6)
        locationAndTime.frame = CGRect(x: 0, y:buttomY + bottomH * 0.5, width: self.bounds.width , height: bottomH * 0.4)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class GDCircleDetailItemModel: GDBaseModel {
   @objc  var id  : String?
    @objc var media_type  : String?
    @objc var media_width  : String?
    @objc var media_height  : String?
    @objc var user_id  : String?
    @objc var media_spec  : String?
    @objc var create_user_name  : String?
    @objc var thumbnail  : String?
    @objc var media_comment_count  : String?
    @objc var media_good_count  : String?
    @objc var create_date  : String?
    
    @objc var country  : String?
    @objc var province  : String?//省
    @objc var city  : String?//市
    
    /**
     id = 2715;
     create_date = 2017-09-16;
     media_type = 1;
     province = 北京市;
     media_width = 600;
     user_id = 219;
     media_good_count = 0;
     media_spec = 0,0;
     city = 北京市;
     media_height = 400;
     create_user_name = JohnLock;
     thumbnail = http://f0.ugshop.cn/Fpdgi530aMQG35S_vHQ8D-kHfBw3?imageView2/1/w/200/h/200;
     media_comment_count = 0;
     country = 中国;
     */
}


@objc protocol GDFlowLayoutProtocol : NSObjectProtocol{
    func provideItemHeight(layout:GDFlowLayout? , indexPath : IndexPath) -> CGFloat
    func provideItemWidth(layout: GDFlowLayout?) -> CGFloat
    @objc optional func provideColumnCount(layout:GDFlowLayout?) -> Int
    @objc optional func provideColumnMargin(layout:GDFlowLayout?) -> CGFloat
    @objc optional func provideRowMargin(layout:GDFlowLayout?) -> CGFloat
    @objc optional func provideEdgeInsets(layout:GDFlowLayout?) -> UIEdgeInsets
    @objc optional func provideSessionHeaderHeight(layout:GDFlowLayout?) -> CGFloat
}
class GDFlowLayout: UICollectionViewLayout {
    weak var  delegate :GDFlowLayoutProtocol?
    var columnCount : Int {
        let sessionHeaderH  = self.delegate?.provideSessionHeaderHeight?(layout: self) ?? 0
        
        if let column = self.delegate?.provideColumnCount?(layout: self) {
            mylog(columns.count)
            mylog(column)
            if columns.count != column {
                columns = Array.init(repeating: sessionHeaderH, count: column)
            }
            return  column
        }else{
            columns = [sessionHeaderH]
            return 1
        }
    }
    var columnMargin : CGFloat {
       if let columnMargin = self.delegate?.provideColumnMargin?(layout: self) {return  columnMargin}else{return 0}
    }
    var rowMargin: CGFloat{
       if let rowMargin = self.delegate?.provideRowMargin?(layout: self) {return  rowMargin}else{return 0}
    }
    var edgeInsets : UIEdgeInsets {
       if let edgeInsets = self.delegate?.provideEdgeInsets?(layout: self) {return  edgeInsets}else{return UIEdgeInsets.zero}
    }
    var attributes : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    var maxY : CGFloat = 0
    var minY : CGFloat = 0
    var columns : [CGFloat] = [CGFloat]()
    override func prepare() {
        super.prepare()
        attributes.removeAll()
        //先考虑只有一组的情况, 而且没有header
        columns.removeAll()
        let _ = columnCount//chushihua
        let itemsCount = self.collectionView?.numberOfItems(inSection: 0) ?? 0
        let sectionCount = self.collectionView?.numberOfSections ?? 0
        if sectionCount > 0  {
            if let header = self.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: IndexPath(item: 0, section: 0)){
                attributes.append(header)
            }
        }
        for index  in 0..<itemsCount {
            let currentIndex = IndexPath(item: index, section: 0)
            if let attribute = self.layoutAttributesForItem(at: currentIndex){
                attributes.append(attribute)
            }
        }
    }
    override var collectionViewContentSize: CGSize{
        return CGSize(width: self.collectionView?.bounds.size.width ?? UIScreen.main.bounds.size.width, height: self.columns.max() ?? 0)
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes
    }
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes?{
        if indexPath.section == 0  {
            let headerAttribute  = UICollectionViewLayoutAttributes.init(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: indexPath)
            headerAttribute.frame = CGRect(x: 0, y: 0, width: self.collectionView?.bounds.width ?? UIScreen.main.bounds.width, height: 64)
            return headerAttribute
        }
        return nil
    }
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attribute = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        let width = self.delegate?.provideItemWidth(layout: self)  ?? 0
        let height = self.delegate?.provideItemHeight(layout: self, indexPath: indexPath) ?? 0
        let shortestYvalue = self.columns.min() ?? 0
        let shortestYvalueCol = self.columns.index(of: shortestYvalue)
        let columNum = shortestYvalueCol 
        let x = self.edgeInsets.left + CGFloat(columNum ?? 0) * (width + self.columnMargin)
        let y = columns[columNum ?? 0]  + rowMargin
        self.columns[columNum ?? 0] = columns[columNum ?? 0] + height
        attribute.frame = CGRect(x: x , y: y , width: width, height: height)
        return attribute
    }
}
