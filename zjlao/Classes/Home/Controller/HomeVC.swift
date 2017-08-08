//
//  HomeVC.swift
//  mh824appWithSwift
//
//  Created by wangyuanfei on 16/8/24.
//  Copyright © 2016年 www.16lao.com. All rights reserved.
//
let homeBackgroundColor = UIColor.init(hexString:"#353434")
//let contentBackgroundColor = UIColor.white
let contentBackgroundColor = UIColor.init(colorLiteralRed: 0.98, green: 0.98, blue: 0.95, alpha: 1)
let homeTextColor = UIColor.white
import UIKit
import MBProgressHUD
import AFNetworking
import MJRefresh
import AVKit
import Social
class HomeVC: GDBaseVC , UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewCellClick , GDPageControlDelegate{

    //override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    //    self.viewDidLoad()
    //}
//    var previousOffset : CGPoint = CGPoint.zero
    let pageControl : GDPageControl = GDPageControl.init()
    let newcircleLbl : UILabel = UILabel()
    let nameScrollView : UIScrollView = UIScrollView()
    var needReload = false
    var scrollPosition  : Int = 0
    let blackStatusBar = UIView(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH, height: 20))
    
    
    /*圈子id为键 , 取相应的值*/
    var subImagesDict : [String : [BaseControlModel]] =  [String : [BaseControlModel]](){/*每个圈子里的媒体字典集合*/
        willSet{
            for(key,value) in newValue.enumerated() {
                mylog("圈子id\(key)单v c个圈子图片集合\(value)")
            }
        }
        
    }

    var membersDict : [String : [BaseControlModel]] =  [String : [BaseControlModel]](){/*圈子里的 成员模型 字典集合*/
        willSet{
    
        }
    }
    var selectedsDict : [String : BaseControlModel] = [String : BaseControlModel](){/*每个圈子选中媒体的 字典集合*/
        willSet{
            
        }
        
    }
    var circleModels  : [BaseControlModel] = [BaseControlModel](){//圈子模型集合(装着圈子id)

        didSet{
            var isContainPreviousUploadMediaCircle = false
            var targetIndex : Int = 0
            
            for ( index ,cielceModel) in circleModels.enumerated() {
                if cielceModel.title == GDKeyVC.share.currentCircleID  {
                    isContainPreviousUploadMediaCircle = true
                    targetIndex = index
                }
            }
            if isContainPreviousUploadMediaCircle {
                self.scrollPosition = targetIndex
            }else{self.scrollPosition = 0}
            
            
            mylog(self.scrollPosition)
            mylog(GDKeyVC.share.currentCircleID)
            
            self.subImagesDict.removeAll()
            self.pageControl.numberOfPages = circleModels.count
            self.circleCollection.reloadData()
            
            self.circleCollection.scrollToItem(at: IndexPath.init(item: self.scrollPosition, section: 0), at: UICollectionViewScrollPosition.left, animated: false)
            let contentoffset = self.circleCollection.contentOffset
            let change  = [NSKeyValueChangeKey.newKey : contentoffset]
            self.pageControl.observeValue(forKeyPath: "contentOffset", of: nil , change: change, context: nil )
            
        }
    }
    
    var circleMembers  : [BaseControlModel] = [BaseControlModel](){//当前展示的单个圈子里成员的 数组集合
        didSet{//动态设置附近的人现实还是隐藏
//            let prefixStr = "\(circleMembers.count) 📷"
            var attriStr = NSMutableAttributedString.init(string: "\(circleMembers.count) ")
            let attach = NSTextAttachment()
            attach.image = UIImage.init(named: "camera_icon_white")
            let attachStr = NSAttributedString.init(attachment: attach)
            attriStr.append(attachStr)
            attach.bounds = CGRect(x: 0, y: -self.newcircleLbl.font.lineHeight * 0.2, width: self.newcircleLbl.font.lineHeight * 1.2, height: self.newcircleLbl.font.lineHeight)
            

            var usersStr : String = ""
            if circleMembers.count > 0  {
                usersStr = " "
            }
//            mylog(circleMembers.first?.title)

            for (index , model)  in circleMembers.enumerated() {
//                mylog(model.title)
//                mylog(model.subTitle)
//                mylog(model.imageUrl)
                if let nameStr  = model.title {
                   usersStr = usersStr.appending(nameStr)
                    if index < circleMembers.count - 1 {
                        usersStr = usersStr.appending("&")
                    }
//                    usersStr.append(nameStr)
                }
            }
            if  usersStr.isEmpty && circleMembers.count == 0 {
                self.newcircleLbl.text = "拍照建立新圈子"
                self.newcircleLbl.sizeToFit()
                nameScrollView.contentSize = CGSize(width: SCREENWIDTH, height: 44)
                self.newcircleLbl.center = CGPoint(x: self.nameScrollView.bounds.size.width/2, y: nameScrollView.bounds.size.height / 2)
            }else{
//                usersStr = prefixStr.appending(usersStr)
                attriStr.append(NSAttributedString.init(string: usersStr))
                //                usersStr = usersStr.appending("&手动拼接数据用来测试成员过多可滚动")
//                self.newcircleLbl.text = usersStr
                self.newcircleLbl.attributedText = attriStr
                self.newcircleLbl.sizeToFit()
                
                if self.newcircleLbl.bounds.size.width > self.nameScrollView.bounds.size.width {
                    nameScrollView.contentSize = CGSize(width: self.newcircleLbl.bounds.size.width, height: 44)
                    //                    self.newcircleLbl.center = CGPoint(x: 0, y: nameScrollView.bounds.size.height / 2)
                    self.newcircleLbl.frame = CGRect(x: 0, y: (self.nameScrollView.bounds.size.height - self.newcircleLbl.bounds.size.height ) / 2, width: self.newcircleLbl.bounds.size.width, height: self.newcircleLbl.bounds.size.height)
                    self.nameScrollView.contentOffset = CGPoint(x: 0, y: 0 )
                /*
                usersStr = prefixStr.appending(usersStr)
//                usersStr = usersStr.appending("&手动拼接数据用来测试成员过多可滚动")
                self.newcircleLbl.text = usersStr
                self.newcircleLbl.sizeToFit()
                
                if self.newcircleLbl.bounds.size.width > self.nameScrollView.bounds.size.width {
                    nameScrollView.contentSize = CGSize(width: self.newcircleLbl.bounds.size.width, height: 44)
                    //                    self.newcircleLbl.center = CGPoint(x: 0, y: nameScrollView.bounds.size.height / 2)
                    self.newcircleLbl.frame = CGRect(x: 0, y: (self.nameScrollView.bounds.size.height - self.newcircleLbl.bounds.size.height ) / 2, width: self.newcircleLbl.bounds.size.width, height: self.newcircleLbl.bounds.size.height)
                    self.nameScrollView.contentOffset = CGPoint(x: 0, y: 0 )
                    */
                    
                }else{
                    
                    nameScrollView.contentSize = CGSize(width: SCREENWIDTH, height: 44)
                    self.newcircleLbl.center = CGPoint(x: nameScrollView.bounds.size.width / 2, y: nameScrollView.bounds.size.height / 2)
                    
                }
                
            }
//            self.userCollection.reloadData()
        }
    }
    
    var nearbyUserModels  : [BaseControlModel] = [BaseControlModel](){//附近的人的模型 模型数组集合
        didSet{//动态设置附近的人现实还是隐藏
            self.userCollection.reloadData()
        }
    }
    lazy var circleCollection : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0 
        flowLayout.itemSize = CGSize(width: SCREENWIDTH, height: SCREENWIDTH * 0.96 )
        let temp = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        temp.isPagingEnabled = true
        temp.register(GDHomeCircleCell.self , forCellWithReuseIdentifier: "GDHomeCircleCell")
        return temp
    }()
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

    let nearbyUserTitle = UIButton()
    let nearbyCircleTitle = UIButton()
    let noBodyTitle = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self , selector: #selector(uploadMediaSuccessCallback), name: GDNetworkManager.GDUpLoadMediaSuccess, object: nil)
        NotificationCenter.default.addObserver(self , selector: #selector(getNearbyCircles), name: GDLocationManager.GDLocationChanged, object: nil)
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = homeBackgroundColor
        self.prepareTitlesView()
        self.setupCollection()
        self.setupPageControl()
        self.setupOtherSubviews()
        self.getNearbyCircles()
        self.blackStatusBar.backgroundColor = UIColor.black
        self.view.addSubview(self.blackStatusBar)
        
    }
    func prepareTitlesView()  {
        self.nearbyUserTitle.titleLabel?.font = GDFont.systemFont(ofSize: 17)
        self.nearbyCircleTitle.titleLabel?.font = GDFont.systemFont(ofSize: 17)
        self.view.addSubview(nearbyUserTitle)
        nearbyUserTitle.setTitleColor(homeTextColor, for: UIControlState.normal)
        self.view.addSubview(nearbyCircleTitle)
        nearbyCircleTitle.setTitleColor(homeTextColor, for: UIControlState.normal)
        self.view.addSubview(noBodyTitle)
        noBodyTitle.setTitleColor(homeTextColor, for: UIControlState.normal)
        
        nearbyUserTitle.setImage(UIImage(named: "neaybyuserIcon"), for: UIControlState.normal)
//        nearbyUserTitle.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        nearbyCircleTitle.setImage(UIImage(named: "neaybycircleIcon"), for: UIControlState.normal)
//        nearbyCircleTitle.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        noBodyTitle.setTitle("您附近还没有人使用茄子,赶紧推荐好友来使用吧", for: UIControlState.normal)
        
        nearbyUserTitle.setTitle("附近的人", for: UIControlState.normal)
        nearbyCircleTitle.setTitle("附近的圈子", for: UIControlState.normal)

        noBodyTitle.titleLabel?.font = GDFont.systemFont(ofSize: 14)
        nearbyCircleTitle.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        nearbyUserTitle.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        noBodyTitle.adjustsImageWhenHighlighted = false
        nearbyCircleTitle.adjustsImageWhenHighlighted = false
        nearbyUserTitle.adjustsImageWhenHighlighted = false
        let margin : CGFloat = 10
        if UIScreen.main.bounds.size.width == 320 && UIScreen.main.bounds.size.height == 480 {
            self.nearbyUserTitle.frame = CGRect(x: margin, y: 30, width: SCREENWIDTH - margin, height: 20)
        }else{
        self.nearbyUserTitle.frame = CGRect(x: margin, y: 30, width: SCREENWIDTH - margin, height: 30)
        }
        self.noBodyTitle.frame = self.nearbyCircleTitle.frame
        self.noBodyTitle.isHidden = true
        
    }
    func uploadMediaSuccessCallback()  {
        self.needReload = true
        if self.navigationController?.visibleViewController == self  {
            self.needReload = false
            self.getNearbyCircles()
        }
    }
    
    func requestDataAfterUploadMediaSuccess()  {
        if needReload {
            needReload = false
            self.getNearbyCircles()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestDataAfterUploadMediaSuccess()
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        if let path = Bundle.main.path(forResource: "Movie", ofType: "m4v") {
//              let url  = URL.init(fileURLWithPath: path )
//            let avPlayer : AVPlayer = AVPlayer.init(url: url)
//            let avPlayerVC : AVPlayerViewController  = AVPlayerViewController.init()
//            avPlayerVC.player = avPlayer
//            self.present(avPlayerVC, animated: true  , completion: { })
//        }

//        if  let url  = URL.init(string: "http://devimages.apple.com/iphone/samples/bipbop/gear1/prog_index.m3u8") {
//            let avPlayer : AVPlayer = AVPlayer.init(url: url)
//            let avPlayerVC : AVPlayerViewController  = AVPlayerViewController.init()
//            avPlayerVC.player = avPlayer
//            self.present(avPlayerVC, animated: true  , completion: { 
//                
//            })
//            
//        }
        
//        let a = TestCustomVC()
//        GDKeyVC.share.pushViewController(a, animated: true )
//        self.test1()
    
    }
    func testShare() {
        // 要分享的图片
        let image = UIImage.init(named: "logoPressed")!
        // 要分享的文字
        let str = "茄子媒体分享"
        let url : URL = URL(string : "http://123qz.cn/share.html")!
        // 将要分享的元素放到一个数组中
        let postItems = [ image, str , url] as [Any]
        let activityVC = UIActivityViewController.init(activityItems: postItems, applicationActivities: nil)
        
        // 在展现 activityVC 时，必须根据当前的设备类型，使用适当的方法。在iPad上，必须通过popover来展现view controller。在iPhone和iPodtouch上，必须以模态的方式展现。
        //        if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
        //            UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityVC];
        //            [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        //        } else {
        self.present(activityVC, animated: true , completion: nil)
        //        }
        
    }
    
    /*
    func testShare() {
        // 要分享的图片
//        let image = UIImage.init(named: "logoPressed")
        // 要分享的文字
        let str = "https://123qz.cn/share.html"
        // 将要分享的元素放到一个数组中
        let postItems = [ str] as [Any]
        let activityVC = UIActivityViewController.init(activityItems: postItems, applicationActivities: nil)

        // 在展现 activityVC 时，必须根据当前的设备类型，使用适当的方法。在iPad上，必须通过popover来展现view controller。在iPhone和iPodtouch上，必须以模态的方式展现。
//        if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
//            UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityVC];
//            [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
//        } else {
        self.present(activityVC, animated: true , completion: nil)
//        }
        
    }
    */
    func test1() {
        //        AVPlayerViewController
        let player = AVPlayer.init(url: URL.init(string: "http://devimages.apple.com/iphone/samples/bipbop/gear1/prog_index.m3u8")!)
        player.play()
        
        let layer = AVPlayerLayer.init(player: player)
//        layer.contents
        mylog(layer.videoRect)
        self.view.layer.addSublayer(layer)
        layer.backgroundColor = UIColor.red.cgColor
        layer.bounds = CGRect(x: 0, y: 20, width: 200 , height: 200 )
        layer.position = CGPoint(x: SCREENWIDTH/2, y: SCREENHEIGHT/2)
        mylog(layer.videoRect)
        if #available(iOS 9.0, *) {
            let _ =  AVPictureInPictureController.init(playerLayer: layer)
//            self.navigationController?.present(a , animated: true , completion: nil )
        } else {
            // Fallback on earlier versions
        }
        
        
    }
    func test2() {
           let b =       AVPlayerViewController.init()
        let player = AVPlayer.init(url: URL.init(string: "http://f0.ugshop.cn/media/130/149561157310681.MOV")!)
        b.player = player
        player.play()
        if #available(iOS 9.0, *) {
            b.allowsPictureInPicturePlayback = true
        } else {
            // Fallback on earlier versions
        }
        self.present(b , animated: true , completion: nil )
        
//        let layer = AVPlayerLayer.init(player: player)
//        mylog(layer.videoRect)
//        self.view.layer.addSublayer(layer)
//        layer.backgroundColor = UIColor.red.cgColor
//        layer.bounds = CGRect(x: 0, y: 20, width: SCREENWIDTH / 2 , height: SCREENWIDTH * 1.2 )
//        layer.position = CGPoint(x: 100, y: 100)
//        mylog(layer.videoRect)
//        if #available(iOS 9.0, *) {
//            let _ =  AVPictureInPictureController.init(playerLayer: layer)
//            //            self.navigationController?.present(a , animated: true , completion: nil )
//        } else {
//            // Fallback on earlier versions
//        }
        
        
    }
    //pageControDelegate
    func currentPageChanged(currentPage: Int) {
        mylog("currentPage改了")
        if pageControl.currentPage == 0 {
            //                self.userCollection.isHidden = false
            
            GDKeyVC.share.currentCircleID = "0"
        }else{
            if let circleIDStr = circleModels[self.pageControl.currentPage].title{
                GDKeyVC.share.currentCircleID = circleIDStr
            }
            //                self.userCollection.isHidden = true
        }
        
        if let circleIDStr = circleModels[self.pageControl.currentPage].title{
            GDKeyVC.share.currentCircleID = circleIDStr
            let tempMembers = membersDict[circleIDStr]
            if tempMembers != nil  {
                self.circleMembers = tempMembers!
            }else{
                self.circleMembers = []
            }
        }else{
            self.circleMembers = []
        }

    }
    func setupPageControl() {
        self.view.addSubview(self.pageControl)
        self.pageControl.delegate = self
        if self.pageControl.scrollView == nil  {
            self.pageControl.scrollView = self.circleCollection
        }
        self.pageControl.numberOfPages = self.circleModels.count
        if SCREENWIDTH <= 320 {
                self.pageControl.frame = CGRect(x: 0, y: SCREENHEIGHT - 70, width: SCREENWIDTH, height: 44)
        }else{
            self.pageControl.frame = CGRect(x: 0, y: SCREENHEIGHT - 90, width: SCREENWIDTH, height: 44)
        }
    }
    
    func setupOtherSubviews()  {
        self.view.addSubview(nameScrollView)
        self.nameScrollView.showsHorizontalScrollIndicator = false
        
        newcircleLbl.font = GDFont.systemFont(ofSize: 17)
        self.nameScrollView.addSubview(newcircleLbl)
        
        newcircleLbl.textColor = homeTextColor


        if SCREENWIDTH <= 320 {
            self.nameScrollView.frame = CGRect(x: 10, y: self.pageControl.frame.minY - 30, width: SCREENWIDTH - 10 * 2 , height: 44)
        }else{
            self.nameScrollView.frame = CGRect(x: 10, y: self.pageControl.frame.minY - 44, width: SCREENWIDTH - 10 * 2 , height: 44)
        }
        self.newcircleLbl.text = "拍照建立新圈子"
        self.newcircleLbl.sizeToFit()
        if self.newcircleLbl.bounds.size.width > self.nameScrollView.bounds.size.width {
            nameScrollView.contentSize = CGSize(width: self.newcircleLbl.bounds.size.width - self.nameScrollView.bounds.size.width, height: 44)
        }else{
            nameScrollView.contentSize = CGSize(width: 0, height: 44)
            
        }
//        nameScrollView.contentSize = CGSize(width: self.newcircleLbl.bounds.size.width, height: 44)
        self.newcircleLbl.center = CGPoint(x: self.nameScrollView.bounds.size.width/2, y: nameScrollView.bounds.size.height / 2)

//        self.newcircleLbl.frame = CGRect(x: 0, y: self.circleCollection.frame.maxY + 22, width: SCREENWIDTH, height: 44)

    }
    func setupCollection ()  {
        let margin : CGFloat = 10
        userCollection.delegate = self
        userCollection.dataSource = self
        userCollection.alwaysBounceVertical = false
        userCollection.showsHorizontalScrollIndicator = false
        userCollection.showsVerticalScrollIndicator = false
        userCollection.backgroundColor = UIColor.clear
        let leftMargin : CGFloat = 13.0
        if UIScreen.main.bounds.size.width == 320 && UIScreen.main.bounds.size.height == 480 {
            userCollection.frame = CGRect(x: leftMargin, y: self.nearbyUserTitle.frame.maxY + margin / 5 , width: SCREENWIDTH - leftMargin , height: 30)
            if let flowLayout  = userCollection.collectionViewLayout as? UICollectionViewFlowLayout {
                flowLayout.itemSize = CGSize(width: 30, height: 30)
            }
        }else{
            userCollection.frame = CGRect(x: leftMargin, y: self.nearbyUserTitle.frame.maxY + margin / 2 , width: SCREENWIDTH - leftMargin , height: 44)
        }
        self.noBodyTitle.frame = self.userCollection.frame
        //        if let flowLayout = collection.collectionViewLayout as? UICollectionViewFlowLayout  {
        //            flowLayout.itemSize = CGSize(width: SCREENWIDTH, height: SCREENWIDTH)
        //
        //        }
        self.view.addSubview(userCollection)
        
        if UIScreen.main.bounds.size.width == 320 && UIScreen.main.bounds.size.height == 480 {
            self.nearbyCircleTitle.frame = CGRect(x: margin, y: self.userCollection.frame.maxY + margin / 5, width: SCREENHEIGHT - margin , height: 20)
        }else{
        self.nearbyCircleTitle.frame = CGRect(x: margin, y: self.userCollection.frame.maxY + margin, width: SCREENHEIGHT - margin , height: 30)
        }
        
        
        circleCollection.delegate = self
        circleCollection.dataSource = self
//        circleCollection.alwaysBounceVertical = false
        circleCollection.showsHorizontalScrollIndicator = false
        circleCollection.showsVerticalScrollIndicator = false
        circleCollection.backgroundColor = UIColor.clear
        
        if UIScreen.main.bounds.size.width == 320 && UIScreen.main.bounds.size.height == 480 {
            circleCollection.frame = CGRect(x: 0, y: self.nearbyCircleTitle.frame.maxY + margin / 5
                , width: SCREENWIDTH, height: SCREENWIDTH * 0.90)
        
        }else{
            circleCollection.frame = CGRect(x: 0, y: self.nearbyCircleTitle.frame.maxY + margin
                , width: SCREENWIDTH, height: SCREENWIDTH * 0.96)
        }
        
 
        circleCollection.alwaysBounceHorizontal = true

//        if let flowLayout = collection.collectionViewLayout as? UICollectionViewFlowLayout  {
//            flowLayout.itemSize = CGSize(width: SCREENWIDTH, height: SCREENWIDTH)
//            
//        }
        self.view.addSubview(circleCollection)
       
      
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if collectionView == self.circleCollection {
            return circleModels.count
            
        }else if (collectionView == self.userCollection){
            return nearbyUserModels.count
        }else{
            return 0
        }
    }
    
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        if collectionView == self.circleCollection {
            
            let item  = collectionView.dequeueReusableCell(withReuseIdentifier: "GDHomeCircleCell", for: indexPath)
            if let cell  = item as? GDHomeCircleCell {
                cell.collection.mj_footer.state = MJRefreshState.idle
                //set model
                
                
                if let circleIDStr  = self.circleModels[indexPath.item].title {//取出相应位置的ciecleID
                    if self.subImagesDict[circleIDStr] == nil {
                        cell.circleModels = nil//可能count为零吗//防止重用 , 置空
                        //执行请求
                        self.getCircleDetail(circleID: circleIDStr, currentPage: "1", { (mideaS, members) in
                            
                            cell.circleModels = self.subImagesDict[circleIDStr] //可能count为零吗
                            cell.circleID = circleIDStr
                            cell.selectedItemModel = self.selectedsDict[circleIDStr]
 
                        }, failure: { (error) in
                            
                        })
                    }else{
                        var  needRequest = false
                        mylog(self.subImagesDict[circleIDStr])
                        for picModel in self.subImagesDict[circleIDStr]! {
                            if picModel.subImageUrl == nil || picModel.subImageUrl?.isEmpty ?? true {
                                needRequest = true
                            }
                        }
                        if needRequest {
                            //执行请求
                            self.getCircleDetail(circleID: circleIDStr, currentPage: "1", { (mideaS, members) in
                                
                                cell.circleModels = self.subImagesDict[circleIDStr] //可能count为零吗
                                cell.circleID = circleIDStr
                                cell.selectedItemModel = self.selectedsDict[circleIDStr]
                                
                            }, failure: { (error) in
                                
                            })
                        }else{
                        
                            cell.circleModels = self.subImagesDict[circleIDStr]!
                            cell.selectedItemModel = self.selectedsDict[circleIDStr]
                            cell.circleID = circleIDStr
                        // 传递上次的contentOffset TODO
                        }
                    }
                    //                cell.circleID = circleIDStr
                }
                if cell.delete == nil  {
                    cell.delete = self
                }
                return cell
            }
            return item
            
            
        }else if (collectionView == self.userCollection){

            let item  = collectionView.dequeueReusableCell(withReuseIdentifier: "GDHomeUserCell", for: indexPath)
            if let cell  = item as? GDHomeUserCell {
                //set model
                cell.model = nearbyUserModels[indexPath.item]
                return cell
            }
            return item

        }else{
            return UICollectionViewCell.init(frame: CGRect.zero)
        }
        
    }
    
    //获取附近所有圈子
    
    func getNearbyCircles()  {
        if !isNeedReloadData  {
           isNeedReloadData = true
            return
        }
        
        GDNetworkManager.shareManager.getNearbycircal({ (model ) in
//            mylog(model.data)
            mylog("获取所有圈子的状态码\(model.status)")
//            mylog(model.data)

            if model.status == 200 {
                if let info = model.data as? Dictionary<String, Any> {
//                    mylog(info)+
                    var circleModels : [BaseControlModel] = [BaseControlModel]()
                    if let circlesAny = info["circle_id"] {
                        if let circles = circlesAny as? [Any]{
                            for (index , item) in circles.enumerated() {
                                
                                let model = BaseControlModel(dict: ["title": "\(item)" as AnyObject])
                                circleModels.append(model)
                            }
                        }
                    }
                    self.circleModels = circleModels
                    var userModels : [BaseControlModel] = [BaseControlModel]()
                    
                    if  let nearbyUsersAny = info["users"] {
                        if let nearbyUsers = nearbyUsersAny as? [Any?]{
                            for  item in nearbyUsers {
                                if let itemDict = item as? [String : AnyObject]{//shu ju ge shi dai ding
                                    /**
                                     id = 11;
                                     name = 许鹏亮;
                                     avatar = avatar.jpg;
                                     */
                                    let dict = [
                                        "title":itemDict["name"] ?? "",
                                        "imageUrl":itemDict["avatar"] ?? "",
                                        "subTitle":itemDict["id"] ?? "",
                                    ] as [String : Any]
                                    
                                    let model = BaseControlModel(dict: dict as [String : AnyObject]?)
                                    userModels.append(model)
                                }
                            }
                        }
                    }
                    
                    self.nearbyUserModels = userModels
                    if (userModels.count == 0 ){
                        self.noBodyTitle.isHidden = false
                        self.view.bringSubview(toFront: self.noBodyTitle)
                    }else{
                        self.noBodyTitle.isHidden = true

                    }
//                    mylog(self.circleModels)
//                    mylog(self.nearbyUserModels)
                    
                }else{
                    mylog("取data值失败")
                }
            }else  {//
                mylog("获取圈子失败")
            }
            
        }) { (error ) in
            mylog("获取所有圈子失败:\(error)")
        }

    }
    
    
    //根据圈子id获取圈子详情
    func getCircleDetail(circleID : String , currentPage: String , _ success : @escaping (_ medias :  [BaseControlModel] , _ users :  [BaseControlModel] ) -> () , failure : @escaping (_ error : NSError) -> ()) {
        GDNetworkManager.shareManager.getCircleDetail(circleID: circleID, page: currentPage, { (result ) in
            mylog("获取圈子详情状态码:\(result.status)")
            mylog(result.data)
            var circleMemberModels : [BaseControlModel] = [BaseControlModel]()//圈子的成员模型集合
            var circleMediaModels : [BaseControlModel] = [BaseControlModel]()//圈子的图片模型集合
            if result.status == 200 {
                if let info = result.data as? Dictionary<String, Any> {
//                    mylog(info)
                    
 
                    
                    if let membersAny = info["members"] {//圈子成员模型集合
                        if let members = membersAny as? [[String:AnyObject]]{
                            for  item in members {
//                                if let itemDict = item as? [String : AnyObject]{//shu ju ge shi dai ding
                                
//                                    let dict = [
//                                        "title":item["name"] ?? "",
//                                        "imageUrl":item["avatar"] ?? "",
//                                        "subTitle":item["id"] ?? "",
//                                        ] as [String : Any]
//                                    let model = BaseControlModel(dict: dict as [String : AnyObject]? )
//                                    circleMemberModels.append(model)
                                let model = BaseControlModel(dict: nil )
                                if let name = item["name"] {//
                                    if let nameStr  = name as? String {
                                        model.title = nameStr
                                    }
                                }
                                
                                if let avatar = item["avatar"] {//
                                    if let avatarStr  = avatar as? String {
                                        model.imageUrl = avatarStr
                                    }
                                }
                                if let id = item["id"] {//
                                    if let idStr  = id as? String {
                                        model.subTitle = idStr
                                    }
                                }

                                circleMemberModels.append(model)
                                
//                                }
                            }
                        }
                    }
                    mylog(GDKeyVC.share.currentCircleID)
                    mylog(circleID)
                    mylog(self.pageControl.currentPage)
                    self.membersDict[circleID] = circleMemberModels
                    if GDKeyVC.share.currentCircleID == circleID{
                        self.circleMembers = circleMemberModels//当新上传媒体后 , 圈子详情下的成员执行更新(貌似还没解决啊 , pageControl的currentPage不准了)
                    }
                    
                    
                    if  let mediasAny = info["media"] {//图片或视频模型集合
                        if let medias = mediasAny as? [Any?]{
                            for (index ,  item) in medias.enumerated() {
                                if let itemDict = item as? [String : AnyObject]{//shu ju ge shi dai ding
                                    let model = BaseControlModel(dict: nil)
                                    if let thumbnail = itemDict["thumbnail"] {//缩略图
                                        if let thumbnailStr  = thumbnail as? String {
                                            
                                            model.subImageUrl = thumbnailStr
                                        }
                                    }
                                    if let original = itemDict["original"] {//原图
                                        if let originalStr  = original as? String {
                                            model.imageUrl = originalStr
                                            
                                        }
                                    }
                                    if let create_user_avatar = itemDict["create_user_avatar"] {//头像
                                        if let create_user_avatarStr  = create_user_avatar as? String {
                                            model.additionalImageUrl = create_user_avatarStr
                                        }
                                    }
                                    
                                    
                                    if let create_user_name = itemDict["create_user_name"] {//名字
                                        if let create_user_nameStr  = create_user_name as? String {
                                            model.title = create_user_nameStr
                                        }
                                    }
                                    
//                                    if let create_at = itemDict["create_at"] {//创建时间
//                                        if let create_atStr  = create_at as? String {
//                                            model.subTitle = create_atStr
//                                        }
//                                    }
                                    if let create_at = itemDict["create_date"] {//创建时间
                                        if let create_atStr  = create_at as? String {
                                            model.subTitle = create_atStr
                                        }
                                    }
                                    
                                    
                                    if let description = itemDict["description"] {//图片备注
                                        if let descriptionStr  = description as? String {
                                            model.additionalTitle = descriptionStr
                                        }
                                    }
                                    if let city = itemDict["city"] {//圈子id
                                        if let cityStr  = city as? String {
                                            model.extensionTitle1 = cityStr
                                        }
                                    }
                                    if let circle_id = itemDict["id"] {// mei ti  id // yong lai qing qiu  mei ti xiang qing
                                        if let circle_idStr  = circle_id as? String {
                                            model.extensionTitle = circle_idStr
                                        }
                                    }
                                    
                                    if let format = itemDict["format"] {// mei ti  id // yong lai qing qiu  mei ti xiang qing
                                        if let formatStr  = format as? String {
                                            model.extensionTitle2 = formatStr
                                        }
                                    }
                                    
                                    
//                                    if   index == 0 {self.selectedItemModel = model }
                                    circleMediaModels.append(model)
                                    if index == 0 {
                                        self.selectedsDict[circleID] = model
                                    }
                                }
                            }
                            self.subImagesDict[circleID] = circleMediaModels
                        }
                    }
                    
                    if  let isAddAny = info["is_add"] {//是否已添加
                        if let isAdd = isAddAny as? String{
                            mylog(isAdd)
                        }
                    }
                }else{
                    mylog("取data值失败")
                }
            }
            success(circleMediaModels ,circleMemberModels )
        }, failure: { (error ) in
            mylog("获取圈子详情失败:\(error)")
            failure(error)
        })
    }
    
    // MARK: 注释 : clickdelegate//点击小图代理 , 方便记录位置(暂时不实现)
    func collectionViewCellClick(item : UICollectionViewCell){
        if let cellReal = item as? GDCollectionImageCell {
            if let circleID  = cellReal.model.extensionTitle {
                self.selectedsDict[circleID]  = cellReal.model
            }
        }else if let cellReal = item as? GDHomeCircleCell {
             let circleID  = cellReal.circleID
            let model = GDBaseModel.init(dict: nil)
            model.actionkey = "GDCircleDetailVC"
            model.keyparamete = circleID as AnyObject?
            GDSkipManager.skip(viewController: self , model: model) 
            //根据圈子id跳转到圈子详情页
            
        }
    }
    func circleMediaLoadmore(item : GDHomeCircleCell) -> (){
        mylog("加载更多")
        if let currentPage  = Int(item.currentPage)   {
            let nextPage  = "\(currentPage + 1)"
             item.currentPage = nextPage
            mylog(item.circleID)
            self.getCircleDetail(circleID: item.circleID, currentPage: item.currentPage, { (circleMediaModels ,circleMemberModels ) in
                //执行拼接
                item.circleModels?.append(contentsOf:circleMediaModels)
                self.subImagesDict[item.circleID]?.append(contentsOf: circleMediaModels)
                item.collection.reloadData()
                if circleMediaModels.count == 0 {
                    item.collection.mj_footer.state = MJRefreshState.noMoreData
                }else{
                
                    item.collection.mj_footer.state = MJRefreshState.idle
                }
                
            }, failure: { (error ) in
                
            })
            
        }
        
        
        
    }
    
    // MARK: 注释 : didSelect
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.userCollection {
            mylog("点击附近的人头像")
            let model = self.nearbyUserModels[indexPath.item]
//            mylog("\(model.title)  \(model.subTitle)  \(model.imageUrl)")
            let skipModel = GDBaseModel.init(dict: nil )
            skipModel.actionkey = "GDUserHistoryVC"
            skipModel.keyparamete = model.subTitle as AnyObject//用户id
            GDSkipManager.skip(viewController: self , model: skipModel)
            
        }
    }
    
    // MARK: 注释 : scrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        if scrollView == self.circleCollection {
            
            
//            self.pageControl.scrollView = scrollView
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        mylog("点击首页空白")
//        GDIBContentView.init(photos: [GDIBPhoto]() , showingPage : 2)
        
    }
    

}
