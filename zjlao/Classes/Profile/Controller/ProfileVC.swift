//
//  ProfileVC.swift
//  mh824appWithSwift
//
//  Created by wangyuanfei on 16/8/24.
//  Copyright © 2016年 www.16lao.com. All rights reserved.
//
//TODO: 消息按钮 固定不随tableView滚动
import UIKit
import MJRefresh
class ProfileVC: GDBaseVC , UITableViewDelegate , UITableViewDataSource , GDTrendsMsgCellDelegate{
    
    
    
    var currentPage : Int = 1

    let tipLbl1 = UILabel.init(frame: CGRect.zero)
    let tipLbl2 = UILabel.init(frame: CGRect.zero)
    var datas : [TrendsMsgCellModel] = [TrendsMsgCellModel]()
    lazy var tableView : UITableView = {
        let temp = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)//
        self.view.addSubview(temp)
        temp.dataSource = self
        temp.delegate = self
        temp.frame = CGRect(x: 0, y: 20, width: SCREENWIDTH, height: SCREENHEIGHT - 20 - 49)
        
        
//        let images = [UIImage(named: "bg_collocation")!,UIImage(named: "bg_coupon")!,UIImage(named: "bg_Direct selling")!,UIImage(named: "bg_electric")!,UIImage(named: "bg_female baby")!,UIImage(named: "bg_franchise")!]
        
        
//        let header  =  GDRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
//        header?.lastUpdatedTimeLabel.isHidden = true
//        header?.setImages(self.pullingImages , for: MJRefreshState.idle)
//        header?.setImages(self.refreshImages , for: MJRefreshState.refreshing)
//        temp.mj_header = header
//        let footer = GDRefreshGifFooter(refreshingTarget: self , refreshingAction: #selector(loadMore))
//        footer?.setImages(self.refreshImages , for: MJRefreshState.idle)
//        footer?.setImages(self.refreshImages , for: MJRefreshState.refreshing)
//        temp.mj_footer = footer
        return temp
        
    }()
    var pullingImages : [UIImage] = {
        var images = [UIImage(named: "pulling1")! , UIImage(named: "pulling2")! ,UIImage(named: "pulling3")! ,UIImage(named: "pulling4")! ,UIImage(named: "pulling5")! ,UIImage(named: "pulling6")! ,UIImage(named: "pulling7")! ]
        return images
        
    }()
    var   refreshImages:  [UIImage] = {
        //        var images = [UIImage]()
        //        for i in 1...34 {
        //            let formateStr = NSString(format: "%02d", i)
        //            let img = UIImage(named: "loading100\(formateStr)");
        //
        //            if img != nil  {
        //                images.append(img!)
        //            }
        //        }
        
        //        mylog(images.count)
        let images = [UIImage(named: "gdloading1")! , UIImage(named: "gdloading2")! ]
        return images
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.automaticallyAdjustsScrollViewInsets = false

        
        self.view.backgroundColor = UIColor.black
               // Do any additional setup after loading the view.
        
        self.requestData(loadDataType: LoadDataType.initialize)
        
    }
    func setupAboutQieziView(hasMessage : Bool)  {
        if   hasMessage{
            self.setupTable()
        }else{
            if tipLbl1.superview == nil && tipLbl2.superview == nil  {
                self.tipLbl1.text = "没有消息"
                self.tipLbl2.text = "你在茄子认识的人寄给你的消息"
                self.tipLbl1.font = GDFont.systemFont(ofSize: 17)
                self.tipLbl2.font = GDFont.systemFont(ofSize: 14)
                self.tipLbl1.textColor = UIColor.lightGray
                self.tipLbl2.textColor = UIColor.lightGray
                self.tipLbl1.sizeToFit()
                self.tipLbl2.sizeToFit()
                self.tipLbl1.frame = CGRect(x: (SCREENWIDTH - self.tipLbl1.bounds.size.width ) / 2, y: (SCREENHEIGHT - self.tipLbl1.bounds.size.height ) / 2, width: self.tipLbl1.bounds.size.width, height: self.tipLbl1.bounds.size.height)
                self.tipLbl2.frame = CGRect(x: (SCREENWIDTH - self.tipLbl2.bounds.size.width ) / 2, y:  self.tipLbl1.frame.origin.y + 28 , width: self.tipLbl2.bounds.size.width, height: self.tipLbl2.bounds.size.height)
                
                self.view.addSubview(self.tipLbl1)
                self.view.addSubview(self.tipLbl2)
            }
        }
    }
    
    
    
    func setupTable() {

//        let images = [UIImage(named: "bg_collocation")!,UIImage(named: "bg_coupon")!,UIImage(named: "bg_Direct selling")!,UIImage(named: "bg_electric")!,UIImage(named: "bg_female baby")!,UIImage(named: "bg_franchise")!]
//        
//        
//        let header  =  GDRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
//        header?.lastUpdatedTimeLabel.isHidden = true
//        header?.setImages(self.pullingImages , for: MJRefreshState.idle)
//        header?.setImages(self.refreshImages , for: MJRefreshState.refreshing)
//        self.tableView.mj_header = header
//        let footer = GDRefreshGifFooter(refreshingTarget: self , refreshingAction: #selector(loadMore))
//        footer?.setImages(self.refreshImages , for: MJRefreshState.idle)
//        footer?.setImages(self.refreshImages , for: MJRefreshState.refreshing)
//        self.tableView.mj_footer = footer
//        
        if self.tableView.mj_header == nil  {
            
            self.tableView.mj_footer = GDRefreshGifFooter(refreshingTarget: self , refreshingAction: #selector(loadMore))
            self.tableView.mj_header = GDRefreshHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
        }
        
        
        
        self.tableView.backgroundColor = UIColor.white
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    func refresh ()  {
        self.requestData(loadDataType: LoadDataType.reload)
        
    }
    func loadMore ()  {
        self.requestData(loadDataType: LoadDataType.loadMore)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    
        return self.datas.count
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileVCCell")
        if cell == nil  {
            let  creatCell = GDTrendsMsgCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "profileVCCell")
            let model = self.datas[indexPath.row]
            creatCell.model = model
            creatCell.msgCelldelegate = self
            return creatCell
            
        }else{
            if let realCell = cell as? GDTrendsMsgCell {
                let model = self.datas[indexPath.row]
                realCell.model = model
                realCell.msgCelldelegate = self
                return realCell
            }
        }
        return cell!
    }
    


    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 64.0 
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

        
        GDNetworkManager.shareManager.getReceivedTrends(page: self.currentPage , { (result ) in
            mylog("请求历史消息的状态码\(result.status)")
            mylog(result.data)
            if loadDataType ==  LoadDataType.initialize || loadDataType == LoadDataType.reload{
                self.datas.removeAll()
            }
            var tempDatas = [TrendsMsgCellModel]()
            if let dictArr = result.data as? [[String : AnyObject]]{
                
                for itemDict in dictArr{
                    let model = TrendsMsgCellModel.init(dict: itemDict)
                    tempDatas.append(model)
                }
            }
            if tempDatas.count == 0 {
                self.setupAboutQieziView(hasMessage:false)
                self.tableView.isHidden = true
                self.tipLbl2.isHidden = false
                self.tipLbl1.isHidden = false
            }else{
                self.setupAboutQieziView(hasMessage:true)
                self.tableView.isHidden = false
                self.tipLbl2.isHidden = true
                self.tipLbl1.isHidden = true
            }
            self.datas.append(contentsOf: tempDatas)
            
            switch loadDataType {
            case LoadDataType.initialize :
                break
            case  LoadDataType.reload:
                if self.tableView.mj_header != nil {
                
                    self.tableView.mj_header.endRefreshing()
                }
                break
            case LoadDataType.loadMore :
                if tempDatas.count > 0 {
                    self.tableView.mj_footer.state = MJRefreshState.idle
                }else{
                    self.tableView.mj_footer.state = MJRefreshState.noMoreData
                }
                break
            }
            self.tableView.reloadData()
        
        
            
        }) { (error ) in
            mylog(error)
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        GDKeyVC.share.mainTabbarVC?.tabBar.items?.last?.badgeValue = nil
        GDKeyVC.share.settabBarItem(number: nil , index: 4)
        self.requestData(loadDataType: LoadDataType.reload)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model  = self.datas[indexPath.row]
        model.actionkey = "GDMideaDetailVC"
        let keyParamete : [String : String ] = [ "mediaID":model.media_id ?? "" , "create_at" : model.media_create_at ?? "" , "id":model.id ?? ""]
        model.keyparamete = keyParamete as AnyObject
        GDSkipManager.skip(viewController: self , model: model)
        
    }
    
    
    
    // MARK: 注释 : cellDelegate
    func otherIconClick(view : GDTrendsMsgCell){
        if let userid  = view.model?.comment_user_id {
            self.gotoUserDetail(userID: userid)
        }
    }

    
    
    
    func gotoUserDetail(userID:String)  {
        //            mylog("\(model.title)  \(model.subTitle)  \(model.imageUrl)")
        let skipModel = GDBaseModel.init(dict: nil )
        skipModel.actionkey = "GDUserHistoryVC"
        skipModel.keyparamete =  userID as AnyObject //model.subTitle as AnyObject//用户id
        GDSkipManager.skip(viewController: self , model: skipModel)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
    let tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: GDDevice.width, height: GDDevice.height), style: UITableViewStyle.plain)
    var tableHeaderData : [AnyObject] {
        get{
            var tableHeaderModels = [AnyObject]()
            for item in totalData {
                guard let channelModel = item as? ProfileChannelModel else { continue}
                guard let key = channelModel.key else {continue}
                if key == "userinfo" {
                    tableHeaderModels.append(item)
                    break
                }
            }
            return tableHeaderModels
        }
        
    } //目前有个字典:头像,商品收藏,店铺收藏,我的足迹,用户等级
    var tableViewData : [AnyObject] {
        get{
            var tableModels = [AnyObject]()
            for item in totalData {
                guard let channelModel  = item as? ProfileChannelModel else { continue}
                guard let key = channelModel.key else {continue}
                
                switch key {
                case "order"  :
                    tableModels.append(channelModel)
                    break
                case "my_capital" :
                    tableModels.append(channelModel)
                    break
                case  "set"  :
                    tableModels.append(channelModel)
                    break
                case  "help" :
                    tableModels.append(channelModel)
                    break
                case "member_club" :
                    tableModels.append(channelModel)
                    break
                default: break
                }
            }
            return tableModels
        }
        
    }//有N个包含不同字段的字典
    var totalData = [AnyObject](){
        willSet {
            //            totalData = newValue
        }
        
        didSet {
            
            var tempchannelModels = [AnyObject]()
            for item in totalData {
                guard var dict = item as? [String : AnyObject] else { continue}
                var tempSubModels = [AnyObject]()
                guard let tempItems = dict["items"] else {
                    
                    
                    let profileChannelModel = ProfileChannelModel(dict: dict)
                    tempchannelModels.append(profileChannelModel)
                    continue
                }
                guard let items = tempItems as? [AnyObject] else {
                    continue
                }
                for subItem in items {
                    guard let tempSubItem = subItem as? [String : AnyObject] else {continue}
                    let subModel = ProfileSubModel(dict: tempSubItem)
                    tempSubModels.append(subModel)
                }
                dict["items"] = tempSubModels as AnyObject?
                
                let profileChannelModel = ProfileChannelModel(dict: dict)
                tempchannelModels.append(profileChannelModel)
            }
            
            
            
            totalData =  tempchannelModels
            
        }
        
    }//原始总数据 , 将会拆分成上面连个小数组
    func setupTableView() -> () {
        tableView.frame = CGRect(x: 0, y: 0, width: GDDevice.width, height: GDDevice.height);
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.separatorStyle=UITableViewCellSeparatorStyle.none
        let tableHeader = PTableHeaderView(frame: CGRect(x: 0, y: 0, width: GDDevice.width, height:  GDCalculator.GDAdaptation(200.0)))
        tableHeader.actionDelegate = self
        tableView.tableHeaderView = tableHeader
        
    }
    

    func performAction( model: GDBaseModel) {
         GDSkipManager.skip(viewController: self, model: model)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.gotData(.initialize, success: { (result) in
            
        }) { (error) in
            
        }

    }
    
    func gotData(_ type:LoadDataType ,success: (_ result:OriginalNetDataModel) -> () , failure : (_ error : NSError) ->() ) -> () {
        switch type {
        case .initialize:
            if Account.shareAccount.isLogin {
                GDNetworkManager.shareManager.gotProfilePageData({ (result) in//网络获取数据成功
                    guard let tempTotalData = result.data as? [AnyObject] else {return}
                    self.totalData = tempTotalData
                    mylog(self.totalData)
                    mylog(self.tableHeaderData)
                    mylog(self.tableViewData)
                    guard let headerView =  self.tableView.tableHeaderView as? PTableHeaderView else {return}
                    guard let headerModel = self.tableHeaderData.first as? ProfileChannelModel else {return}
                    headerView.headerChannelModel = headerModel//给头视图赋值
                    
                    self.tableView.reloadData()
                    
                }) { (error) in //网络失败时,从bundel读取数据
                    guard  let profileDictDataPath = gotResourceInSubBundle("ProfileData", type: "plist", directory: "Txt") else {
                        return
                    }
                    
                    if  let profileDictData = NSDictionary.init(contentsOfFile: profileDictDataPath){
                        
                        
                        let originalNetDataModel = OriginalNetDataModel.init(dict: profileDictData as! [String : AnyObject])
                        self.totalData = originalNetDataModel.data as! [AnyObject]
                        guard let headerView =  self.tableView.tableHeaderView as? PTableHeaderView else {return}
                        guard let headerModel = self.tableHeaderData.first as? ProfileChannelModel else {return}
                        headerView.headerChannelModel = headerModel//给头视图赋值
                        
                        self.tableView.reloadData()
                        mylog("网络获取失败,从硬盘获取个人中心数据")
                    }else {
                        mylog("从硬盘读取数据错误")
                    }
                    mylog(error)
                }
                
            }else{
                guard  let profileDictDataPath = gotResourceInSubBundle("ProfileData", type: "plist", directory: "Txt") else {
                    return
                }
                if  let profileDictData = NSDictionary.init(contentsOfFile: profileDictDataPath){
                    let originalNetDataModel = OriginalNetDataModel.init(dict: profileDictData as! [String : AnyObject])
                    self.totalData = originalNetDataModel.data as! [AnyObject]
                    guard let headerView =  self.tableView.tableHeaderView as? PTableHeaderView else {return}
                    guard let headerModel = self.tableHeaderData.first as? ProfileChannelModel else {return}
                    headerView.headerChannelModel = headerModel//给头视图赋值
                    
                    self.tableView.reloadData()
                    mylog("网络获取失败,从硬盘获取个人中心数据")
                }else {
                    mylog("从硬盘读取数据错误")
                }
            }
            break
        case .reload: //这个可以实现一下(看需求)
            
            break
        case .loadMore://这个没必要实现了
            
            break
            
//        default: break
        }
    }
    func setupNotification()  {
        NotificationCenter.default.addObserver(self , selector: #selector(profileTabbarBarReclick), name: GDProfileTabBarReclick, object: nil )
    }
    func profileTabbarBarReclick()  {
        
        mylog("个人中心重复点击")
    }
    deinit  {
        NotificationCenter.default.removeObserver(self)
    }
*/
}



/*


extension ProfileVC :  UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  let channelModel = self.tableViewData[indexPath.row] as? ProfileChannelModel {
            if let key = channelModel.key {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") {
                    if let trueCell = cell as? PtableViewCell {
                        trueCell.channelModel = channelModel
                        trueCell.subViewDelegate = self
                    }
                    
                    return cell
                }else{
                    /*
                    switch key {
                    case "order":
                        return  OrderCell.init(style: UITableViewCellStyle.default, reuseIdentifier: key)
                        
                        break
                    case "my_capital":
                        return  CapitalCell.init(style: UITableViewCellStyle.default, reuseIdentifier: key)
                        
                        break
                    case "set":
                        return  SetCell.init(style: UITableViewCellStyle.default, reuseIdentifier: key)
                        
                        break
                    case "help":
                        return  HelpCell.init(style: UITableViewCellStyle.default, reuseIdentifier: key)
                        
                        break
                    case "member_club":
                         return  ClubCell.init(style: UITableViewCellStyle.default, reuseIdentifier: key)
                        
                        break
                    default:
                         return  UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "systemCell")
                    }

                    */
                    
                    let cell = PtableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
                    cell.channelModel = channelModel
                    cell.subViewDelegate = self 
                    return cell
                }
                
            }
            
        }
        
        return  UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "systemCell")
        
        
        
        
//        if  let cell  : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") {
//            cell.backgroundColor = UIColor.randomColor()
//            return cell
//        }else{
//            let theCell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
//            theCell.backgroundColor = UIColor.randomColor()
//            return theCell
//        }
//        if
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard  let channelModel = self.tableViewData[indexPath.row] as? ProfileChannelModel else{return 0.000001}
        guard let key = channelModel.key else {return 0.0000001}
        let cacuModel = CaculateModel()
        
        cacuModel.headerHeight = 44 ;
        switch key {
        case "order" , "my_capital":
            cacuModel.toHeaderMargin = 1
            cacuModel.itemCount = 1 
            cacuModel.itemHeight = NavigationBarHeight
            cacuModel.bottomMargin = 10
            break
//        case "my_capital":
//            cacuModel.toHeaderMargin = 1
//            cacuModel.itemCount = 1
//            cacuModel.itemHeight = 80.0
//            cacuModel.toHeaderMargin = 1
//            
//            break
        case "set" , "help" , "member_club":
            cacuModel.bottomMargin = 1
            
            break
//        case "help":
//            
//            
//            break
//        case "member_club":
//            
//            
//            break
        default:
            break
        }
        
        
       return CaculateManager.newCaculateRowHeight(caculateModel: cacuModel)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        SkipManager.skip(viewController: self, model: BaseModel.init(dict: ["actionkey" : "goodscollect" as AnyObject]))
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.viewDidLoad()
    }
}
*/
