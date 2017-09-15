//
//  GDAllCirclesVC.swift
//  zjlao
//
//  Created by WY on 2017/9/15.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit

class GDAllCirclesVC: GDNormalVC {
    let createButton = UIButton()
    var models : [CircleItemModel]?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.naviBar.backgroundColor = UIColor.black
        var attritit = NSMutableAttributedString.init(string: "所有圈子")
        attritit.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSRange.init(location: 0, length: attritit.string.characters.count))
        self.naviBar.attributeTitle = attritit
        self.setupCreateButton()
        self.prepareSubViews()
        self.getCircles()
        self.naviBar.backBtn.setImage(UIImage(named: "icon_classify_homepage"), for: UIControlState.normal)
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
        let collectionH = UIScreen.main.bounds.size.height
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
        if dataModel.permission == 1 {
            dataModel.actionkey = "GDCircleDetailVC2"
            let para = ["id" : "\(dataModel.id ?? 0)" , "title" : dataModel.circle_name ?? "圈子详情"] as [String : String]
            dataModel.keyparamete = para as AnyObject
            GDSkipManager.skip(viewController: self , model: dataModel)
        }else{//输入密码再进
            
            
        }
        
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
    func performCreate() {
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
