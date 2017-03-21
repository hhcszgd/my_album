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
import MJRefresh
class HomeVC: GDNormalVC   {

    var mapView : GDMapInView? = GDMapInView()
    //override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    //    self.viewDidLoad()
    //}
    let testLabel = UILabel.init()

    func testxxx() {
        var count: UInt32 = 0
        let ivars = class_copyIvarList(GDBaseModel.self, &count)
        
        for i in 0 ..< count {
            let ivar = ivars![Int(i)]
            let name = ivar_getName(ivar)
            mylog(String(cString: name!))
        }
        free(ivars)
    }
    func testyyy() {
        var count: UInt32 = 3

        let objc_property_tS = class_copyPropertyList(GDBaseModel.self, &count)
        for i in 0 ..< count {
            let objc_property_tO = objc_property_tS![Int(i)]
            let name = property_getName(objc_property_tO)
            mylog(String(cString: name!))
        }
        free(objc_property_tS)
    }
    func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: NavigationBarHeight, left: 0, bottom: TabBarHeight, right: 0)
        
    }
    func testArchivSave()  {
        let dict = ["msg" : "从首页进行数据归档" , "status" : "200" , "data" : "success" , "additional" : "noneNULL" ]
        let a : OriginalNetDataModel = OriginalNetDataModel.init(dict: dict as [String : AnyObject])
        mylog(a.msg)
        a.save()
    }
    func testArchivRead()  {
        let a : OriginalNetDataModel = OriginalNetDataModel.read()
        mylog(a.msg)
         mylog(a.status)
    }
    func testLoginXMPP() {
        GDXmppManager.share.login(jidName: "wangyuanfei", password: "123456")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarItem.badgeValue = "345"
        mylog(self.tabBarItem.badgeValue)
       self.testyyy()
        self.testArchivSave()
        self.testLoginXMPP()
        self.setupNaviBar()
        self.setupTableView()
        self.setupNotification()
        
        self.testMapView()
        // Do any additional setup after loading the view.
    }

    
   
    func testMapView()  {
        
        let  map = GDMapInView(frame: CGRect(x: 0, y: 64, width: self.view.bounds.size.width, height: self.view.bounds.size.height - 49 - 64))
        self.mapView = map
        self.view.addSubview(self.mapView!)
    }
    func setupNotification() {
        NotificationCenter.default.addObserver(self , selector: #selector(homeTabBarReclick), name: GDHomeTabBarReclick, object: nil)
    }
    func setupNaviBar (){
        self.naviBar.backgroundColor  = UIColor.orange
        self.naviBar.currentBarActionType = .color//.alpha //.offset //
        self.naviBar.layoutType = .asc
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
        leftBtn1.addTarget(self, action: #selector(qrScanner), for: UIControlEvents.touchUpInside)
        rightBtn1.addTarget(self , action: #selector(rightBtnClick(sender:)), for: UIControlEvents.touchUpInside)
        
    }
    func rightBtnClick(sender : UIButton)  {
        //GDXmppManager.share.login(jidName: "wangyuanfei", password: "123456")
        self.navigationController?.pushViewController(GDRosterVC(), animated: true)
//        self.navigationController?.pushViewController(GDRecentRosterVC(), animated: true)
    }
    func homeTabBarReclick()  {
        //self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableViewScrollPosition.top, animated: true)
        self.tableView.mj_header.state = MJRefreshState.refreshing

    }
    func qrScanner()  {
        let model = GDBaseModel.init(dict: ["actionkey" : "QRCodeScannerVC" as AnyObject])
        GDSkipManager.skip(viewController: self, model: model)
        
//        let qrvc = QRCodeScannerVC(vcType: VCType.withBackButton)
//        qrvc.delegate = self
//        self.navigationController?.pushViewController(qrvc, animated: true )
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override  func sectionIndexTitles(for tableView: UITableView) -> [String]?{
        var arr = [String]()
        for   index in 0..<3  {
            arr.append(" \(index) ")
        }
        return arr
    }
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool{
        if indexPath.row == 0  {
            return true
        }else{
            return false 
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        self.mapView?.removeFromSuperview()
        self.mapView = nil
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                self.testArchivRead()
//        self.tableView.allowsMultipleSelection = true
//mylog(self.naviBar.isHidden)
        //self.tabBarItem.badgeValue = "432"
//mylog("首页的tabBarItem\(self.tabBarItem!)")
      //  self.tabBarController?.tabBarItem.badgeValue = "444"
//        self.tabBarController?.tabBar.selectedItem?.badgeValue = "ddd"
        //self.tabBarController?.tabBar.items?.last?.badgeValue = "ff"
//        KeyVC.share.mainTabbarVC?.selectedIndex = 2
//        KeyVC.share.selectChildViewControllerIndex(index: 2)
//                self.tableView.setEditing(true , animated: true )
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.scrollToNearestSelectedRow(at: UITableViewScrollPosition.middle, animated: true)

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 18
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.naviBar.change(by: scrollView)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.navigationController?.pushViewController(VCWithNaviBar.init(vcType: VCType.withBackButton), animated: true)
//         self.navigationController?.pushViewController(GDNormalVC(), animated: true)//测试控制器跳转,
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
     deinit  {
        NotificationCenter.default.removeObserver(self)
    }
}
