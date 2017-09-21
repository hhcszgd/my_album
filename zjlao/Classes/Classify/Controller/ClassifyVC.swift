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
import MJRefresh

//class tt {
//    func test  ()  {
//        let a  = "{\"dfa\" : \"s\"}"
//        let sen = SKScene(fileNamed: "")
//        let v = SKView()
//        
//    }
//}
import UIKit

class ClassifyVC: GDNormalVC , GDCircleTrendsCellDelete{

    var currentPage : Int = 1
    var datas  : [GDCircleTrendsCellModel] = {
        
        var tempDatas = [GDCircleTrendsCellModel]()
        /*
        for index in 0...3{
            
            let cellDict = [
                /**
                 var names : String?
                 var num  : String?
                 var time  : String?
                 */
                "num":"2",
                "names":"安德鲁 尼欧+2",
                "time":"1秒前"
            ]
            let cellModel = GDCircleTrendsCellModel(dict: cellDict as [String : AnyObject]?)
            var items = [AnyObject]()
            for picIndex in 0...index{
                let picDict = ["imageUrl":"https://gd2.alicdn.com/imgextra/i2/419536424/TB2m6J6e9JjpuFjy0FdXXXmoFXa-419536424.jpg" ]
                let picModel = BaseControlModel(dict: picDict as [String : AnyObject]?)
                items.append(picModel)
            }
            cellModel.items = items
            tempDatas.append(cellModel)
        }
        */
        return tempDatas
    }()
    
    // MARK: 注释 : celldelegate
    func imageControlClick(model : BaseControlModel ,  imageControl : GDPicView){
//        mylog(model.title)
        if let circleID = model.title {
//            let model = GDBaseModel.init(dict: nil)
//            model.actionkey = "GDCircleDetailVC"
//            model.keyparamete = circleID as AnyObject?
//            GDSkipManager.skip(viewController: self , model: model)
//
            let dataModel = GDBaseModel.init(dict: nil )
            let selectedCircleID = circleID
//            self.selectedTitle = dataModel.circle_name ?? ""
//            if dataModel.permission == 1 {
                dataModel.actionkey = "GDCircleDetailVC2"
                let para = ["id" : selectedCircleID ] as [String : String]
                dataModel.keyparamete = para as AnyObject
                GDSkipManager.skip(viewController: self , model: dataModel)
//            }else{//输入密码再进
//                self.setupPwdInput()
//            }
        }
        
        
        
        
        
        
    }
//    let tableView = UITableView.init(frame: CGRect.init(x: 0, y: 20, width: GDDevice.width, height: GDDevice.height - 49.0 - 20 ), style: UITableViewStyle.plain)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.naviBar.backgroundColor = UIColor.black
//        self.naviBar.title = "好友动态"
        var attritit = NSMutableAttributedString.init(string: "好友动态")
        attritit.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: NSRange.init(location: 0, length: attritit.string.characters.count))
        self.naviBar.attributeTitle = attritit
        self.setupTableView()
        self.requestData(loadDataType: LoadDataType.initialize)
        self.setupNotification()
    }
    func setupNotification()  {
        NotificationCenter.default.addObserver(self , selector: #selector(refreshOrInit), name: NSNotification.Name.init("RefreshAfterBlockSomeoneInClassifyVC"), object: nil)
    }
    
    func setupTableView()  {
//        self.view.addSubview(self.tableView)
        self.tableView.frame =  CGRect.init(x: 0, y: 20, width: GDDevice.width, height: GDDevice.height - 49.0 - 20 )
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
//        self.tableView.delegate  = self
//        self.tableView.dataSource = self
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.mj_footer = GDRefreshGifFooter(refreshingTarget: self , refreshingAction: #selector(loadMore))
        self.tableView.mj_header = GDRefreshHeader(refreshingTarget: self, refreshingAction: #selector(refreshOrInit))
//        self.tableView.mj_header?.lastUpdatedTimeLabel.isHidden = true
    }
        func headerViewClick(sender:GDBaseControl)  {
        mylog("头视图点击")
    }
    override func loadMore () {
        self.requestData(loadDataType: LoadDataType.loadMore)
    }
    @objc func refreshOrInit()  {
        self.requestData(loadDataType: LoadDataType.initialize)
    }
    
    func requestData(loadDataType:LoadDataType)  {
        
        
        switch loadDataType {
        case LoadDataType.initialize , LoadDataType.reload:
            self.currentPage = 1
            break
        case LoadDataType.loadMore:
            self.currentPage = self.currentPage + 1
            break
        }
        
        
        GDNetworkManager.shareManager.getCircleTrends(page: "\(self.currentPage)", { (result ) in
            mylog("请求动态结果:\(result.status)")
            mylog(result.data)
            var tempDatas  : [GDCircleTrendsCellModel] = [GDCircleTrendsCellModel] ()
            
            /**
             {
             id = 1178;
             update_at = 31分钟前;
             areas = (
             北京市,
             );
             members = (
             JohnLock,
             );
             }
             */
            if let infoArr = result.data as? [[String : AnyObject]]{
                for infoDict in infoArr {
                    let cellModel = GDCircleTrendsCellModel.init(dict: nil)
                    if let mediaNum = infoDict["media_number"] as? String{
                        cellModel.num = mediaNum
                    }
                    if let mediaNum = infoDict["media_number"] as? NSNumber{
                        cellModel.num = "\(mediaNum)"
                    }
                    
                    if let time = infoDict["update_at"] as? String{
                        cellModel.time = time
                    }

                    
                    if let city = infoDict["city"] as? String{
                        cellModel.city = city
                    }
                    
//                    if let membersArr = infoDict["members"] as? [[String : AnyObject]]{
//                        var tempMembers = [BaseControlModel]()
//                        for memberDict in membersArr{
//                            let memberModel : BaseControlModel = BaseControlModel.init(dict: nil)
//
//                            if let name = memberDict["name"] as? String{
//                                memberModel.title = name
//                            }
//                            if let avatar = memberDict["avatar"] as? String{
//                                memberModel.imageUrl = avatar
//                            }
//                            if let id = memberDict["id"] as? String{
//                                memberModel.subTitle = id
//                            }
//                            tempMembers.append(memberModel)
//                        }
//                        cellModel.members = tempMembers
//
//                    }
                    
                    if let membersArr = infoDict["members"] as? [String]{
                        var tempMembers = [BaseControlModel]()
                        for memberName in membersArr{
                            let memberModel : BaseControlModel = BaseControlModel.init(dict: nil)
                            
                                memberModel.title = memberName
                         
                            tempMembers.append(memberModel)
                        }
                        cellModel.members = tempMembers
                        
                    }
                    if let mediasArr = infoDict["medias"] as? [[String : AnyObject]]{
                        var tempmedias = [BaseControlModel]()
                        for mediaDict in mediasArr{
                            let picModel : BaseControlModel = BaseControlModel.init(dict: nil)
                            if let thumbnail = mediaDict["thumbnail"] as? String{
                                picModel.imageUrl = thumbnail
                            }
                            if let circle_id = mediaDict["circle_id"] as? String{
                                picModel.title = circle_id
                            }
                            if let format = mediaDict["format"] as? String{
                                picModel.extensionTitle2 = format
                            }
                            
                            if let id = mediaDict["id"] as? String{
                                picModel.subTitle = id
                            }
                            tempmedias.append(picModel)
                        }
                        cellModel.pictures = tempmedias
                    }
                    
                    
                    
                    
                    tempDatas.append(cellModel)
                    
                }
                
                
                if(tempDatas.count == 0 ){
                    self.tableView.mj_header.endRefreshing()
                    self.tableView.mj_footer.state = MJRefreshState.noMoreData
                    return
                }
                switch loadDataType {
                case LoadDataType.initialize , LoadDataType.reload:
                    self.datas = tempDatas
                    break
                case LoadDataType.loadMore:
                    self.datas.append(contentsOf: tempDatas)
                    break
                }
                
                self.tableView.reloadData()
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.state = MJRefreshState.idle
            }else{
                self.tableView.mj_footer.state = MJRefreshState.noMoreData
            }
        }) { (error ) in
            mylog(error)
        }
    }
    
    
    
    
    
    
    
//    func requestData()  {
//        
//        GDNetworkManager.shareManager.getCircleTrends(page: "1", { (result ) in
//            mylog(result.status)
//            mylog(result.data)
//            var tempDatas  : [GDCircleTrendsCellModel] = [GDCircleTrendsCellModel] ()
//            if let infoArr = result.data as? [[String : AnyObject]]{
//                for infoDict in infoArr {
//                    let cellModel = GDCircleTrendsCellModel.init(dict: nil)
//                    if let mediaNum = infoDict["media_number"] as? String{
//                        cellModel.num = mediaNum
//                    }
//                    if let mediaNum = infoDict["media_number"] as? NSNumber{
//                        cellModel.num = "\(mediaNum)"
//                    }
//                    
//                    if let time = infoDict["update_at"] as? String{
//                        cellModel.time = time
//                    }
//                    
//                    if let membersArr = infoDict["member"] as? [[String : AnyObject]]{
//                        
//                        for memberDict in membersArr{
//                            let memberModel : BaseControlModel = BaseControlModel.init(dict: nil)
//                            
//                            
//                        }
//                        
//                    }
//                    
//                    
//                    if let mediasArr = infoDict["media"] as? [[String : AnyObject]]{
//                        var tempmedias = [BaseControlModel]()
//                        for mediaDict in mediasArr{
//                            let picModel : BaseControlModel = BaseControlModel.init(dict: nil)
//                            if let thumbnail = mediaDict["thumbnail"] as? String{
//                                picModel.imageUrl = thumbnail
//                            }
//                            tempmedias.append(picModel)
//                        }
//                        cellModel.items = tempmedias
//                    }
//                    
//                    
//                    
//                    
//                    tempDatas.append(cellModel)
//                    
//                }
//                self.datas = tempDatas
//                self.tableView.reloadData()
//                
//            }
//            
//            
//        }) { (error ) in
//            mylog(error)
//        }
//    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.datas.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCell(withIdentifier: "GDCircleTrendsCell")
        if cell == nil  {
            cell = GDCircleTrendsCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "GDCircleTrendsCell")
        }
        if let cellReal  = cell as? GDCircleTrendsCell {
            cellReal.model = self.datas[indexPath.row]
            cellReal.delete = self
            return cellReal
        }
        return cell!
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
//        let model = self.datas[indexPath.row]
        
        let margin : CGFloat = 1.0
        let topH : CGFloat = 44.0
        let picW : CGFloat = (SCREENWIDTH - 5 * margin ) / 4
        
        let picH : CGFloat = picW
        let rows = 1
        var bottomH : CGFloat = 0
        bottomH = topH + picH + CGFloat(rows + 1) * margin
        return bottomH
    }
    

    
    
    
    
    
    
    
}

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
    
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
*/
