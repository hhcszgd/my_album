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
class ShopCarVC: GDBaseVC , UITableViewDelegate , UITableViewDataSource , GDTrendsCellDelegate {
    let customNaviBar  = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 64))
    let naviTitleLabel = UILabel.init()
    
    var iconView = UIButton()
    var  editProfileIcon = UIImageView(image: UIImage(named: "camera_icon_white"))
    var nameLbl = UILabel.init()
    var descripLabel = UILabel()
    
    var friend = TxtAndTxtView()
    var message = TxtAndTxtView()
    var setting = ShopCarView()
    var print = ShopCarView()
    
    
    
    
    let tableHeaderView : UIView = UIView()
    
    
    var currentPage : Int = 1//媒体内容分页
    var datas  : [GDTrendsCellModel] = {
        var tempDatas = [GDTrendsCellModel]()
        return tempDatas
    }()
    let tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: GDDevice.width, height: 0), style: UITableViewStyle.plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        
        self.setupTableView()
        self.setupNaviBar()
        self.requestData(loadDataType: LoadDataType.initialize)
    }
    func setupTableView()  {
        self.setupTableHeaderView()
        self.view.addSubview(self.tableView)
        self.tableView.frame =  CGRect.init(x: 0, y: 20, width: GDDevice.width, height: GDDevice.height - 49.0 - 20  )
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.delegate  = self
        self.tableView.dataSource = self
        self.tableView.tableHeaderView = self.tableHeaderView
        self.tableView.backgroundColor = UIColor.white
        self.tableView.mj_footer = GDRefreshGifFooter(refreshingTarget: self , refreshingAction: #selector(loadMore))
        self.tableView.mj_header = GDRefreshHeader(refreshingTarget: self, refreshingAction: #selector(refreshOrInit))
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            self.navigationController?.automaticallyAdjustsScrollViewInsets = false
        }
        //        self.tableView.tableHeaderView = self.headerView()
    }
    func setupNaviBar() {
        naviTitleLabel.text = Account.shareAccount.name
        naviTitleLabel.sizeToFit()
        naviTitleLabel.textColor = UIColor.white
        naviTitleLabel.center = CGPoint(x: self.customNaviBar.center.x, y: self.customNaviBar.center.y + naviTitleLabel.bounds.height/2)
        self.customNaviBar.addSubview(naviTitleLabel)
        self.customNaviBar.backgroundColor = UIColor.black
        self.customNaviBar.alpha = 0
        self.view.addSubview(self.customNaviBar)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        mylog(scrollView.contentOffset.y)
        let trigerValue = tableHeaderView.bounds.size.height
        if scrollView.contentOffset.y < 0 {
            self.customNaviBar.alpha = 0
        }else if scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y <= trigerValue{
            let scale = scrollView.contentOffset.y / (trigerValue - 64)
            mylog(scale)
            mylog(trigerValue)
            self.customNaviBar.alpha = scale
        }else{
            self.customNaviBar.alpha = 1
        }
    }
    func setupTableHeaderView()  {
        self.tableHeaderView.backgroundColor = UIColor.white
        self.tableHeaderView.frame  = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 128 + 4 /*4 是header末端间隔*/)
        ///:间隔
        let jiange = UIView.init(frame: CGRect(x: 0, y: 64, width: tableHeaderView.bounds.width, height: 1))
        jiange.backgroundColor = UIColor.lightGray
        tableHeaderView.addSubview(jiange)
        
        
        
        
        ///:头像姓名等
        tableHeaderView.addSubview(nameLbl)
        tableHeaderView.addSubview(descripLabel)
        tableHeaderView.addSubview(iconView)
        tableHeaderView.addSubview(editProfileIcon)
        nameLbl.text = Account.shareAccount.name
        descripLabel.text = "this is description"
        descripLabel.font = GDFont.systemFont(ofSize: 14)
        
        
        if let url  =  URL(string: Account.shareAccount.head_images ?? ""){
            iconView.sd_setImage(with:url, for: UIControlState.normal)
        }else{
            iconView.setImage(UIImage(named:"icon_set up"), for: UIControlState.normal)
        }
        editProfileIcon.image = UIImage(named: "icon_set up" )
        iconView.frame = CGRect(x: tableHeaderView.bounds.width - 10 - 44, y: 10 , width: 44 , height: 44)
        editProfileIcon.frame = CGRect(x: iconView.frame.maxX - 10 , y: iconView.frame.maxY - 10 , width: 10 , height: 10 )
        nameLbl.frame = CGRect(x: 10, y: 10, width: iconView.frame.minX - 10 , height: 20)
        descripLabel.frame = CGRect(x: 10, y: nameLbl.frame.maxY, width: iconView.frame.minX - 10 , height: 20)
        
        
        
        
        ///:消息好友设置等
        self.setTxtAndTxt(view: self.friend, x: 0, y: jiange.frame.maxY, topTitle: "0", bottomTitle: "好友")
        self.setTxtAndTxt(view: self.message, x: friend.frame.maxX, y: jiange.frame.maxY, topTitle: "0", bottomTitle: "消息")
        self.setImgTxtView(imgTxt: self.setting, x: message.frame.maxX, y: jiange.frame.maxY, imgName: "icon_set up", bottomTitle: "设置")
        self.setImgTxtView(imgTxt: print, x: setting.frame.maxX, y: jiange.frame.maxY, imgName: "icon_set up", bottomTitle: "打印")
        
        ///:间隔2
        let jiange2 = UIView.init(frame: CGRect(x: 0, y: 128, width: tableHeaderView.bounds.width, height: 1))
        jiange2.backgroundColor = UIColor.lightGray
        tableHeaderView.addSubview(jiange2)
        
        
    }
    func setTxtAndTxt(view:TxtAndTxtView ,x : CGFloat , y : CGFloat , topTitle:String , bottomTitle:String)  {
        let subW = tableHeaderView.bounds.width  / 4
        view.frame = CGRect(x: x, y: y , width: subW, height: 63)
        view.topTitle = topTitle
        view.bottomTitle = bottomTitle
        self.tableHeaderView.addSubview(view)
    }
    func setImgTxtView(imgTxt:ShopCarView ,x : CGFloat,y : CGFloat, imgName : String , bottomTitle:String)  {
        self.tableHeaderView.addSubview(imgTxt)
        imgTxt.bottomTitle = bottomTitle
        imgTxt.image = UIImage(named: imgName)
        imgTxt.frame = CGRect(x: x, y: y, width: tableHeaderView.bounds.width  / 4, height: 63)
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
            mylog("请求历史消息的数据\(String(describing: result.data))")
            
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
            
        }) { (error ) in
            mylog(error)
        }
        
    }

    func loadMore () {
        self.requestData(loadDataType: LoadDataType.loadMore)
    }
    func refreshOrInit()  {
        self.requestData(loadDataType: LoadDataType.initialize)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        iconView.sd_setImage(with: URL(string: Account.shareAccount.head_images ?? ""), placeholderImage: placePolderImage, options: [SDWebImageOptions.cacheMemoryOnly , SDWebImageOptions.retryFailed])
//        nameLbl.text = Account.shareAccount.name
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
        let margin : CGFloat = 1.0
        let topH : CGFloat = 44.0
        let picW : CGFloat = (SCREENWIDTH - 5 * margin ) / 4
//        let picH : CGFloat = picW
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
    
}


class ShopCarView: GDBaseControl {
    
    /*
     lazy var titleLabel = UILabel()//底部标题
     lazy var subTitleLabel = UILabel()//头部数量标题
     lazy var imageView = UIImageView()//图片视图
     lazy var additionalLabel = UILabel()//额外的文字标题(bedge数量)
     */
    
    let container = UIView()
    
    var model  = ProfileSubModel(dict:nil) {
        didSet{
            //当图片为网络图片链接时
            //当图片不是网络链接时
            if model.localImgName != nil {
                if let imgName = model.localImgName {
                    self.imageView.image = UIImage(named: imgName)
                }
            }else{
                //                self.imageView.sd_setImage(with: imgStrConvertToUrl("服务器图片地址"))//
            }
            //            self.topTitleLabel.text = "\(model.number)"
            self.subTitleLabel.text = model.name
//                        self.setNeedsLayout()
//                        self.layoutIfNeeded()
        }
        
    }
    var bottomTitle : String?{
        didSet{
            self.subTitleLabel.text = bottomTitle ?? "nil"
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    var image : UIImage?{
        didSet{
            self.imageView.image = image ?? UIImage()
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //        self.backgroundColor = UIColor.randomColor()
        self.addSubview(self.container)
        self.container.addSubview(self.imageView)
        self.imageView.contentMode = UIViewContentMode.scaleAspectFit
        
        self.subTitleLabel.font = GDFont.systemFont(ofSize: 14)//UIFont.systemFont(ofSize: 14*SCALE)
        self.subTitleLabel.textColor = UIColor.lightGray
        self.subTitleLabel.textAlignment = NSTextAlignment.center
        self.container.addSubview(self.subTitleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let  selfW = self.bounds.size.width
        let  selfH = self.bounds.size.height
        
        var containerW : CGFloat = 0.0
        var  containerH : CGFloat = 0.0
        if selfW < selfH {
            containerW = selfW
            containerH = containerW
        }else {
            
            containerH = selfH
            containerW = containerH
        }
        self.container.bounds = CGRect(x: 0, y: 0, width: containerW, height: containerH)
        self.container.center = CGPoint(x: selfW/2, y: selfH/2)
        
        //        self.bottomTitleLabel.sizeToFit()
        let margin : CGFloat = 5.0 ;
        let bottomTitleW =  selfW
        let bottomTitleH = self.subTitleLabel.font.lineHeight
        //        let bottomTitleX : CGFloat = 0.0 ;
        let bottomTitleY = selfH - bottomTitleH - margin
        
        let leftH = self.container.bounds.size.height - margin * 3 - bottomTitleH //conainer的剩余高度
        
        let imageViewH = leftH * 0.7
        let imageViewW = imageViewH
        //        let imageViewX = margin
        let imageViewY = margin * 2
        
        self.imageView.frame = CGRect(x: 0, y: 0, width: imageViewW, height: imageViewH)
        self.imageView.center = CGPoint(x: self.container.bounds.size.width/2, y: imageViewY + imageViewH/2)
        self.subTitleLabel.bounds = CGRect(x: 0, y: 0, width: bottomTitleW, height: bottomTitleH)
        self.subTitleLabel.center = CGPoint(x: self.container.bounds.size.width/2, y: bottomTitleY + bottomTitleH/2)
        
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}

