//
//  HomeVC2.swift
//  zjlao
//
//  Created by WY on 2017/9/9.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit

class HomeVC2: GDBaseVC {

    let autoScrollView = GDAutoScrollView.init(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width * 0.5))
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.black 
        self.prepareSubViews()
        let model0 =  BaseControlModel.init(dict: nil )
            model0.title = "0"
        let model1 =  BaseControlModel.init(dict: nil )
            model1.title = "1"
        let model2 =  BaseControlModel.init(dict: nil )
            model2.title = "2"
        let model3 =  BaseControlModel.init(dict: nil )
            model3.title = "3"
        let model4 =  BaseControlModel.init(dict: nil )
            model4.title = "4"
        let models = [model0 , model1 , model2 , model3 , model4]
        autoScrollView.models = models
        // Do any additional setup after loading the view.
    }
    func prepareSubViews()  {
        autoScrollView.backgroundColor = UIColor.red
        self.view.addSubview(autoScrollView)
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

}
