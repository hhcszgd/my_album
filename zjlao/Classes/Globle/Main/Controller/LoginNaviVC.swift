//
//  LoginNaviVC.swift
//  mh824appWithSwift
//
//  Created by wangyuanfei on 16/9/13.
//  Copyright © 2016年 www.16lao.com. All rights reserved.
//

import UIKit

class LoginNaviVC: UINavigationController {


    
    /// 自定义便利构造方法
    ///
    /// - Parameter rootVC: 跟控制器 , 可为空
    convenience init(rootVC: UIViewController?) {
        if rootVC == nil   {
            
            let loginvc = LoginVC.init()
            self.init(rootViewController: loginvc)
        }else {
            self.init(rootViewController: rootVC!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        mylog("登录页面销毁")
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
