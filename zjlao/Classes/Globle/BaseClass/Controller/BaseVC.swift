//
//  BaseVC.swift
//  mh824appWithSwift
//
//  Created by wangyuanfei on 16/8/24.
//  Copyright © 2016年 www.16lao.com. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {
    var TabBarHeight : CGFloat {
        return self.tabBarController?.tabBar.bounds.size.height ?? 44.0
    }
    var parameter : AnyObject? //用来接收关键参数的属性 (字符串 , 自定义模型等等)
    var keyModel : BaseModel? = BaseModel.init(dict: nil){
        didSet{
            mylog(keyModel)
        }
    
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.randomColor()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
