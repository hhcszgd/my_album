//
//  ClassifyVC.swift
//  mh824appWithSwift
//
//  Created by wangyuanfei on 16/8/24.
//  Copyright © 2016年 www.16lao.com. All rights reserved.
//
import CoreData
import SpriteKit
import SceneKit
//class tt {
//    func test  ()  {
//        let a  = "{\"dfa\" : \"s\"}"
//        let sen = SKScene(fileNamed: "")
//        let v = SKView()
//        
//    }
//}
import UIKit

class ClassifyVC: GDNormalVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.yellow
        self.setupSence()
        self.setupNotification()
//        self.title = NSLocalizedString("tabBar_classify", tableName: nil, bundle: Bundle.main, value:"", comment: "")
//        UIColor(hexString: "#ffe700ff")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.showErrorView()
//        self.naviBar.currentBarStatus = .changing
//        mylog(self.naviBar.currentBarStatus)
//        mylog(self.naviBar.alpha)
//        
//        KeyVC.share.selectChildViewControllerIndex(index: 2)
//        /**    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:"]];*/
////        UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString) ?? URL(string: "http://www.baidu.com")! )
////        UIApplication.shared.openURL(URL(string: "appsetting") ?? URL(string: "http://www.baidu.com")! )
////        (UIApplication.shared.delegate as? AppDelegate)?.performChangeLanguage(targetLanguage: "LocalizableCH")//更改语言
////        URL(UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
//    }
    override func errorViewClick() {
        self.hiddenErrorView()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.navigationController?.pushViewController(VCWithNaviBar.init(vcType: VCType.withBackButton), animated: true)
//    }
    func setupSence ()  {
        let w  : CGFloat = 300.0
        let h : CGFloat  = 500.0
        let x = (self.view.bounds.size.width - w ) / 2
        let y = (self.view.bounds.size.height - h) / 2
        let spriteView = SKView(frame: CGRect(x: x, y: y, width: w, height: h))
        spriteView.backgroundColor = UIColor.blue
        spriteView.showsDrawCount = true    //显示绘制次数
        spriteView.showsNodeCount = true    //显示当前节点数 越少越好
        spriteView.showsFPS = true          //显示帧数
        
        let sence = GDScene(size: CGSize(width: spriteView.bounds.size.width, height: spriteView.bounds.size.height))
        //        sence.position = self.view.center // Setting the position of a SKScene has no effect.
        spriteView.presentScene(sence)
        self.view.addSubview(spriteView)
    }
    func classifyReclick()  {
        mylog("分类重复点击")
    }
    func setupNotification() {
        NotificationCenter.default.addObserver(self , selector: #selector(classifyReclick), name: GDClassifyTabBarReclick, object: nil)
    }
    deinit  {
        NotificationCenter.default.removeObserver(self)
    }
}
