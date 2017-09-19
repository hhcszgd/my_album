//
//  HomeVC2.swift
//  zjlao
//
//  Created by WY on 2017/9/9.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit

class HomeVC2: GDBaseVC , GDAutoScrollViewActionDelegate , UICollectionViewDelegate , UICollectionViewDataSource , UITextFieldDelegate{

    let autoScrollView = GDAutoScrollView.init(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width * 0.5))
    let backView = UIView()
    let nearbyCircleLabel = UILabel()
    let createdNewCircleButton = UIButton()
		
    let seeAllCircles = UIButton()
    var models : [CircleItemModel]?
    var circleView : UICollectionView!
    let pwdTextField = UITextField.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
    let unlockBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 64, height: 44))
    weak var cover  : GDCoverView?
    var selectedCircleID = ""
    var selectedTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.black
        self.prepareSubViews()
        self.getAD()
        self.gerCircles()
        unlockBtn.addTarget(self , action: #selector(unlockBtnClick), for: UIControlEvents.touchUpInside)
        
    }
    
    func prepareSubViews()  {
        ///:autoScrollView
        
        autoScrollView.backgroundColor = UIColor.red
        autoScrollView.delegate = self
        
        self.view.addSubview(autoScrollView)
        ///:backView
        self.view.addSubview(backView)
        backView.backgroundColor = UIColor.init(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
        backView.frame = CGRect(x: 0, y: autoScrollView.frame.maxY, width: self.view.bounds.size.width , height: self.view.bounds.size.height - autoScrollView.bounds.size.height)

        
        ///:circleView
        let flowLayout = UICollectionViewFlowLayout.init()
        let cellMargin : CGFloat = 11
        let circleNameH : CGFloat = 25
        flowLayout.minimumLineSpacing = cellMargin
        flowLayout.minimumInteritemSpacing = cellMargin
//        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        let collectionW = self.view.bounds.size.width - cellMargin * 2
        let itemW = (collectionW - cellMargin * 2 ) / 3
        let collectionH = (itemW + circleNameH ) * 2 + cellMargin
        flowLayout.itemSize =  CGSize(width: itemW, height: itemW + circleNameH)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        circleView = UICollectionView.init(frame: CGRect(x : cellMargin , y : autoScrollView.frame.maxY + 44 , width : collectionW  , height : collectionH) , collectionViewLayout: flowLayout)
        self.view.addSubview(circleView)
        self.circleView.backgroundColor = UIColor.init(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
        circleView.register(CircleItem.self , forCellWithReuseIdentifier: "CircleItem")
        circleView.delegate = self
        circleView.dataSource = self
        circleView.isPagingEnabled = true
        ///:createCircle
        self.view.addSubview(createdNewCircleButton)
        createdNewCircleButton.setTitle("新建圈子+", for: UIControlState.normal)
        createdNewCircleButton.sizeToFit()
        createdNewCircleButton.titleLabel?.sizeToFit()
        createdNewCircleButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        createdNewCircleButton.center = CGPoint(x: circleView.frame.maxX - createdNewCircleButton.bounds.size.width / 2 , y: circleView.frame.minY - createdNewCircleButton.bounds.size.height / 2 )
        createdNewCircleButton.addTarget(self , action: #selector(createCircle), for: UIControlEvents.touchUpInside)
        ///:seeAllCircles
        self.view.addSubview(seeAllCircles)
        seeAllCircles.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        seeAllCircles.setTitle("查看所有的圈子 >>>  ", for: UIControlState.normal)
        seeAllCircles.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        seeAllCircles.sizeToFit()
        seeAllCircles.center = CGPoint(x: self.view.bounds.size.width - seeAllCircles.bounds.width / 2 , y:  self.view.bounds.size.height - 49 - self.seeAllCircles.bounds.height / 2 )
        seeAllCircles.addTarget(self , action: #selector(performSeeAllCircles), for: UIControlEvents.touchUpInside)
        ///:nearbyCircleLabel
        self.view.addSubview(nearbyCircleLabel)
        nearbyCircleLabel.textColor = UIColor.lightGray
        nearbyCircleLabel.text = "附近的圈子"
        nearbyCircleLabel.sizeToFit()
        nearbyCircleLabel.center = CGPoint(x: cellMargin + createdNewCircleButton.bounds.size.width / 2 , y: circleView.frame.minY - createdNewCircleButton.bounds.size.height / 2 )

    }
    @objc func createCircle()  {
        print("create new circle ")
        let model  = GDBaseModel.init(dict: nil)
        model.actionkey = "GDCreateCircleVC"//  "GDCreateNewCircleVC"
        GDSkipManager.skip(viewController: self , model: model)
    }
    @objc func performSeeAllCircles()  {
        mylog("see all circles")
        let model = GDBaseModel.init(dict: nil )
        model.actionkey = "GDAllCirclesVC"
        GDSkipManager.skip(viewController: self , model: model )
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return  models?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "CircleItem", for: indexPath)
        let itemIndex  = indexPath.item % models!.count
        if let realItem  = item as? CircleItem {
            realItem.model = models![itemIndex]
        }
        return item
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dataModel = models![indexPath.item % models!.count]

        mylog("点击的圈子信息 : id:\(String(describing: dataModel.id)) , 权限 : \(String(describing: dataModel.permission))")
        self.selectedCircleID = "\(dataModel.id ?? 0)"
        self.selectedTitle = dataModel.circle_name ?? ""
        if dataModel.permission == 1 {
            dataModel.actionkey = "GDCircleDetailVC2"
            let para = ["id" : "\(dataModel.id ?? 0)" , "title" : dataModel.circle_name ?? "圈子详情"] as [String : String]
            dataModel.keyparamete = para as AnyObject
            GDSkipManager.skip(viewController: self , model: dataModel)
        }else{//输入密码再进
            self.setupPwdInput()
        }
    }
    func setupPwdInput() {
        let cover = GDCoverView.init(superView: self.view)
        self.cover = cover
        self.pwdTextField.frame = CGRect(x: cover.contentView.frame.minX + 10 , y: 40, width:  cover.contentView.frame.width - 20, height: 44)
        cover.contentView.addSubview(self.pwdTextField)
        self.pwdTextField.borderStyle = UITextBorderStyle.roundedRect
        self.pwdTextField.backgroundColor = UIColor.white
        self.pwdTextField.placeholder = "输入密码进入圈子"
        self.unlockBtn.setTitle("解锁", for: UIControlState.normal)
        cover.contentView.backgroundColor = UIColor.init(red: 65/100, green: 59/100, blue: 36/100, alpha: 1)
        self.unlockBtn.frame = CGRect( x: cover.contentView.frame.midX - 64 / 2 , y: pwdTextField.frame.maxY + 44, width: 64, height: 40   )
        self.unlockBtn.backgroundColor = UIColor.init(red: 36/100, green: 57/100, blue: 76/100, alpha: 1)
        self.cover?.contentView.addSubview(self.unlockBtn)
        
        self.pwdTextField.delegate = self
        self.pwdTextField.becomeFirstResponder()
        mylog(UIApplication.shared.windows)
        }
    @objc func unlockBtnClick(){
        if self.pwdTextField.text?.isEmpty ?? false  {
            GDAlertView.alert("请输入密码", image: nil, time: 2, complateBlock: nil )
            return
        }
        GDNetworkManager.shareManager.getCircleDetail(circleID: selectedCircleID, page: "1", password: self.pwdTextField.text, success: { (model ) in
            switch model.status {
            case 200 :

                //接口判断密码的有效性
                let tempmodel = GDBaseModel.init(dict: nil )
                tempmodel.actionkey = "GDCircleDetailVC2"
                let para = ["id" : "\(self.selectedCircleID )" ,"title" : self.selectedTitle , "password" : self.pwdTextField.text ?? ""] as [String : String]
                tempmodel.keyparamete = para as AnyObject
                        GDSkipManager.skip(viewController: self , model: tempmodel)
            case 324 :
                GDAlertView.alert("圈子已失效", image: nil, time: 2, complateBlock: nil )
                
                
            case 345 :
                GDAlertView.alert("密码错误", image: nil, time: 2, complateBlock: nil )
                
                
            case 354 :
                GDAlertView.alert("加入失败", image: nil, time: 2, complateBlock: nil )
                
                
            case 356 :
                GDAlertView.alert("圈子人数已满", image: nil, time: 2, complateBlock: nil )
                
                
            default :
                GDAlertView.alert("未知错误", image: nil, time: 2, complateBlock: nil )
                
            }
        }) { (errr) in
            GDAlertView.alert("操作失败 请重试", image: nil , time: 2 , complateBlock: nil )

            mylog("操作失败  请重试")
        }
        self.pwdTextField.text = nil
        self.cover?.remove()
    }
    func textFieldDidBeginEditing(_ textField: UITextField){
        mylog(GDKeyVC.share.keyBoardSize)
        let keyboardMinY = UIScreen.main.bounds.height - GDKeyVC.share.keyBoardSize.height - 20
        let needMoveY = keyboardMinY - (self.cover?.contentView.frame.maxY ?? 0)
        self.cover?.moveContent(offset: needMoveY)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
         mylog(UIApplication.shared.windows)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        return true
    }
    
    func performToWebAction(model: GDBaseModel) {
        model.actionkey = "webpage"
     GDSkipManager.skip(viewController: self , model: model )
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    func getAD() {
        GDNetworkManager.shareManager.getAD(success: { (model ) in
            mylog("获取广告状态码:\(model.status) , 相应数据 : \(String(describing: model.data ))")
            if let arr  = model.data , let dictArr = arr as? [[String  : String]] {
                var models = [BaseControlModel]()
                for (_ , value) in dictArr.enumerated(){
                    let model = BaseControlModel.init(dict: ["title" : value["link_url"] as AnyObject, "imageUrl" : value["image_url"] as AnyObject])
                    models.append(model)
                }
//                let m1 =  BaseControlModel.init(dict: ["title" :"http://www.baidu.com" as AnyObject, "imageUrl" : "http://f0.ugshop.cn/advert/1504597809.jpg" as AnyObject])
//                let m2 =  BaseControlModel.init(dict: ["title" :"http://www.baidu.com" as AnyObject, "imageUrl" : "http://f0.ugshop.cn/advert/1504597809.jpg" as AnyObject])
//                
//                models.append(m1)
//                models.append(m2)
                self.autoScrollView.models = models
            }
            
        }) { (error ) in
            mylog("获取广告错误\(error)")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    func gerCircles() {
        GDNetworkManager.shareManager.getNearbyCircles(circleNum : "6" ,success: { (model ) in
            mylog("首页获取附近的圈子成功 status : \(model.status) , data : \(String(describing: model.data ))")
            
            if let arr = model.data as? [[String : AnyObject]]{
                var tempModels = [CircleItemModel]()
                for (_ , dict ) in arr.enumerated(){
                    let tempModel = CircleItemModel.init(dict: dict )
//                    mylog(tempModel.circle_image)
//                    mylog(tempModel.circle_member_count)
//                    mylog(tempModel.circle_name)
//                    mylog(tempModel.circle_type)
//                    mylog(tempModel.permission)
//                    mylog(tempModel.id)
                    tempModels.append(tempModel)
                    
                }
                if tempModels.count > 0 {
                    self.circleView.isHidden = false
                    self.models = tempModels
                    self.circleView.reloadData()
                }else{
                    self.circleView.isHidden = true
                }
                /**
                 ["circle_image": , "id": 1125, "circle_type": 2, "circle_name": 圈子11112222, "circle_member_count": 1, "circle_member_number": 80, "permission": 0]
                 */
                
            }else{
                mylog("首页获取附近的圈子类型转换失败")
            }
        }) { (error ) in
            mylog("首页获取附近的圈子失败: \(error)")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
class CircleItemModel : GDBaseModel {
    override init(dict: [String : AnyObject]?) {
        super.init(dict: dict)
    }
    var circle_image : String?
    var id : NSNumber?
    var circle_type : String?
    var circle_name : String?
    var circle_member_count : NSNumber?
    var circle_member_number : Int?
    var permission : NSNumber?
}
class CircleItem : UICollectionViewCell {
    let  circleImage = UIImageView()
    let circleMemberLabel = UILabel()
    let  lockIcon = UIButton()
    let  circleName = UILabel()
    var model  = CircleItemModel.init(dict: nil){
        didSet{
            if let url  = URL.init(string: model.circle_image ?? "") {//image
                circleImage.sd_setImage(with: url  )
            }
            mylog(model.circle_name)
            circleName.text = model.circle_name ?? ""
            circleMemberLabel.text =  "\(model.circle_member_number ?? 0)" + "/" + "\(model.circle_member_count ?? 0)"
            
            self.layoutIfNeeded()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame )
        self.contentView.addSubview(circleImage)
        self.contentView.addSubview(circleMemberLabel)
        circleMemberLabel.textColor = UIColor.lightGray
        self.contentView.backgroundColor = UIColor.white
        self.contentView.addSubview(lockIcon)
        lockIcon.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0 )
        self.contentView.addSubview(circleName)
        circleName.font =  UIFont.systemFont(ofSize: 13)
        lockIcon.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        lockIcon.titleLabel?.font = circleName.font
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let margin : CGFloat = 5
        let imageViewW = self.bounds.size.width - margin * 2
        self.circleImage.frame = CGRect(x: margin , y: margin , width: imageViewW, height: imageViewW)
        if model.permission ?? 0 == 2 {//没有权限
            self.lockIcon.setTitle("🔐" , for: UIControlState.normal)
        }else{
            self.lockIcon.setTitle("公开" , for: UIControlState.normal)
        }
        self.lockIcon.sizeToFit()
        let lockCenterY = self.circleImage.frame.maxY +  (self.bounds.size.height - self.circleImage.frame.maxY ) * 0.5
        
        self.lockIcon.center = CGPoint(x: self.bounds.size.width - margin - lockIcon.bounds.width * 0.3, y: lockCenterY)
        
        ///: circleName
        self.circleName.frame = CGRect(x: margin , y:  lockCenterY - circleName.font.lineHeight / 2, width: lockIcon.frame.minX - margin, height: circleName.font.lineHeight)
        ///:memberCount
        circleMemberLabel.sizeToFit()
        circleMemberLabel.center = CGPoint(x: margin + circleMemberLabel.bounds.size.width / 2 , y: margin + circleMemberLabel.bounds.size.height / 2 )
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

