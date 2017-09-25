//
//  GDEditNameVC.swift
//  zjlao
//
//  Created by WY on 2017/9/25.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit

class GDEditNameVC: GDNormalVC {
    var customTitle : String!
    convenience init(title : String , originalValue : String){
        self.init()
        self.customTitle = title
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.setupNaviBar()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNaviBar()  {
        self.naviBar.backBtn.setImage(UIImage(named: "icon_classify_homepage"), for: UIControlState.normal)
        let  attritit = NSMutableAttributedString.init(string: self.customTitle)
        attritit.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: NSRange.init(location: 0, length: attritit.string.characters.count))
        self.naviBar.attributeTitle = attritit
        self.naviBar.backgroundColor = UIColor.black
        let btn = UIButton()
        btn.setTitle("...", for: UIControlState.normal)
        self.naviBar.rightBarButtons = [btn]
        btn.addTarget(self , action: #selector(save), for: UIControlEvents.touchUpInside)
    }
    @objc func save()  {
        
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
