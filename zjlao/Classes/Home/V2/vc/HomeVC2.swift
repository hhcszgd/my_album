//
//  HomeVC2.swift
//  zjlao
//
//  Created by WY on 2017/9/9.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit

class HomeVC2: GDBaseVC , GDAutoScrollViewActionDelegate , UICollectionViewDelegate , UICollectionViewDataSource{

    let autoScrollView = GDAutoScrollView.init(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width * 0.5))
//    let backView = UIView()
//    let nearbyCircleLabel = UILabel()
//    let createdNewCircleButton = UIButton()
		
//    let seeAllCircles = UIButton()
    
    var circleView : UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.black 
        self.prepareSubViews()
        self.getAD()
    }
    func prepareSubViews()  {
        ///:autoScrollView
        autoScrollView.backgroundColor = UIColor.red
        autoScrollView.delegate = self
        self.view.addSubview(autoScrollView)
        ///:circleView
        
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.minimumLineSpacing = 20
        flowLayout.minimumInteritemSpacing = 20
//        let itemW = (self.view.frame.size.width - 20 * 3 ) / 3
        flowLayout.itemSize =  CGSize.zero
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        circleView = UICollectionView.init(frame: CGRect(x : 0 , y : autoScrollView.frame.maxY + 44 , width : self.view.bounds.size.width , height : 2) , collectionViewLayout: flowLayout)
        self.view.addSubview(circleView)
        circleView.register(CircleItem.self , forCellWithReuseIdentifier: "CircleItem")
        circleView.delegate = self
        circleView.dataSource = self
        circleView.isPagingEnabled = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return  3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "CircleItem", for: indexPath)
//        let itemIndex  = indexPath.item % models.count
//        if let realItem  = item as? Item {
//            realItem.model = models[itemIndex]
//        }
        item.backgroundColor = UIColor.randomColor()
        return item
    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let actionModel = GDBaseModel.init(dict: nil)
//        let dataModel = models[indexPath.item % models.count]
//        actionModel.keyparamete = (dataModel.title ?? "" ) as AnyObject
//        self.delegate?.performToWebAction(model: actionModel)
//    }
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
                let m1 =  BaseControlModel.init(dict: ["title" :"http://www.baidu.com" as AnyObject, "imageUrl" : "http://f0.ugshop.cn/advert/1504597809.jpg" as AnyObject])
                let m2 =  BaseControlModel.init(dict: ["title" :"http://www.baidu.com" as AnyObject, "imageUrl" : "http://f0.ugshop.cn/advert/1504597809.jpg" as AnyObject])
                
                models.append(m1)
                models.append(m2)
                self.autoScrollView.models = models
            }
            
        }) { (error ) in
            mylog("获取广告错误\(error)")
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
    class CircleItem : UICollectionViewCell {

    }
}

