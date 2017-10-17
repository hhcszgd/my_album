//
//  ShopCarVC.swift
//  mh824appWithSwift
//
//  Created by wangyuanfei on 16/8/24.
//  Copyright © 2016年 www.16lao.com. All rights reserved.
/*购物车在选择的时候 , 先通过商品的模型取出店铺id 进行店铺遍历 , 拿到匹配的店铺后 , 对店铺里的商品进行遍历 , 遍历到了就break跳出循环*/
/*在选择商品时的遍历方式  , 选择商品以后把选中的商品的模型放入 选中商品的字典 , 以商品购物车id为键 , 模型为值 , 然后刷新 , 在数据源方法里 , 已模型的购物车id为键 取模型 , 取到的话就设置当前模型的选中字段为true , 否则就是false */
/*在选择店铺时的遍历方式 , 选择店铺以后把店铺的模型放在 选中店铺的字典中 , 以店铺id为键 , 模型为值 , 然后刷新 , 再数据源方法里 , 优先以店铺id为键 ,取店铺模型 , 如果取到 , 就把店铺id对应的商品 选中状态为true ,else  执行选中商品时 数据源方法中的操作流程*/

/**点击编辑按钮批量加入收藏 和删除商品  ,  同时可以修改数量 和 属性 , 但测试不能侧滑*/
/**商品标题最多两行 , 规格上方紧挨着标题下方 , 无论是一行还是两行*/
/**规格右方始终有一个下拉按钮 , 以修改规格*/
/**失效商品以类店铺的形式展示出来*/
import UIKit
import MJRefresh
import SDWebImage
class ShopCarVC: GDBaseVC , UITableViewDelegate , UITableViewDataSource , GDTrendsCellDelegate ,  UICollectionViewDelegate , UICollectionViewDataSource {
    
    var iconView = UIImageView()
    var  editProfileIcon = UIImageView(image: UIImage(named: "camera_icon_white"))
    var nameLbl = UILabel.init()
    
    
    
    
    let headerViewH : CGFloat = 88
    var currentPage : Int = 1//媒体内容分页
    var friendPage : Int = 1
    var datas  : [GDTrendsCellModel] = {
        var tempDatas = [GDTrendsCellModel]()
        return tempDatas
    }()
    var friends = [BaseControlModel]()
    
    lazy var userCollection : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = CGSize(width: 44, height: 44)
        let temp = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        //        temp.isPagingEnabled = true
        temp.register(GDHomeUserCell.self , forCellWithReuseIdentifier: "GDHomeUserCell")
        return temp
    }()
    
    let tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: GDDevice.width, height: 0), style: UITableViewStyle.plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.headerView())
        self.setupTableView()
        self.requestData(loadDataType: LoadDataType.initialize)
        self.getFriends(loadDataType:LoadDataType.initialize)
        
    }
    
    
    func getFriends(loadDataType:LoadDataType)  {
        if loadDataType == LoadDataType.initialize || loadDataType == LoadDataType.reload{
            self.friendPage = 1
        }else{
            self.friendPage += 1
        }
        GDNetworkManager.shareManager.getFriends(page: friendPage, { (result) in
            mylog("获取好友\(result.status)")
            if let dictArr = result.data as? [[String : AnyObject]]{
                var tempFriendsArr = [BaseControlModel]()
                for dict in dictArr {
                    let userModel = BaseControlModel.init(dict: nil)
                    if let avatar = dict["avatar"] as? String{
                        userModel.imageUrl = avatar
                    }
                    if let id = dict["id"] as? String{
                        userModel.subTitle = id
                    }
                    tempFriendsArr.append(userModel)
                }
                if loadDataType == LoadDataType.initialize || loadDataType == LoadDataType.reload{
                    self.friends = tempFriendsArr
                }else{
                    self.friends.append(contentsOf: tempFriendsArr)
                }
                self.userCollection.reloadData()
            }
        }) { (error ) in
            
        }
        
        
        
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
        
        
        GDNetworkManager.shareManager.getPersonalHistory(page: "\(self.currentPage)" , createAt : nil , { (result ) in
            mylog("请求历史消息的状态码\(result.status)")
            mylog("请求历史消息的数据\(result.data)")
            
            var tempDatas  : [GDTrendsCellModel] = [GDTrendsCellModel] ()
            if let infoDict = result.data as? [String : AnyObject]{
                
                if let mediasArr = infoDict["medias"] as? [[String : AnyObject]]{
                    for mediaDict in mediasArr{
                        let cellModel = GDTrendsCellModel.init(dict: nil)
                        if let week = mediaDict["week"] as? String{
                            cellModel.w = week
                        }
                        if let create_at = mediaDict["create_at"] as? String{
                            cellModel.my = "\(create_at)"
                        }
                        if let month = mediaDict["month"] as? String{
                            cellModel.m = month
                        }
                        
                        if let year = mediaDict["year"] as? String{
                            cellModel.y = year
                        }
                        
                        if let day = mediaDict["day"] as? String{
                            cellModel.d = day
                        }

                        if let subMediasArr = mediaDict["media"] as? [[String : AnyObject]]{
                            var subDatas  : [BaseControlModel] = [BaseControlModel] ()
                            for subMediaDict in subMediasArr{
                                let picModel : BaseControlModel = BaseControlModel.init(dict: nil)
                                if let subthumbnail = subMediaDict["thumbnail"] as? String {
                                    picModel.imageUrl = subthumbnail
                                }
                                if let format = subMediaDict["format"] as? String{
                                    picModel.extensionTitle2 = format
                                }
                                if let circle_id = subMediaDict["circle_id"] as? String{
                                    picModel.title = circle_id
                                }else{
                                    picModel.title = Account.shareAccount.member_id
                                }
                                if let id = subMediaDict["id"] as? String{
                                    picModel.subTitle = id
                                }
                             
                                
                                subDatas.append(picModel)
                                
                            }
                            
                            cellModel.items = subDatas
                            
                        }
                        tempDatas.append(cellModel)
                        
                    }
                }
            }
            
            
            
            
            /////
            
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
            
            
            /////
//            self.datas = tempDatas
//            self.tableView.reloadData()
            
            
            
        }) { (error ) in
            mylog(error)
        }
        
    }
    func setupTableView()  {
        self.view.addSubview(self.tableView)
        self.tableView.frame =  CGRect.init(x: 0, y: self.headerViewH, width: GDDevice.width, height: GDDevice.height - 49.0 - self.headerViewH)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.delegate  = self
        self.tableView.dataSource = self
        self.tableView.mj_footer = GDRefreshGifFooter(refreshingTarget: self , refreshingAction: #selector(loadMore))
        self.tableView.mj_header = GDRefreshHeader(refreshingTarget: self, refreshingAction: #selector(refreshOrInit))
        
//        self.tableView.tableHeaderView = self.headerView()
    }
    func loadMore () {
        self.requestData(loadDataType: LoadDataType.loadMore)
    }
    func refreshOrInit()  {
        self.requestData(loadDataType: LoadDataType.initialize)
    }

    
    func headerView() -> GDBaseControl {
        let headerView = GDBaseControl(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH, height: self.headerViewH))
            let iconView = UIImageView.init(frame: CGRect(x: 0, y: headerView.bounds.size.height - 64, width: 64, height: 64))
//        iconView.image = UIImage.init(named: "bg_nohead")
        self.iconView = iconView
        iconView.sd_setImage(with: URL(string: Account.shareAccount.head_images ?? ""), placeholderImage: placePolderImage, options: [SDWebImageOptions.cacheMemoryOnly , SDWebImageOptions.retryFailed])
        headerView.addSubview(iconView)
        
        
        let  editProfileIcon = UIImageView(image: UIImage(named: "camera_icon_white"))
        editProfileIcon.contentMode = UIViewContentMode.scaleAspectFit
        editProfileIcon.frame = CGRect(x: 44, y: 70, width: 16, height: 16)
        self.editProfileIcon = editProfileIcon
        
        headerView.addSubview(editProfileIcon)
        
        
        
        
        let nameLbl = UILabel.init()
        nameLbl.textColor = UIColor.white
        self.nameLbl = nameLbl
        nameLbl.text = Account.shareAccount.name
        nameLbl.frame =  CGRect(x: iconView.bounds.size.width + 8, y: iconView.frame.minY, width: SCREENWIDTH - iconView.bounds.size.width - 8 , height: nameLbl.font.lineHeight)
        headerView.addSubview(nameLbl)
        headerView.backgroundColor = UIColor.black
        headerView.addTarget(self , action: #selector(headerViewClick(sender:)), for: UIControlEvents.touchUpInside)
        
        
        let margin : CGFloat = 10
        userCollection.delegate = self
        userCollection.dataSource = self
        userCollection.alwaysBounceVertical = false
        userCollection.showsHorizontalScrollIndicator = false
        userCollection.showsVerticalScrollIndicator = false
        userCollection.backgroundColor = UIColor.clear
        userCollection.frame = CGRect(x:  iconView.frame.maxX , y:  iconView.frame.maxY - 40 , width: SCREENWIDTH -  iconView.frame.maxX, height: 40)

        
        headerView.addSubview(userCollection)
        
        
        
        
        
        
        
        return headerView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getFriends(loadDataType:LoadDataType.initialize)
        
        
        iconView.sd_setImage(with: URL(string: Account.shareAccount.head_images ?? ""), placeholderImage: placePolderImage, options: [SDWebImageOptions.cacheMemoryOnly , SDWebImageOptions.retryFailed])
        nameLbl.text = Account.shareAccount.name
    }
    
    func headerViewClick(sender:GDBaseControl)  {
        mylog("头视图点击")
        let model = GDBaseModel.init(dict: nil )
        model.actionkey = "GDSetUserinfoVC"
        GDSkipManager.skip(viewController: self , model: model)
        
    }
    // MARK: 注释 : 代理
    func trendsCellItemClick(model : BaseControlModel ,  imageControl : GDPicView){
        mylog(model.title)
        if let circleID = model.title {
            let model = GDBaseModel.init(dict: nil)
            model.actionkey = "GDCircleDetailVC"
            model.keyparamete = circleID as AnyObject?
            GDSkipManager.skip(viewController: self , model: model)
            
        }
    }
    func trendsCellMoreClick(model : GDTrendsCellModel){
        mylog("点击更多")
        model.actionkey = "DayMediaDetailVC"
        model.keyparamete = Account.shareAccount.member_id as AnyObject
        GDSkipManager.skip(viewController: self , model: model)
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.datas.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCell(withIdentifier: "GDTrendsCell")
        if cell == nil  {
            cell = GDTrendsCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "GDTrendsCell")
        }
        if let cellReal  = cell as? GDTrendsCell {
            cellReal.model = self.datas[indexPath.row]
            cellReal.delegate = self 
            return cellReal
        }
        return cell!
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        let model = self.datas[indexPath.row]

        if model.items?.count == 0 || model.items == nil  {
            return 1
        }
        let margin : CGFloat = 3.0
        let topH : CGFloat = 44.0
        let picW : CGFloat = (SCREENWIDTH - 5 * margin ) / 4
        let picH : CGFloat = picW
//        var rows = ((model.items?.count)! + 1 ) /  4
//        let left = ((model.items?.count)! + 1 ) % 4
        var rows = (model.items?.count)!  /  4
        let left = (model.items?.count)! % 4
        var bottomH : CGFloat = 0
        if rows >= 3 {
            rows = 3
        }else{
            if  (left > 0 )  {
                rows = rows + 1
            }
        }
        bottomH = CGFloat(rows) * picW + CGFloat(rows + 1) * margin
        return topH + bottomH
    }
    
    
    
    
    
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        mylog(friends)
        return friends.count
    }
    
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{

        
            let item  = collectionView.dequeueReusableCell(withReuseIdentifier: "GDHomeUserCell", for: indexPath)
            if let cell  = item as? GDHomeUserCell {
                //set model
                cell.model = friends[indexPath.item]
                return cell
            }
        mylog(friends)

            return item
    }
    
    // MARK: 注释 : didSelect
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.userCollection {
            mylog("点击附近的人头像")
            let model = self.friends[indexPath.item]
            //            mylog("\(model.title)  \(model.subTitle)  \(model.imageUrl)")
            let skipModel = GDBaseModel.init(dict: nil )
            skipModel.actionkey = "GDUserHistoryVC"
            skipModel.keyparamete = model.subTitle as AnyObject//用户id
            GDSkipManager.skip(viewController: self , model: skipModel)
            
        }
    }
    
    
    
    
    
    
    /*
    
    var  currentIndexPath = IndexPath(row: 0, section: 0)
    var choosedIndexPaths = [String : IndexPath]()
    let editBtn = UIButton(imageName: "message", backImage: nil)
    let messageBtn  = UIButton(imageName: "message", backImage: nil)
    let shopDict = [String :AnyObject]()
    let goodDict = [String :AnyObject]()
    var datas = [0]
    
    func operatorTheSelectGoodOrShop(model: [String :AnyObject]) -> () {
        
        //优先遍历shopDict
        
        if let shopID =  model["shopID"] as? String  {//取出当前模型的shopid
            if  shopDict["shopID"] as! String == shopID {//先拿shopid 去shopdict字典取模型 ,1 如果取到 , 就设置当前model的select 为true    2 取不到 , 为false
                
            }else{//取不到的话 , 再拿当前模型的goodID当键  去gooddict 中取   , 1 ,取到 选中, 2 , 取不到 非选中
            
            }
        }else{
        
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.setupTableView()
        self.gotShopCarData(type: LoadDataType.initialize, { (model) in }) { (error ) in }
        self.setupNotification()
        let tempView =  UIView.init(frame: CGRect(x: 0, y: 64, width: SCREENWIDTH, height: 44))
            tempView.backgroundColor = UIColor.purple
            self.naviBar.addSubview(tempView);
        self.view.backgroundColor = UIColor.green
        GDKeyVC.share.settabBarItem(number: "6" , index: 3)
        GDKeyVC.share.settabBarItem(number: "", index: 4)

//        let images = [UIImage(named: "bg_collocation")!,UIImage(named: "bg_coupon")!,UIImage(named: "bg_Direct selling")!,UIImage(named: "bg_electric")!,UIImage(named: "bg_female baby")!,UIImage(named: "bg_franchise")!]
//         let header  =  GDRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
//        header?.lastUpdatedTimeLabel.isHidden = true
//        header?.setImages(images , for: MJRefreshState.idle)
//        header?.setImages(images , for: MJRefreshState.refreshing)
//        self.tableView.mj_header = header
//        let footer = GDRefreshGifFooter(refreshingTarget: self , refreshingAction: #selector(loadMore))
//        footer?.setImages(images , for: MJRefreshState.idle)
//        footer?.setImages(images , for: MJRefreshState.refreshing)
//        self.tableView.mj_footer = footer
    }

    override func setupContentAndFrame() {
        self.attritNavTitle = NSAttributedString.init(string: GDLanguageManager.titleByKey(key: LTabBar_shopcar));  
    }
    override func refresh ()  {
        self.tableView.mj_header.endRefreshing()
        self.tableView.mj_footer.state = MJRefreshState.idle
    }
    override func loadMore ()  {
        //self.tableView.mj_footer.endRefreshingWithNoMoreData()
        self.tableView.mj_footer.state = MJRefreshState.idle
        for _  in 0...4 {
            
            self.datas.append( self.datas.last ?? 0 + 1   )
        }
        self.tableView.insertRows(at: [IndexPath(row: self.datas.count-5, section: 0),IndexPath(row: self.datas.count-4, section: 0),IndexPath(row: self.datas.count-3, section: 0),IndexPath(row: self.datas.count-2, section: 0),IndexPath(row: self.datas.count-1, section: 0)], with: UITableViewRowAnimation.fade)
    }
    func setupNavigationBar() {
        
      self.naviBar.rightBarButtons = [editBtn , messageBtn]
        let someview = UIView.init(frame: CGRect(x: ( messageBtn.imageView?.bounds.size.width ?? 38) - 15, y:   0, width: 15, height: 15))
        someview.backgroundColor = UIColor.randomColor()
        messageBtn.imageView?.backgroundColor = UIColor.randomColor()
        messageBtn.imageView?.addSubview(someview)
    }
    func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: NavigationBarHeight, left: 0, bottom: TabBarHeight, right: 0)
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datas.count
    }
    //MARK: tableViewDelegate
    //func scrollViewDidScroll(_ scrollView: UIScrollView) {
     //   self.naviBar.change(by: scrollView)
    //}
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentStr = "\(indexPath.row)"
        if  let _ = self.choosedIndexPaths[currentStr] {//键能找到值
            self.choosedIndexPaths.removeValue(forKey: currentStr)
        }else{//找不到就加进去
            self.choosedIndexPaths[currentStr] = indexPath
        }
        
        
        self.currentIndexPath = indexPath
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentStr = "\(indexPath.row)"
        if  let _ = self.choosedIndexPaths[currentStr] {
            return 88
        }else{return 66}
        
    }
    //MARK:网络请求方法(初始化,刷新,加载更多)
    func gotShopCarData(type : LoadDataType , _ success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ()) {
        switch type {
        case .initialize , .reload:
            GDNetworkManager.shareManager.gotShopCarData({ (originalNetDataModel) in
                
                if (true){/**选项卡栏显示,布局*/
                    guard let dataAnyObj = originalNetDataModel.data else{
                        GDAlertView.alert("购物车为空", image: nil , time: 2, complateBlock: nil)
                        return
                    }
                }else{//如果隐藏
                
                }
                
            }) { (error) in
                mylog(error)
                GDAlertView.alert("购物车获取失败", image: nil , time: 2, complateBlock: nil)

            }
            break
     
        case .loadMore:
            
            break
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
//        alert("a;lskdjfla", image: UIImage(named:"icon_payfail")!, time: 2) {
            
//        }
//        GDAlertView.alert11(nil, image: nil, time: 2, complateBlock: nil)
        GDAlertView.alert("dalskdfj", image: nil, time: 2) {
            mylog("点击了购物车")
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
    func shopcarReclick() {
        self.tableView.mj_header.state = MJRefreshState.refreshing

        //self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableViewScrollPosition.top, animated: true)
    }
    func setupNotification() {
        NotificationCenter.default.addObserver(self , selector: #selector(shopcarReclick), name: GDShopcarTabBarReclick, object: nil)
    }
    deinit  {
        NotificationCenter.default.removeObserver(self)
    }
 */
}
