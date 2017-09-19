//
//  GDAllCirclesVC.swift
//  zjlao
//
//  Created by WY on 2017/9/15.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit

class GDAllCirclesVC: GDNormalVC , UITextFieldDelegate {
    let createButton = UIButton()
    var models : [CircleItemModel]?
    let pwdTextField = UITextField.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
    let unlockBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 64, height: 44))
    weak var cover  : GDCoverView?
    var selectedCircleID = ""
    var selectedTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.naviBar.backgroundColor = UIColor.black
        var attritit = NSMutableAttributedString.init(string: "所有圈子")
        attritit.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: NSRange.init(location: 0, length: attritit.string.characters.count))
        self.naviBar.attributeTitle = attritit
        self.setupCreateButton()
        self.prepareSubViews()
        self.getCircles()
        self.naviBar.backBtn.setImage(UIImage(named: "icon_classify_homepage"), for: UIControlState.normal)
        
        unlockBtn.addTarget(self , action: #selector(unlockBtnClick), for: UIControlEvents.touchUpInside)
        
        // Do any additional setup after loading the view.
    }
    func prepareSubViews()  {

        ///:circleView
        guard let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        let cellMargin : CGFloat = 11
        let circleNameH : CGFloat = 25
        flowLayout.minimumLineSpacing = cellMargin
        flowLayout.minimumInteritemSpacing = cellMargin
        //        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        let collectionW = self.view.bounds.size.width
        let itemW = (collectionW - cellMargin * 4 ) / 3
        flowLayout.itemSize = CGSize(width: itemW, height: itemW+circleNameH)
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: cellMargin, bottom: 0, right: cellMargin)
        let collectionH = UIScreen.main.bounds.size.height - 20
//        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        collectionView.frame =  CGRect(x : 0 , y : 20 , width : collectionW  , height : collectionH)
        collectionView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
        self.collectionView.backgroundColor = UIColor.init(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
        collectionView.register(CircleItem.self , forCellWithReuseIdentifier: "AllCircleItem")
        ///:createCircle
   
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return  models?.count ?? 0
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "AllCircleItem", for: indexPath)
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
    func getCircles() {
        GDNetworkManager.shareManager.getNearbyCircles(circleNum : "0" ,success: { (model ) in
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
                    self.collectionView.isHidden = false
                    self.models = tempModels
                    self.collectionView.reloadData()
                }else{
                    self.collectionView.isHidden = true
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupCreateButton()  {
        
//        createButton.setTitleColor(UIColor.gray, for: UIControlState.normal)
        createButton.setTitle("创建圈子", for: UIControlState.normal)
        createButton.sizeToFit()
        createButton.frame = CGRect(   x: UIScreen.main.bounds.size.width - createButton.frame.width, y: 20, width: createButton.frame.width, height: 44)
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        createButton.addTarget(self , action: #selector(performCreate), for: UIControlEvents.touchUpInside)
        self.naviBar.customViews = [createButton]
        //        self.naviBar.backBtn.isHidden = false
    }
    @objc func performCreate() {
        let model  = GDBaseModel.init(dict: nil)
        model.actionkey = "GDCreateCircleVC"//  "GDCreateNewCircleVC"
        GDSkipManager.skip(viewController: self , model: model)
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
