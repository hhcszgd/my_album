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

class GDCircleDetailVC2: GDNormalVC {
    let qieziButton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
    var circleID  = "0"
    var picker : UIImagePickerController?
    var models : [GDCircleDetailItemModel]?
    var page  : Int = 1
    var pwd : String?
    
    var circleName : String = "" {
        didSet{
            let attritit = NSMutableAttributedString.init(string: circleName)
        attritit.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSRange.init(location: 0, length: attritit.string.characters.count))
        self.naviBar.attributeTitle = attritit
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.setupNaviBar()
        mylog(keyModel?.keyparamete)
        if let para  = keyModel?.keyparamete as? [String:String] {
            circleName = para["title"]!
            self.circleID = para["id"]!
        }
        self.setupQZButton()
        // Do any additional setup after loading the view.
        self.prepareSubViews()
        self.getCircles()
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
    func createMedia()  {
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
        collectionView.register(GDCircleDetailItem.self , forCellWithReuseIdentifier: "GDCircleDetailItem")
        ///:createCircle
        
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
    func provideColumnCount(layout: GDFlowLayout?) -> Int {return 3}
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
        let dataModel = models![indexPath.item % models!.count]
        
        
    }
    
    
    func getCircles() {
        GDNetworkManager.shareManager.getCircleDetail(circleID: circleID, page: "\(page)" , password: pwd, success: { (model ) in
            mylog("获取圈子详情 : \(model.data)")
            if let outSideDict = model.data as? [String : AnyObject]{
                if let arr = outSideDict["media"] as? [[String : AnyObject]]{
                    var tempModels = [GDCircleDetailItemModel]()
                    for (_ , dict ) in arr.enumerated(){
//                        mylog(dict)
                        let tempModel = GDCircleDetailItemModel.init(dict: dict )
//                        dump(tempModel)
                        tempModels.append(tempModel)
                    }
                    if tempModels.count > 0 {
                        self.models = tempModels
                        self.collectionView.reloadData()
                    }
                }
                if let datetime = outSideDict["datetime"] as? String{
                    mylog(datetime)
                }
                
                if let media_count = outSideDict["media_count"] as? NSNumber{
                    mylog(media_count)
                }
                if let permission = outSideDict["permission"] as? NSNumber{
                    mylog(permission)
                }
                if let address = outSideDict["address"] as? String{
                    mylog(address)
                }
                mylog(outSideDict["members"])
                if let members = outSideDict["members"] as? [String]{
                    mylog(members)
                }
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
//        if let editImageReal  = info[UIImagePickerControllerEditedImage] as? UIImage {
//            theImage = editImageReal
//        }else{
            if let originlImage  = info[UIImagePickerControllerOriginalImage] as? UIImage {
                theImage = originlImage
            }
//        }
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
                            GDNetworkManager.shareManager.insertMediaToCircle(circleID: self.circleID, original: key , type: type , description: nil , media_spec:  rectSize, success: { (model ) in
                                mylog("插入媒体到圈子 请求结果 : \(model.status) , 数据 :\(model.data)")
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


class GDCircleDetailItem: UICollectionViewCell {
    let  imageView = UIImageView()
    let nameLabel  = UILabel()
    let zanBtn = UIButton()
    let commentBtn = UIButton()
    let locationAndTime = UILabel()
    
    
    
    
    var model :  GDCircleDetailItemModel = GDCircleDetailItemModel.init(dict: nil){
        didSet{
            if let url  = URL(string: model.thumbnail ?? "") {
                imageView.sd_setImage(with: url)
            }
            self.layoutIfNeeded()
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame )
        self.setupSubviews()
        self.contentView.backgroundColor = UIColor.randomColor()
    }
    func setupSubviews()  {
        self.contentView.addSubview(imageView)
        imageView.contentMode = UIViewContentMode.scaleAspectFill
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class GDCircleDetailItemModel: GDBaseModel {
    var id  : String?
    var media_type  : String?
    var media_width  : String?
    var media_height  : String?
    var user_id  : String?
    var media_spec  : String?
    var create_user_name  : String?
    var thumbnail  : String?
    var media_comment_count  : String?
    var media_good_count  : String?
    var create_date  : String?
    
    var country  : String?
    var province  : String?//省
    var city  : String?//市
    
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
}
class GDFlowLayout: UICollectionViewLayout {
    weak var  delegate :GDFlowLayoutProtocol?
    var columnCount : Int {
        if let column = self.delegate?.provideColumnCount?(layout: self) {
            mylog(columns.count)
            mylog(column)
            if columns.count != column {
                columns = Array.init(repeating: 0, count: column)
            }
            return  column
        }else{
            columns = [0]
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
        let _ = columnCount
        let itemsCount = self.collectionView?.numberOfItems(inSection: 0) ?? 0
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
