//
//  GDCreateNewCircleVC.swift
//  zjlao
//
//  Created by WY on 2017/9/12.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit

class GDCreateNewCircleVC: GDNormalVC {

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = UIColor.green
//        self.naviBar.currentBarActionType = .color//.alpha //
        //        self.naviBar.layoutType = .asc
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
        mylog(self.naviBar)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        super.preferredStatusBarStyle
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
