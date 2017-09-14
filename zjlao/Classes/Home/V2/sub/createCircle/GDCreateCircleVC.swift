//
//  GDCreateCircleVC.swift
//  zjlao
//
//  Created by WY on 2017/9/13.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit

class GDCreateCircleVC: GDNormalVC {

    @IBOutlet weak var circlePasscode: UITextField!
    @IBOutlet weak var memberLimit: UITextField!
    @IBOutlet weak var circleName: UITextField!
    let createButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.view.backgroundColor = UIColor.white
        self.setupCreateButton()
        //        self.naviBar.currentBarActionType = .color//.alpha //
        //        self.naviBar.layoutType = .asc
        // Do any additional setup after loading the view.
    }
    func setupCreateButton()  {
        createButton.frame = CGRect(   x: UIScreen.main.bounds.size.width - 84, y: 20, width: 84, height: 44)
        createButton.setTitleColor(UIColor.gray, for: UIControlState.normal)
        createButton.setTitle("创建圈子", for: UIControlState.normal)
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        createButton.addTarget(self , action: #selector(performCreate), for: UIControlEvents.touchUpInside)
        self.naviBar.customViews = [createButton]
    }
    func performCreate()  {
        mylog("performCreate")
        if circleName.text == nil  {
            GDAlertView.alert("请输入圈子名称", image: nil , time: 2 , complateBlock: nil)
            return
        }
        self.performCreateCircle()
    }
    func performCreateCircle() {
        GDNetworkManager.shareManager.createNewCircle(name: self.circleName.text!, memberNum: self.memberLimit.text, password: self.memberLimit.text, success: { (model ) in
            mylog(model.status)
            mylog(model.data)
        }) { (error ) in
            mylog(error)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.default
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
