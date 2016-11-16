//
//  HomeVC.swift
//  mh824appWithSwift
//
//  Created by wangyuanfei on 16/8/24.
//  Copyright © 2016年 www.16lao.com. All rights reserved.
//

import UIKit
import MBProgressHUD
import AFNetworking
class HomeVC: VCWithNaviBar {

    func test()  {
        
        mylog( UIDevice.current.systemVersion)
        mylog( Float(UIDevice.current.systemVersion))

        if let  systemVersion = Float(UIDevice.current.systemVersion) {
            mylog("当前iOS版本为\(systemVersion)")
            if systemVersion <= 11.0 {
                mylog("10+")
            }else if (systemVersion <= 10.0){
                mylog("9+")
            }else if (systemVersion <= 9.0){
                mylog("8+")
            }else{
                mylog("8-")
            }

        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.viewDidLoad()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
         test()
        mylog(4/3)
        self.naviBar.backgroundColor  = UIColor.orange
        
//        NSLocalizedString(<#T##key: String##String#>, comment: <#T##String#>)//默认加载Localizable
//        NSLocalizedString(<#T##key: String##String#>, tableName: <#T##String?#>, bundle: <#T##Bundle#>, value: <#T##String#>, comment: <#T##String#>)
        
//        self.title = NSLocalizedString("tabBar_home", tableName: nil, bundle: Bundle.main, value:"", comment: "")
        self.view.backgroundColor = UIColor.randomColor()

        
        
        let leftBtn1 = UIButton(type: UIButtonType.contactAdd)
        naviBar.leftBarButtons = [leftBtn1]
        let rightBtn1 = UIButton(type: UIButtonType.contactAdd)
        naviBar.rightBarButtons = [rightBtn1]
        let navTitleView = NavTitleView()
        navTitleView.backgroundColor = UIColor.randomColor()
        navTitleView.insets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10);
        naviBar.navTitleView = navTitleView
        
        self.setupSuvViews()
        
        
        leftBtn1.addTarget(self, action: #selector(qrScanner), for: UIControlEvents.touchUpInside)
        // Do any additional setup after loading the view.
    }
    func qrScanner()  {
        let model = BaseModel.init(dict: ["actionkey" : "QRCodeScannerVC" as AnyObject])
        SkipManager.skip(viewController: self, model: model)
    }
    func setupSuvViews() -> () {
//        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.navigationController?.pushViewController(VCWithNaviBar.init(vcType: VCType.withBackButton), animated: true)
    }
    
    
    

    func gotData(_ type:LoadDataType ,success: (_ result:OriginalNetDataModel) -> () , failure : (_ error : NSError) ->() ) -> () {
        switch type {
        case .initialize:
            
            break
        case .reload:
            
            break
        case .loadMore:
            
            break
//            
//        default: break
        }
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
