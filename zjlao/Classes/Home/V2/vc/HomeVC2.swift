//
//  HomeVC2.swift
//  zjlao
//
//  Created by WY on 2017/9/9.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit

class HomeVC2: GDBaseVC , GDAutoScrollViewActionDelegate{

    let autoScrollView = GDAutoScrollView.init(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width * 0.5))
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.black 
        self.prepareSubViews()
        self.getAD()
    }
    func prepareSubViews()  {
        autoScrollView.backgroundColor = UIColor.red
        autoScrollView.delegate = self
        self.view.addSubview(autoScrollView)
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
            mylog("获取广告状态码:\(model.status) , 相应数据 : \(model.data )")
            if let arr  = model.data , let dictArr = arr as? [[String  : String]] {
                var models = [BaseControlModel]()
                for (key , value) in dictArr.enumerated(){
                    let model = BaseControlModel.init(dict: ["title" : value["link_url"] as AnyObject, "imageUrl" : value["image_url"] as AnyObject])
                    models.append(model)
                }
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

}
