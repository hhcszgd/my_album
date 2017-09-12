//
//  GDCircleDetailVC.swift
//  zjlao
//
//  Created by WY on 18/04/2017.
//  Copyright © 2017 com.16lao.zjlao. All rights reserved.
//





import UIKit
import MJRefresh
import AVKit
class GDCircleDetailVC: GDUnNormalVC  , GDCircleDetailCellHeaderDelete , GDCircleDetailCellFooterDelete , UITextViewDelegate , GDCircleDetailCellDelete {
    
    // MARK: 注释 : propertis
    var currentPage : Int = 1
    var offset : Int = 0
    var mediaCount : Int = 0
    let inputContainer = UIView()
    lazy var textView  = UITextView()
    var datas  : [GDCircleDetailCellModel] = {
        var tempDatas = [GDCircleDetailCellModel]()
        return tempDatas
    }()
    var circleID : String?
    var currentMediaID : String?//评论用
    
    var keyboardInfo:NSNotification?
    
    // MARK: 注释 : methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.naviBar.backgroundColor = UIColor.init(colorLiteralRed: 0.99, green: 0.99, blue: 0.99, alpha: 1)
        self.automaticallyAdjustsScrollViewInsets = false
        if let circleIDStr  =  self.keyModel?.keyparamete as? String {
            self.circleID  = circleIDStr
        }
        self.setupTableView()
        self.requestData(loadDataType: LoadDataType.initialize)
        // Do any additional setup after loading the view.
        self.setupTextView()
    }
    func postRefreshNotification(invc: String = "ClassifyVC")  {
        if invc == "ClassifyVC" {
            NotificationCenter.default.post(Notification.init(name: Notification.Name.init("RefreshAfterBlockSomeoneInClassifyVC")))
        }
        self.popToPreviousVC()
    }
    func setupTextView()  {
        self.inputContainer.addSubview(self.textView)
        
        self.inputContainer.backgroundColor =  UIColor.init(colorLiteralRed: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        self.view.addSubview(self.inputContainer)
        self.textView.enablesReturnKeyAutomatically = true
        self.inputContainer.frame = CGRect(x: 0, y: SCREENHEIGHT, width: SCREENWIDTH, height: SCREENWIDTH * 0.4)
        let cancleBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 64, height: 44))
        let confirmBtn = UIButton.init(frame: CGRect(x:self.inputContainer.bounds.size.width - 64 , y: 0, width: 64, height: 44))
        cancleBtn.setTitle("取消", for: UIControlState.normal)
        cancleBtn.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        cancleBtn.addTarget(self , action: #selector(cancleBtnClick), for: UIControlEvents.touchUpInside)
        inputContainer.addSubview(cancleBtn)
        
        confirmBtn.setTitle("确定", for: UIControlState.normal)
        confirmBtn.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        confirmBtn.addTarget(self , action: #selector(confirmBtnClick), for: UIControlEvents.touchUpInside)
        inputContainer.addSubview(confirmBtn)
        
        self.textView.frame = CGRect(x: 10, y: 44, width: self.inputContainer.frame.size.width - 20, height: self.inputContainer.frame.size.height - 44 - 10)
        self.textView.returnKeyType = UIReturnKeyType.done
        self.textView.delegate = self
        NotificationCenter.default.addObserver(self , selector: #selector(keyboardWillHide(info:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self , selector: #selector(keyboardWillShow(info:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func cancleBtnClick()  {
        self.textView.resignFirstResponder()
    }
    func confirmBtnClick()  {
        if textView.text.characters.count > 0  {
            if self.currentMediaID != nil  {
                GDNetworkManager.shareManager.commentAndLike(mediaID: self.currentMediaID!, isLike: "0", content: self.textView.text, { (result ) in
                    mylog("评论成功\(String(describing: result.data))")
                    self.requestData(loadDataType: LoadDataType.initialize)
                }, failure: { (error ) in
                    mylog("发表评论请求失败 : \(error)")
                })
            }
            self.textView.text = nil
            self.currentMediaID = nil
        }
        self.cancleBtnClick( )
        
    }
    func keyboardWillHide(info:NSNotification)  {
        mylog(info.userInfo)
        self.performSomethingWhenKeyboardWillHide(info: info)
    }
    func performSomethingWhenKeyboardWillHide(info:NSNotification) {
        var realTime : TimeInterval = 0.25
        let timeInterval = info.userInfo?[UIKeyboardAnimationDurationUserInfoKey]
        if let timeAny  = timeInterval  {
            if let time  = timeAny as? TimeInterval {
//                if time == 0  {
//                    return
//                }
                realTime = time
            }
        }
        UIView.animate(withDuration: realTime) {
            self.inputContainer.center = CGPoint(x: self.view.bounds.size.width / 2, y: self.inputContainer.bounds.size.width / 2 + SCREENHEIGHT)
        }
    }
    func keyboardWillShow(info:NSNotification)  {
        self.keyboardInfo = info
        self.performSomethingWhenKeyboardWillShow(info: info)
    }
    
    func performSomethingWhenKeyboardWillShow(info:NSNotification) {
        var realTime : TimeInterval = 0.25
        let timeInterval = info.userInfo?[UIKeyboardAnimationDurationUserInfoKey]
        
        let keyboardEndFrame = info.userInfo?[UIKeyboardFrameEndUserInfoKey] ; // as CGRect
        if let timeAny  = timeInterval  {
            if let time  = timeAny as? TimeInterval {
                if time == 0  {
                    return
                }
                realTime = time
            }
        }
        
        if let keyboardFrame = keyboardEndFrame {
            if let keyboardFrameRect = keyboardFrame as? CGRect {
                mylog(keyboardFrameRect)
                UIView.animate(withDuration: realTime) {
                    self.inputContainer.center = CGPoint(x: self.view.bounds.size.width / 2, y: keyboardFrameRect.origin.y - self.inputContainer.bounds.size.height / 2)
                }
            }
            
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.resignFirstResponder()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    func setupTableView()  {
        //        self.tableView.frame = CGRect(x: 0, y: NavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - NavigationBarHeight)
        self.tableView.backgroundColor = UIColor.white
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.delegate  = self
        self.tableView.dataSource = self
        //        self.tableView.mj_footer = GDRefreshGifFooter(refreshingTarget: self , refreshingAction: #selector(loadMore))
        //        self.tableView.mj_header = GDRefreshHeader(refreshingTarget: self, refreshingAction: #selector(refreshOrInit))
        
        self.tableView.mj_footer = GDRefreshGifFooter(refreshingTarget: self , refreshingAction: #selector(loadMore))
        self.tableView.mj_header = GDRefreshHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
        
        
        
    }
    override func loadMore () {
        self.requestData(loadDataType: LoadDataType.loadMore)
    }
    override func refresh()  {
        self.requestData(loadDataType: LoadDataType.initialize)
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.datas.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.datas[section].comments?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCell(withIdentifier: "GDCircleDetailCell")
        if cell == nil  {
            cell = GDCircleDetailCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "GDCircleDetailCell")
        }
        if let cellReal  = cell as? GDCircleDetailCell {
            cellReal.singleComment = self.datas[indexPath.section].comments?[indexPath.row]
            cellReal.cellDelegate  = self
            return cellReal
        }
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var totalHeight : CGFloat = 0
        let iconW  : CGFloat = 44
        let bigImgW = SCREENWIDTH - iconW * 2
        let nameH : CGFloat = 30
        
        totalHeight += (bigImgW + nameH)
        let model = self.datas[section]
        var  arrowH : CGFloat = 0
        if model.goods?.count ?? 0 > 0 || model.comments?.count ?? 0 > 0  {
             arrowH  = 8
        }
        totalHeight += arrowH
        let zanH : CGFloat = self.getZanHeight(model: model)
        totalHeight += zanH
        return totalHeight//需要计算
    }
    
    
    func getZanHeight(model : GDCircleDetailCellModel) -> CGFloat {
        

        let zanContainerMaxW :CGFloat = SCREENWIDTH - 44 * 2
        let margin : CGFloat = 5
        var currentW : CGFloat = margin
        var currentH : CGFloat = margin
        
        let zanContainer = UIView()
        for subview in zanContainer.subviews {
            subview.removeFromSuperview()
        }
        zanContainer.addSubview(UIImageView(image: UIImage(named:"like_black")))
        for zanModel in model.goods ?? [] {
            let zan = GDZanUser()
            zan.model = zanModel
            zanContainer.addSubview(zan)
        }

        if model.goods?.count ?? 0 > 0  {
            var zanitemH : CGFloat = 0
            for (index ,subView) in zanContainer.subviews.enumerated() {
                if let zanLogo = subView as? UIImageView {
                    zanLogo.frame =  CGRect(x: margin , y: margin  , width: 14, height:14 )
                    currentW += (margin + 14)
                }
                if let zanView = subView as? GDZanUser {
                    zanitemH = zanView.bounds.size.height
                    let tempmodel =  model.goods?[index-1]
                    //                    tempmodel?.switchState = true
                    zanView.model = tempmodel
                    if zanView.bounds.size.width > zanContainerMaxW - currentW - margin {
                        currentH += (zanView.bounds.size.height + margin)
                        currentW = margin
                        if index == (model.goods?.count ?? 0) {
                            tempmodel?.switchState = false
                        }else{
                            tempmodel?.switchState = true
                        }
                        zanView.model = tempmodel
                        zanView.frame = CGRect(x: currentW, y: currentH, width: zanView.bounds.size.width, height: zanView.bounds.size.height)
                    }else{
                        if index == (model.goods?.count ?? 0) {//隐藏最后一个人得逗号
                            tempmodel?.switchState = false
                        }else{
                            tempmodel?.switchState = true
                        }
                        if currentW == margin  {//隐藏行尾人后面的逗号
                            let tempmodel2 =  model.goods?[index-1]
                            tempmodel2?.switchState = false
                            if let priviousZanview = zanContainer.subviews[index - 2] as? GDZanUser{
                                priviousZanview.model = tempmodel2
                            }
                        }
                        
                        zanView.frame = CGRect(x: currentW , y: currentH   , width: zanView.bounds.size.width, height: zanView.bounds.size.height)
                        currentW += (zanView.bounds.size.width + margin)
                        
                        zanView.model = tempmodel
                    }
                }
            }
            currentH += (zanitemH + margin)
            return currentH
        }else{
            return 0 
        }
        

    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let  model = self.datas[section]
        return (model.comment_count?.intValue ?? 0 ) > 2 ? (30 + 10) : 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerOption = tableView.dequeueReusableHeaderFooterView(withIdentifier: "GDCircleDetailCellHeader")
        if let header = headerOption as? GDCircleDetailCellHeader{
            
            header.model = self.datas[section]
            header.cellDelegate  = self
            return header
        }else{
            let header = GDCircleDetailCellHeader.init(reuseIdentifier: "GDCircleDetailCellHeader")
            
            header.model = self.datas[section]
            header.cellDelegate  = self
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let  model = self.datas[section]
        let footerOption = tableView.dequeueReusableHeaderFooterView(withIdentifier: "GDCircleDetailCellFooter")
        if let footer = footerOption as? GDCircleDetailCellFooter {
            footer.commentCount = model.comment_count?.intValue ?? 0
            footer.mediaID = model.id
            footer.delegate = self
            return footer
        }else{
            let footer = GDCircleDetailCellFooter.init(reuseIdentifier: "GDCircleDetailCellFooter")
            footer.commentCount = model.comment_count?.intValue ?? 0
            footer.mediaID = model.id
            footer.delegate = self
            return footer
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        let cell =  GDCircleDetailCell()
        if   let model = self.datas[indexPath.section].comments?[indexPath.row]{
            let backColorViewW = SCREENWIDTH - 44 * 2
            let horizontalMargin  :CGFloat = 5
            let verticalMargin : CGFloat = 2
            let maxWidth =  backColorViewW - horizontalMargin * 2
            let fullCommtenStr = (model.title ?? "") + ": " + (model.subTitle ?? "")
            let size = fullCommtenStr.sizeWith(font: cell.commetTextLabel.font, maxWidth: maxWidth)
            let totalH = size.height  + verticalMargin * 2
            return totalH
        }
        return 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model  = self.datas[indexPath.section].comments?[indexPath.row]{
            let comment_user_name = model.title ?? ""
            let comment_user_id = model.additionalTitle ?? "0"
            let id = model.extensionTitle1 ?? ""
            let media_id = model.extensionTitle2 ?? ""
            mylog("评论id:\(id) , 媒体id:\(media_id) , 评论人姓名:\(comment_user_name) , 评论人id: \(comment_user_id)")
        }
        self.textView.resignFirstResponder()
    }
    func requestData(loadDataType:LoadDataType)  {
        
        switch loadDataType {
        case LoadDataType.initialize , LoadDataType.reload:
            self.offset = 0
            break
        case LoadDataType.loadMore:
            break
        }
        
        var tempCircleID = ""
        if let circleID  =  self.keyModel?.keyparamete as? String {
            tempCircleID = circleID
        }else{return}
        GDNetworkManager.shareManager.getCircleMediasList(circleID: tempCircleID, offset: self.offset, { (result) in
            mylog("请求纵向圈子详情结果 : \(result.status)")
            mylog(result.data)
            var tempDatas  : [GDCircleDetailCellModel] = [GDCircleDetailCellModel] ()
            if let infoDict = result.data as? [String : AnyObject]{
                
                var offSet : Int = 0
                var pageSize : Int = 0
                var mediaCount : Int = 0
                if let media_Count = infoDict["mediaCount"] as? Int{
                    mediaCount = media_Count
                }
                if let off_set = infoDict["offset"] as? Int{
                    offSet = off_set
                }
                if let page_Size = infoDict["pageSize"] as? Int{
                    pageSize = page_Size
                }
                self.offset = offSet + pageSize
                if let subMediasArr = infoDict["resultMedia"] as? [[String : AnyObject]]{
                    for subMediaDict in subMediasArr{
                        let picModel : GDCircleDetailCellModel = GDCircleDetailCellModel.init(dict: subMediaDict)
                        tempDatas.append(picModel)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textView.resignFirstResponder()
    }
    
    // MARK: 注释 : customDelegate
    
    func blockSomeoneSuccess() {
        self.postRefreshNotification()
    }
    func zanClick(mediaID:String){
        GDNetworkManager.shareManager.commentAndLike(mediaID: mediaID, isLike: "1", content: nil, { (result ) in
            mylog("点赞结果\(result.status)")
            self.requestData(loadDataType: LoadDataType.initialize)
        }, failure: { (error ) in
            mylog("点赞请求失败 : \(error)")
        })
    }
    //    var currentMediaID : String?
    
    func commentClick(mediaID:String){
        self.currentMediaID = mediaID
        //        self.becomeFirstResponder()
        self.textView.becomeFirstResponder()
        if self.inputContainer.frame.origin.y >= UIScreen.main.bounds.size.height && self.keyboardInfo != nil {

            let realTime : TimeInterval = 0
            let keyboardEndFrame = self.keyboardInfo?.userInfo?[UIKeyboardFrameEndUserInfoKey] ; // as CGRect
            if let keyboardFrame = keyboardEndFrame {
                if let keyboardFrameRect = keyboardFrame as? CGRect {
                    mylog(keyboardFrameRect)
                    UIView.animate(withDuration: realTime) {
                        self.inputContainer.center = CGPoint(x: self.view.bounds.size.width / 2, y: keyboardFrameRect.origin.y - self.inputContainer.bounds.size.height / 2)
                    }
                }
                
            }

        
        }
        //        self.privateTextView.isHidden = false
        
    }
    
    func seeMoreCmmments(mediaID:String){
        let model = GDBaseModel.init(dict: nil )
        model.actionkey = "GDMideaDetailVC"
        let keyParamete : [String : String ] = ["circleID":self.circleID ?? "0" , "mediaID":mediaID]
        model.keyparamete = keyParamete as AnyObject
        GDSkipManager.skip(viewController: self , model: model)
        
        
    }
    
    
    func bigImageClickToImageBrowser( model  : GDCircleDetailCellModel){//
        self.textView.resignFirstResponder()
        if (model.format ?? "") == "jpeg"  || (model.format ?? "" ) == "png" || (model.format ?? "") == "jpg" {
            
            if let index  =  datas.index(of: model) {
                self.gotoImageBrowser(index: index)
            }
        }else if (model.format ?? "") == "MOV"  || (model.format ?? "") == "mp4" || (model.format ?? "") == "avi"{
            // MARK: 注释 : 替换视频链接movieLink
            if let urlStr  = model.video_url {
                if let url = URL.init(string: urlStr) {
                    let avPlayer : AVPlayer = AVPlayer.init(url: url)
                    avPlayer.play()
                    let avPlayerVC : AVPlayerViewController  = AVPlayerViewController.init()
                    avPlayerVC.player = avPlayer
                    self.present(avPlayerVC, animated: true  , completion: {
                        
                    })
                    
                }
            }
            
        }
    }
    
    func gotoImageBrowser(index : Int = 0)  {
        var phtots = [GDIBPhoto]()
        for model  in datas {
            let photo = GDIBPhoto(dict: nil)
            photo.imageURL = model.original
            phtots.append(photo)
        }
        
         _ = GDIBContentView.init(photos: phtots , showingPage : index)
    }
    
    func bigImageClick(mediaID:String){
        self.seeMoreCmmments(mediaID: mediaID)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        if text == "\n" {//点return键走这里
            if self.currentMediaID != nil  {
                GDNetworkManager.shareManager.commentAndLike(mediaID: self.currentMediaID!, isLike: "0", content: self.textView.text, { (result ) in
                    mylog("评论成功\(String(describing: result.data))")
                    self.requestData(loadDataType: LoadDataType.initialize)
                }, failure: { (error ) in
                    mylog("发表评论请求失败 : \(error)")
                })
            }
            
            
            
            self.textView.text = nil
            self.currentMediaID = nil
            self.textView.resignFirstResponder()
            
            return false
        }else{return true}
    }
    
    func deleteClick(mediaID:String){
        GDNetworkManager.shareManager.deleteMedia(mediaID: mediaID, { (result ) in
            mylog("删除媒体成功\(String(describing: result.data))")
            if (self.datas.count == 1 ){
                
                self.popToPreviousVC()
            }else{
                self.requestData(loadDataType: LoadDataType.initialize)
            }
        }) { (error ) in
            mylog("删除媒体失败\(error)")
        }
        mylog("删")
    }
    
    /**举报*/
    
    func perforReport(mediaID : String , reporterID : String){
        
        GDNetworkManager.shareManager.report(mediaID: mediaID, { (model ) in
            var tips = ""
            switch model.status {
            case 200 :
                tips = "举报成功,等待审核"
            case 350 :
                tips = "请勿重复举报"
            default :
                tips = "未知错误"
            }
            self.alertmessage(message: tips)
//            print(model.status)
//            print(model.data)
        }) { (error ) in
            self.alertmessage(message: "未知错误")
            print (error.localizedDescription)
        }
//        let alertvc = UIAlertController.init(title: "举报成功", message: "我们将对您的举报的信息进行审核", preferredStyle: UIAlertControllerStyle.alert)
//        let action = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default) { (action ) in
//            alertvc.dismiss(animated: true , completion: nil )
//        }
//        alertvc.addAction(action)
//        self.present(alertvc, animated: true , completion: nil )
        
        
        
        
        
    }
    
    func alertmessage(message : String )  {
        let alertvc = UIAlertController.init(title: message, message: nil , preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default) { (action ) in
            alertvc.dismiss(animated: true , completion: nil )
        }
        alertvc.addAction(action)
        self.present(alertvc, animated: true , completion: nil )
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.textView.resignFirstResponder()
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    func gotoUserDetail(userID:String)  {
        //            mylog("\(model.title)  \(model.subTitle)  \(model.imageUrl)")
        let skipModel = GDBaseModel.init(dict: nil )
        skipModel.actionkey = "GDUserHistoryVC"
        skipModel.keyparamete =  userID as AnyObject //model.subTitle as AnyObject//用户id
        GDSkipManager.skip(viewController: self , model: skipModel)
    }
}
/*
 //
 //  GDCircleDetailVC.swift
 //  zjlao
 //
 //  Created by WY on 18/04/2017.
 //  Copyright © 2017 com.16lao.zjlao. All rights reserved.
 //
 
 import UIKit
 import MJRefresh
 import AVKit
 class GDCircleDetailVC: GDUnNormalVC  , GDCircleDetailCellDelete , UITextViewDelegate {
 
 // MARK: 注释 : propertis
 var currentPage : Int = 1
 var offset : Int = 0
 var mediaCount : Int = 0
 let inputContainer = UIView()
 lazy var textView  = UITextView()
 var datas  : [GDCircleDetailCellModel] = {
 var tempDatas = [GDCircleDetailCellModel]()
 return tempDatas
 }()
 var circleID : String?
 var currentMediaID : String?//评论用
 
 
 // MARK: 注释 : methods
 override func viewDidLoad() {
 super.viewDidLoad()
 self.naviBar.backgroundColor = UIColor.init(colorLiteralRed: 0.99, green: 0.99, blue: 0.99, alpha: 1)
 
 self.automaticallyAdjustsScrollViewInsets = false
 if let circleIDStr  =  self.keyModel?.keyparamete as? String {
 self.circleID  = circleIDStr
 }
 self.setupTableView()
 self.requestData(loadDataType: LoadDataType.initialize)
 // Do any additional setup after loading the view.
 self.setupTextView()
 }
 
 func setupTextView()  {
 self.inputContainer.addSubview(self.textView)
 self.inputContainer.backgroundColor = UIColor.init(colorLiteralRed: 0.9, green: 0.8, blue: 0.8, alpha: 1)
 self.view.addSubview(self.inputContainer)
 self.textView.enablesReturnKeyAutomatically = true
 self.inputContainer.frame = CGRect(x: 0, y: -SCREENWIDTH, width: SCREENWIDTH, height: SCREENWIDTH * 0.7)
 self.textView.frame = CGRect(x: 10, y: 10, width: self.inputContainer.frame.size.width - 20, height: self.inputContainer.frame.size.height - 20)
 self.textView.returnKeyType = UIReturnKeyType.done
 self.textView.delegate = self
 NotificationCenter.default.addObserver(self , selector: #selector(keyboardWillHide(info:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
 NotificationCenter.default.addObserver(self , selector: #selector(keyboardWillShow(info:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
 }
 
 func keyboardWillHide(info:NSNotification)  {
 var realTime : TimeInterval = 0.25
 let timeInterval = info.userInfo?[UIKeyboardAnimationDurationUserInfoKey]
 if let timeAny  = timeInterval  {
 if let time  = timeAny as? TimeInterval {
 realTime = time
 }
 }
 UIView.animate(withDuration: realTime) {
 self.inputContainer.center = CGPoint(x: self.view.bounds.size.width / 2, y: -self.inputContainer.bounds.size.width / 2 - 20)
 }
 
 }
 func keyboardWillShow(info:NSNotification)  {
 var realTime : TimeInterval = 0.25
 let timeInterval = info.userInfo?[UIKeyboardAnimationDurationUserInfoKey]
 let keyboardEndFrame = info.userInfo?[UIKeyboardFrameEndUserInfoKey] ; // as CGRect
 if let timeAny  = timeInterval  {
 if let time  = timeAny as? TimeInterval {
 realTime = time
 }
 }
 
 if let keyboardFrame = keyboardEndFrame {
 if let keyboardFrameRect = keyboardFrame as? CGRect {
 mylog(keyboardFrameRect)
 UIView.animate(withDuration: realTime) {
 self.inputContainer.center = CGPoint(x: self.view.bounds.size.width / 2, y: keyboardFrameRect.origin.y - self.inputContainer.bounds.size.width / 2)
 }
 }
 
 }
 
 }
 func setupTableView()  {
 //        self.tableView.frame = CGRect(x: 0, y: NavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - NavigationBarHeight)
 self.tableView.backgroundColor = UIColor.init(colorLiteralRed: 0.95, green: 0.95, blue: 0.95, alpha: 1)
 
 self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
 self.tableView.delegate  = self
 self.tableView.dataSource = self
 //        self.tableView.mj_footer = GDRefreshGifFooter(refreshingTarget: self , refreshingAction: #selector(loadMore))
 //        self.tableView.mj_header = GDRefreshHeader(refreshingTarget: self, refreshingAction: #selector(refreshOrInit))
 
 }
 override func loadMore () {
 self.requestData(loadDataType: LoadDataType.loadMore)
 }
 override func refresh()  {
 self.requestData(loadDataType: LoadDataType.initialize)
 }
 
 
 
 
 override func didReceiveMemoryWarning() {
 super.didReceiveMemoryWarning()
 // Dispose of any resources that can be recreated.
 }
 
 
 override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
 return self.datas.count
 }
 
 
 override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
 var cell = tableView.dequeueReusableCell(withIdentifier: "GDCircleDetailCell")
 if cell == nil  {
 cell = GDCircleDetailCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "GDCircleDetailCell")
 }
 if let cellReal  = cell as? GDCircleDetailCell {
 cellReal.model = self.datas[indexPath.row]
 cellReal.cellDelegate  = self
 return cellReal
 }
 return cell!
 }
 
 
 func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
 let model = self.datas[indexPath.row]
 return self.getheight(model: model)
 }
 
 
 
 func getheight (model : GDCircleDetailCellModel) -> CGFloat  {
 var totalHeight : CGFloat = 0
 let iconW  : CGFloat = 44
 let bigImgW = SCREENWIDTH - iconW * 2
 let nameH : CGFloat = 17
 let cellJiange : CGFloat = 10
 
 totalHeight += (bigImgW + nameH)
 let verticalMargin : CGFloat = 10
 
 if model.goods?.count ?? 0 > 0  {
 let zanIconMargin : CGFloat = 2
 let zanIconW = (bigImgW - (8 - 1 ) *  zanIconMargin) /  8
 totalHeight += verticalMargin
 if model.goods?.count ?? 0 <= 8 {
 totalHeight += zanIconW
 } else if model.goods?.count ?? 0 > 8 {
 totalHeight += (zanIconW * 2 + zanIconMargin)
 }
 }
 
 if model.comments?.count ?? 0 > 0 {
 let subViewH : CGFloat = 64
 totalHeight += verticalMargin
 
 if model.comments?.count ?? 0 == 1  {
 totalHeight += subViewH
 }else if model.comments?.count ?? 0 >= 2 {
 totalHeight += (subViewH * 2 + verticalMargin)
 }
 if Int((model.comment_count)!) > 2 {
 let seeMoreH : CGFloat = 20
 totalHeight += (seeMoreH + verticalMargin)
 }
 
 }
 
 return totalHeight + cellJiange
 
 }
 
 
 func requestData(loadDataType:LoadDataType)  {
 
 switch loadDataType {
 case LoadDataType.initialize , LoadDataType.reload:
 self.offset = 0
 break
 case LoadDataType.loadMore:
 break
 }
 
 var tempCircleID = ""
 if let circleID  =  self.keyModel?.keyparamete as? String {
 tempCircleID = circleID
 }else{return}
 GDNetworkManager.shareManager.getCircleMediasList(circleID: tempCircleID, offset: self.offset, { (result) in
 mylog("请求纵向圈子详情结果 : \(result.status)")
 mylog(result.data)
 var tempDatas  : [GDCircleDetailCellModel] = [GDCircleDetailCellModel] ()
 if let infoDict = result.data as? [String : AnyObject]{
 
 var offSet : Int = 0
 var pageSize : Int = 0
 var mediaCount : Int = 0
 if let media_Count = infoDict["mediaCount"] as? Int{
 mediaCount = media_Count
 }
 if let off_set = infoDict["offset"] as? Int{
 offSet = off_set
 }
 if let page_Size = infoDict["pageSize"] as? Int{
 pageSize = page_Size
 }
 self.offset = offSet + pageSize
 if let subMediasArr = infoDict["resultMedia"] as? [[String : AnyObject]]{
 for subMediaDict in subMediasArr{
 let picModel : GDCircleDetailCellModel = GDCircleDetailCellModel.init(dict: subMediaDict)
 tempDatas.append(picModel)
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
 
 override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
 self.textView.resignFirstResponder()
 }
 
 // MARK: 注释 : customDelegate
 func zanClick(mediaID:String){
 GDNetworkManager.shareManager.commentAndLike(mediaID: mediaID, isLike: "1", content: nil, { (result ) in
 mylog("点赞结果\(result.status)")
 self.requestData(loadDataType: LoadDataType.initialize)
 }, failure: { (error ) in
 mylog("点赞请求失败 : \(error)")
 })
 }
 //    var currentMediaID : String?
 
 func commentClick(mediaID:String){
 self.currentMediaID = mediaID
 //        self.becomeFirstResponder()
 self.textView.becomeFirstResponder()
 //        self.privateTextView.isHidden = false
 
 }
 
 func seeMoreCmmments(mediaID:String){
 let model = GDBaseModel.init(dict: nil )
 model.actionkey = "GDMideaDetailVC"
 let keyParamete : [String : String ] = ["circleID":self.circleID ?? "0" , "mediaID":mediaID]
 model.keyparamete = keyParamete as AnyObject
 GDSkipManager.skip(viewController: self , model: model)
 
 
 }
 
 func bigImageClickToImageBrowser( model  : GDCircleDetailCellModel){//
 // MARK: 注释 : original字段可能会换
 if model.original?.hasSuffix("jpeg") ?? false || model.original?.hasSuffix("png") ?? false || model.original?.hasSuffix("jpg") ?? false{
 
 if let index  =  datas.index(of: model) {
 self.gotoImageBrowser(index: index)
 }
 }else if model.original?.hasSuffix("MOV") ?? false  || model.original?.hasSuffix("mp4") ?? false || model.original?.hasSuffix("avi") ?? false{
 // MARK: 注释 : 替换视频链接movieLink
 if let urlStr  = model.original {
 if let url = URL.init(string: urlStr) {
 let avPlayer : AVPlayer = AVPlayer.init(url: url)
 avPlayer.play()
 let avPlayerVC : AVPlayerViewController  = AVPlayerViewController.init()
 avPlayerVC.player = avPlayer
 self.present(avPlayerVC, animated: true  , completion: {
 
 })
 
 }
 }
 
 }
 }
 
 func gotoImageBrowser(index : Int = 0)  {
 var phtots = [GDIBPhoto]()
 for model  in datas {
 let photo = GDIBPhoto(dict: nil)
 photo.imageURL = model.original
 phtots.append(photo)
 }
 
 GDIBContentView.init(photos: phtots , showingPage : index)
 }
 
 func bigImageClick(mediaID:String){
 self.seeMoreCmmments(mediaID: mediaID)
 }
 
 func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
 if text == "\n" {//点return键走这里
 if self.currentMediaID != nil  {
 GDNetworkManager.shareManager.commentAndLike(mediaID: self.currentMediaID!, isLike: "0", content: self.textView.text, { (result ) in
 mylog("评论成功\(result.data)")
 self.requestData(loadDataType: LoadDataType.initialize)
 }, failure: { (error ) in
 mylog("发表评论请求失败 : \(error)")
 })
 }
 
 
 
 self.textView.text = nil
 self.currentMediaID = nil
 self.textView.resignFirstResponder()
 
 return false
 }else{return true}
 }
 
 func deleteClick(mediaID:String){
 GDNetworkManager.shareManager.deleteMedia(mediaID: mediaID, { (result ) in
 mylog("删除媒体成功\(String(describing: result.data))")
 if (self.datas.count == 1 ){
 
 self.popToPreviousVC()
 }else{
 self.requestData(loadDataType: LoadDataType.initialize)
 }
 }) { (error ) in
 mylog("删除媒体失败\(error)")
 }
 mylog("删")
 }
 
 func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 self.textView.resignFirstResponder()
 }
 func scrollViewDidScroll(_ scrollView: UIScrollView) {
 self.textView.resignFirstResponder()
 }
 /*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */
 func gotoUserDetail(userID:String)  {
 //            mylog("\(model.title)  \(model.subTitle)  \(model.imageUrl)")
 let skipModel = GDBaseModel.init(dict: nil )
 skipModel.actionkey = "GDUserHistoryVC"
 skipModel.keyparamete =  userID as AnyObject //model.subTitle as AnyObject//用户id
 GDSkipManager.skip(viewController: self , model: skipModel)
 }
 }
 
 */













/*
import UIKit
import MJRefresh
import AVKit
class GDCircleDetailVC: GDUnNormalVC  , GDCircleDetailCellDelete , UITextViewDelegate {
 
    // MARK: 注释 : propertis
    var currentPage : Int = 1
    var offset : Int = 0
    var mediaCount : Int = 0
    let inputContainer = UIView()
    lazy var textView  = UITextView()
    var datas  : [GDCircleDetailCellModel] = {
        var tempDatas = [GDCircleDetailCellModel]()
        return tempDatas
    }()
    var circleID : String?
    var currentMediaID : String?//评论用

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        if let b = tableView.dequeueReusableHeaderFooterView(withIdentifier: "xxx"){
            return b
        }else{
            let a = UITableViewHeaderFooterView.init(reuseIdentifier: "xxx")
            return a
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?{
        return nil
    }
    
    // MARK: 注释 : methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.naviBar.backgroundColor = UIColor.init(colorLiteralRed: 0.99, green: 0.99, blue: 0.99, alpha: 1)
        self.automaticallyAdjustsScrollViewInsets = false
        if let circleIDStr  =  self.keyModel?.keyparamete as? String {
            self.circleID  = circleIDStr
        }
        self.setupTableView()
        self.requestData(loadDataType: LoadDataType.initialize)
        // Do any additional setup after loading the view.
        self.setupTextView()
    }
    
    func setupTextView()  {
        self.inputContainer.addSubview(self.textView)
        
        self.inputContainer.backgroundColor =  UIColor.init(colorLiteralRed: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        self.view.addSubview(self.inputContainer)
        self.textView.enablesReturnKeyAutomatically = true
        self.inputContainer.frame = CGRect(x: 0, y: SCREENHEIGHT, width: SCREENWIDTH, height: SCREENWIDTH * 0.4)
        let cancleBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 64, height: 44))
        let confirmBtn = UIButton.init(frame: CGRect(x:self.inputContainer.bounds.size.width - 64 , y: 0, width: 64, height: 44))
        cancleBtn.setTitle("取消", for: UIControlState.normal)
        cancleBtn.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        cancleBtn.addTarget(self , action: #selector(cancleBtnClick), for: UIControlEvents.touchUpInside)
        inputContainer.addSubview(cancleBtn)
        
        confirmBtn.setTitle("确定", for: UIControlState.normal)
        confirmBtn.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        confirmBtn.addTarget(self , action: #selector(confirmBtnClick), for: UIControlEvents.touchUpInside)
        inputContainer.addSubview(confirmBtn)
        
        self.textView.frame = CGRect(x: 10, y: 44, width: self.inputContainer.frame.size.width - 20, height: self.inputContainer.frame.size.height - 44 - 10)
        self.textView.returnKeyType = UIReturnKeyType.done
        self.textView.delegate = self 
        NotificationCenter.default.addObserver(self , selector: #selector(keyboardWillHide(info:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
                NotificationCenter.default.addObserver(self , selector: #selector(keyboardWillShow(info:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func cancleBtnClick()  {
        self.textView.resignFirstResponder()
    }
    func confirmBtnClick()  {
        if textView.text.characters.count > 0  {
            if self.currentMediaID != nil  {
                GDNetworkManager.shareManager.commentAndLike(mediaID: self.currentMediaID!, isLike: "0", content: self.textView.text, { (result ) in
                    mylog("评论成功\(result.data)")
                    self.requestData(loadDataType: LoadDataType.initialize)
                }, failure: { (error ) in
                    mylog("发表评论请求失败 : \(error)")
                })
            }
            self.textView.text = nil
            self.currentMediaID = nil
        }
        self.cancleBtnClick( )

    }
    func keyboardWillHide(info:NSNotification)  {
        var realTime : TimeInterval = 0.25
        let timeInterval = info.userInfo?[UIKeyboardAnimationDurationUserInfoKey]
        if let timeAny  = timeInterval  {
            if let time  = timeAny as? TimeInterval {
                realTime = time
            }
        }
        UIView.animate(withDuration: realTime) {
            self.inputContainer.center = CGPoint(x: self.view.bounds.size.width / 2, y: self.inputContainer.bounds.size.width / 2 + SCREENHEIGHT)
        }

    }
    func keyboardWillShow(info:NSNotification)  {
        var realTime : TimeInterval = 0.25
        let timeInterval = info.userInfo?[UIKeyboardAnimationDurationUserInfoKey]
        let keyboardEndFrame = info.userInfo?[UIKeyboardFrameEndUserInfoKey] ; // as CGRect
        if let timeAny  = timeInterval  {
            if let time  = timeAny as? TimeInterval {
                realTime = time
            }
        }
        
        if let keyboardFrame = keyboardEndFrame {
            if let keyboardFrameRect = keyboardFrame as? CGRect {
                mylog(keyboardFrameRect)
                UIView.animate(withDuration: realTime) {
                    self.inputContainer.center = CGPoint(x: self.view.bounds.size.width / 2, y: keyboardFrameRect.origin.y - self.inputContainer.bounds.size.height / 2)
                }
            }

        }

    }
    func setupTableView()  {
//        self.tableView.frame = CGRect(x: 0, y: NavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - NavigationBarHeight)
        self.tableView.backgroundColor = UIColor.init(colorLiteralRed: 0.95, green: 0.95, blue: 0.95, alpha: 1)

        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.delegate  = self
        self.tableView.dataSource = self
//        self.tableView.mj_footer = GDRefreshGifFooter(refreshingTarget: self , refreshingAction: #selector(loadMore))
//        self.tableView.mj_header = GDRefreshHeader(refreshingTarget: self, refreshingAction: #selector(refreshOrInit))
        
    }
    override func loadMore () {
        self.requestData(loadDataType: LoadDataType.loadMore)
    }
    override func refresh()  {
        self.requestData(loadDataType: LoadDataType.initialize)
    }
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.datas.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCell(withIdentifier: "GDCircleDetailCell")
        if cell == nil  {
            cell = GDCircleDetailCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "GDCircleDetailCell")
        }
        if let cellReal  = cell as? GDCircleDetailCell {
            cellReal.model = self.datas[indexPath.row]
            cellReal.cellDelegate  = self
            return cellReal
        }
        return cell!
    }
    
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        let model = self.datas[indexPath.row]
        return self.getheight(model: model)
    }
    
    
    
    func getheight (model : GDCircleDetailCellModel) -> CGFloat  {
        var totalHeight : CGFloat = 0
        let iconW  : CGFloat = 44
        let bigImgW = SCREENWIDTH - iconW * 2
        let nameH : CGFloat = 27
        let cellJiange : CGFloat = 10
        
        totalHeight += (bigImgW + nameH)
        let verticalMargin : CGFloat = 10
        
        if model.goods?.count ?? 0 > 0  {
            let zanIconMargin : CGFloat = 2
            let zanIconW = (bigImgW - (8 - 1 ) *  zanIconMargin) /  8
            totalHeight += verticalMargin
            if model.goods?.count ?? 0 <= 8 {
                totalHeight += zanIconW
            } else if model.goods?.count ?? 0 > 8 {
                totalHeight += (zanIconW * 2 + zanIconMargin)
            }
        }
        
        if model.comments?.count ?? 0 > 0 {
            let subViewH : CGFloat = 64
            totalHeight += verticalMargin

            if model.comments?.count ?? 0 == 1  {
                totalHeight += subViewH
            }else if model.comments?.count ?? 0 >= 2 {
                totalHeight += (subViewH * 2 + verticalMargin)
            }
            if Int((model.comment_count)!) > 2 {
                let seeMoreH : CGFloat = 20
                totalHeight += (seeMoreH + verticalMargin)
            }
            
        }
        
        return totalHeight + cellJiange
        
    }
    
    
    func requestData(loadDataType:LoadDataType)  {
        
        switch loadDataType {
        case LoadDataType.initialize , LoadDataType.reload:
            self.offset = 0
            break
        case LoadDataType.loadMore:
            break
        }
        
        var tempCircleID = ""
        if let circleID  =  self.keyModel?.keyparamete as? String {
            tempCircleID = circleID
        }else{return}
        GDNetworkManager.shareManager.getCircleMediasList(circleID: tempCircleID, offset: self.offset, { (result) in
            mylog("请求纵向圈子详情结果 : \(result.status)")
            mylog(result.data)
            var tempDatas  : [GDCircleDetailCellModel] = [GDCircleDetailCellModel] ()
            if let infoDict = result.data as? [String : AnyObject]{
                
                        var offSet : Int = 0
                        var pageSize : Int = 0
                        var mediaCount : Int = 0
                        if let media_Count = infoDict["mediaCount"] as? Int{
                            mediaCount = media_Count
                        }
                        if let off_set = infoDict["offset"] as? Int{
                            offSet = off_set
                        }
                        if let page_Size = infoDict["pageSize"] as? Int{
                            pageSize = page_Size
                        }
                        self.offset = offSet + pageSize
                        if let subMediasArr = infoDict["resultMedia"] as? [[String : AnyObject]]{
                            for subMediaDict in subMediasArr{
                                let picModel : GDCircleDetailCellModel = GDCircleDetailCellModel.init(dict: subMediaDict)
                                tempDatas.append(picModel)
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textView.resignFirstResponder()
    }
    
    // MARK: 注释 : customDelegate
    func zanClick(mediaID:String){
        GDNetworkManager.shareManager.commentAndLike(mediaID: mediaID, isLike: "1", content: nil, { (result ) in
            mylog("点赞结果\(result.status)")
            self.requestData(loadDataType: LoadDataType.initialize)
        }, failure: { (error ) in
            mylog("点赞请求失败 : \(error)")
        })
    }
//    var currentMediaID : String?

    func commentClick(mediaID:String){
        self.currentMediaID = mediaID
//        self.becomeFirstResponder()
        self.textView.becomeFirstResponder()
//        self.privateTextView.isHidden = false
        
    }
    
    func seeMoreCmmments(mediaID:String){
        let model = GDBaseModel.init(dict: nil )
        model.actionkey = "GDMideaDetailVC"
        let keyParamete : [String : String ] = ["circleID":self.circleID ?? "0" , "mediaID":mediaID]
        model.keyparamete = keyParamete as AnyObject
        GDSkipManager.skip(viewController: self , model: model)
        

    }


    func bigImageClickToImageBrowser( model  : GDCircleDetailCellModel){//
        if (model.format ?? "") == "jpeg"  || (model.format ?? "" ) == "png" || (model.format ?? "") == "jpg" {
            
            if let index  =  datas.index(of: model) {
                self.gotoImageBrowser(index: index)
            }
        }else if (model.format ?? "") == "MOV"  || (model.format ?? "") == "mp4" || (model.format ?? "") == "avi"{
            // MARK: 注释 : 替换视频链接movieLink
            if let urlStr  = model.video_url {
                if let url = URL.init(string: urlStr) {
                    let avPlayer : AVPlayer = AVPlayer.init(url: url)
                    avPlayer.play()
                    let avPlayerVC : AVPlayerViewController  = AVPlayerViewController.init()
                    avPlayerVC.player = avPlayer
                    self.present(avPlayerVC, animated: true  , completion: {
                        
                    })
                
                }
            }
            
        }
    }
    
    func gotoImageBrowser(index : Int = 0)  {
        var phtots = [GDIBPhoto]()
        for model  in datas {
            let photo = GDIBPhoto(dict: nil)
            photo.imageURL = model.original
            phtots.append(photo)
        }
        
        GDIBContentView.init(photos: phtots , showingPage : index)
    }
    
    func bigImageClick(mediaID:String){
        self.seeMoreCmmments(mediaID: mediaID)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        if text == "\n" {//点return键走这里
            if self.currentMediaID != nil  {
            GDNetworkManager.shareManager.commentAndLike(mediaID: self.currentMediaID!, isLike: "0", content: self.textView.text, { (result ) in
                mylog("评论成功\(result.data)")
                self.requestData(loadDataType: LoadDataType.initialize)
            }, failure: { (error ) in
                mylog("发表评论请求失败 : \(error)")
            })
            }
            
                
            
            self.textView.text = nil
            self.currentMediaID = nil
            self.textView.resignFirstResponder()
            
            return false
        }else{return true}
    }

    func deleteClick(mediaID:String){
        GDNetworkManager.shareManager.deleteMedia(mediaID: mediaID, { (result ) in
            mylog("删除媒体成功\(String(describing: result.data))")
            if (self.datas.count == 1 ){
            
                self.popToPreviousVC()
            }else{
                self.requestData(loadDataType: LoadDataType.initialize)
            }
        }) { (error ) in
            mylog("删除媒体失败\(error)")
        }
        mylog("删")
    }

     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.textView.resignFirstResponder()
    }
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.textView.resignFirstResponder()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func gotoUserDetail(userID:String)  {
        //            mylog("\(model.title)  \(model.subTitle)  \(model.imageUrl)")
        let skipModel = GDBaseModel.init(dict: nil )
        skipModel.actionkey = "GDUserHistoryVC"
        skipModel.keyparamete =  userID as AnyObject //model.subTitle as AnyObject//用户id
        GDSkipManager.skip(viewController: self , model: skipModel)
    }
}
/*
 //
 //  GDCircleDetailVC.swift
 //  zjlao
 //
 //  Created by WY on 18/04/2017.
 //  Copyright © 2017 com.16lao.zjlao. All rights reserved.
 //
 
 import UIKit
 import MJRefresh
 import AVKit
 class GDCircleDetailVC: GDUnNormalVC  , GDCircleDetailCellDelete , UITextViewDelegate {
 
 // MARK: 注释 : propertis
 var currentPage : Int = 1
 var offset : Int = 0
 var mediaCount : Int = 0
 let inputContainer = UIView()
 lazy var textView  = UITextView()
 var datas  : [GDCircleDetailCellModel] = {
 var tempDatas = [GDCircleDetailCellModel]()
 return tempDatas
 }()
 var circleID : String?
 var currentMediaID : String?//评论用
 
 
 // MARK: 注释 : methods
 override func viewDidLoad() {
 super.viewDidLoad()
 self.naviBar.backgroundColor = UIColor.init(colorLiteralRed: 0.99, green: 0.99, blue: 0.99, alpha: 1)
 
 self.automaticallyAdjustsScrollViewInsets = false
 if let circleIDStr  =  self.keyModel?.keyparamete as? String {
 self.circleID  = circleIDStr
 }
 self.setupTableView()
 self.requestData(loadDataType: LoadDataType.initialize)
 // Do any additional setup after loading the view.
 self.setupTextView()
 }
 
 func setupTextView()  {
 self.inputContainer.addSubview(self.textView)
 self.inputContainer.backgroundColor = UIColor.init(colorLiteralRed: 0.9, green: 0.8, blue: 0.8, alpha: 1)
 self.view.addSubview(self.inputContainer)
 self.textView.enablesReturnKeyAutomatically = true
 self.inputContainer.frame = CGRect(x: 0, y: -SCREENWIDTH, width: SCREENWIDTH, height: SCREENWIDTH * 0.7)
 self.textView.frame = CGRect(x: 10, y: 10, width: self.inputContainer.frame.size.width - 20, height: self.inputContainer.frame.size.height - 20)
 self.textView.returnKeyType = UIReturnKeyType.done
 self.textView.delegate = self
 NotificationCenter.default.addObserver(self , selector: #selector(keyboardWillHide(info:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
 NotificationCenter.default.addObserver(self , selector: #selector(keyboardWillShow(info:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
 }
 
 func keyboardWillHide(info:NSNotification)  {
 var realTime : TimeInterval = 0.25
 let timeInterval = info.userInfo?[UIKeyboardAnimationDurationUserInfoKey]
 if let timeAny  = timeInterval  {
 if let time  = timeAny as? TimeInterval {
 realTime = time
 }
 }
 UIView.animate(withDuration: realTime) {
 self.inputContainer.center = CGPoint(x: self.view.bounds.size.width / 2, y: -self.inputContainer.bounds.size.width / 2 - 20)
 }
 
 }
 func keyboardWillShow(info:NSNotification)  {
 var realTime : TimeInterval = 0.25
 let timeInterval = info.userInfo?[UIKeyboardAnimationDurationUserInfoKey]
 let keyboardEndFrame = info.userInfo?[UIKeyboardFrameEndUserInfoKey] ; // as CGRect
 if let timeAny  = timeInterval  {
 if let time  = timeAny as? TimeInterval {
 realTime = time
 }
 }
 
 if let keyboardFrame = keyboardEndFrame {
 if let keyboardFrameRect = keyboardFrame as? CGRect {
 mylog(keyboardFrameRect)
 UIView.animate(withDuration: realTime) {
 self.inputContainer.center = CGPoint(x: self.view.bounds.size.width / 2, y: keyboardFrameRect.origin.y - self.inputContainer.bounds.size.width / 2)
 }
 }
 
 }
 
 }
 func setupTableView()  {
 //        self.tableView.frame = CGRect(x: 0, y: NavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - NavigationBarHeight)
 self.tableView.backgroundColor = UIColor.init(colorLiteralRed: 0.95, green: 0.95, blue: 0.95, alpha: 1)
 
 self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
 self.tableView.delegate  = self
 self.tableView.dataSource = self
 //        self.tableView.mj_footer = GDRefreshGifFooter(refreshingTarget: self , refreshingAction: #selector(loadMore))
 //        self.tableView.mj_header = GDRefreshHeader(refreshingTarget: self, refreshingAction: #selector(refreshOrInit))
 
 }
 override func loadMore () {
 self.requestData(loadDataType: LoadDataType.loadMore)
 }
 override func refresh()  {
 self.requestData(loadDataType: LoadDataType.initialize)
 }
 
 
 
 
 override func didReceiveMemoryWarning() {
 super.didReceiveMemoryWarning()
 // Dispose of any resources that can be recreated.
 }
 
 
 override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
 return self.datas.count
 }
 
 
 override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
 var cell = tableView.dequeueReusableCell(withIdentifier: "GDCircleDetailCell")
 if cell == nil  {
 cell = GDCircleDetailCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "GDCircleDetailCell")
 }
 if let cellReal  = cell as? GDCircleDetailCell {
 cellReal.model = self.datas[indexPath.row]
 cellReal.cellDelegate  = self
 return cellReal
 }
 return cell!
 }
 
 
 func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
 let model = self.datas[indexPath.row]
 return self.getheight(model: model)
 }
 
 
 
 func getheight (model : GDCircleDetailCellModel) -> CGFloat  {
 var totalHeight : CGFloat = 0
 let iconW  : CGFloat = 44
 let bigImgW = SCREENWIDTH - iconW * 2
 let nameH : CGFloat = 17
 let cellJiange : CGFloat = 10
 
 totalHeight += (bigImgW + nameH)
 let verticalMargin : CGFloat = 10
 
 if model.goods?.count ?? 0 > 0  {
 let zanIconMargin : CGFloat = 2
 let zanIconW = (bigImgW - (8 - 1 ) *  zanIconMargin) /  8
 totalHeight += verticalMargin
 if model.goods?.count ?? 0 <= 8 {
 totalHeight += zanIconW
 } else if model.goods?.count ?? 0 > 8 {
 totalHeight += (zanIconW * 2 + zanIconMargin)
 }
 }
 
 if model.comments?.count ?? 0 > 0 {
 let subViewH : CGFloat = 64
 totalHeight += verticalMargin
 
 if model.comments?.count ?? 0 == 1  {
 totalHeight += subViewH
 }else if model.comments?.count ?? 0 >= 2 {
 totalHeight += (subViewH * 2 + verticalMargin)
 }
 if Int((model.comment_count)!) > 2 {
 let seeMoreH : CGFloat = 20
 totalHeight += (seeMoreH + verticalMargin)
 }
 
 }
 
 return totalHeight + cellJiange
 
 }
 
 
 func requestData(loadDataType:LoadDataType)  {
 
 switch loadDataType {
 case LoadDataType.initialize , LoadDataType.reload:
 self.offset = 0
 break
 case LoadDataType.loadMore:
 break
 }
 
 var tempCircleID = ""
 if let circleID  =  self.keyModel?.keyparamete as? String {
 tempCircleID = circleID
 }else{return}
 GDNetworkManager.shareManager.getCircleMediasList(circleID: tempCircleID, offset: self.offset, { (result) in
 mylog("请求纵向圈子详情结果 : \(result.status)")
 mylog(result.data)
 var tempDatas  : [GDCircleDetailCellModel] = [GDCircleDetailCellModel] ()
 if let infoDict = result.data as? [String : AnyObject]{
 
 var offSet : Int = 0
 var pageSize : Int = 0
 var mediaCount : Int = 0
 if let media_Count = infoDict["mediaCount"] as? Int{
 mediaCount = media_Count
 }
 if let off_set = infoDict["offset"] as? Int{
 offSet = off_set
 }
 if let page_Size = infoDict["pageSize"] as? Int{
 pageSize = page_Size
 }
 self.offset = offSet + pageSize
 if let subMediasArr = infoDict["resultMedia"] as? [[String : AnyObject]]{
 for subMediaDict in subMediasArr{
 let picModel : GDCircleDetailCellModel = GDCircleDetailCellModel.init(dict: subMediaDict)
 tempDatas.append(picModel)
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
 
 override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
 self.textView.resignFirstResponder()
 }
 
 // MARK: 注释 : customDelegate
 func zanClick(mediaID:String){
 GDNetworkManager.shareManager.commentAndLike(mediaID: mediaID, isLike: "1", content: nil, { (result ) in
 mylog("点赞结果\(result.status)")
 self.requestData(loadDataType: LoadDataType.initialize)
 }, failure: { (error ) in
 mylog("点赞请求失败 : \(error)")
 })
 }
 //    var currentMediaID : String?
 
 func commentClick(mediaID:String){
 self.currentMediaID = mediaID
 //        self.becomeFirstResponder()
 self.textView.becomeFirstResponder()
 //        self.privateTextView.isHidden = false
 
 }
 
 func seeMoreCmmments(mediaID:String){
 let model = GDBaseModel.init(dict: nil )
 model.actionkey = "GDMideaDetailVC"
 let keyParamete : [String : String ] = ["circleID":self.circleID ?? "0" , "mediaID":mediaID]
 model.keyparamete = keyParamete as AnyObject
 GDSkipManager.skip(viewController: self , model: model)
 
 
 }
 
 func bigImageClickToImageBrowser( model  : GDCircleDetailCellModel){//
 // MARK: 注释 : original字段可能会换
 if model.original?.hasSuffix("jpeg") ?? false || model.original?.hasSuffix("png") ?? false || model.original?.hasSuffix("jpg") ?? false{
 
 if let index  =  datas.index(of: model) {
 self.gotoImageBrowser(index: index)
 }
 }else if model.original?.hasSuffix("MOV") ?? false  || model.original?.hasSuffix("mp4") ?? false || model.original?.hasSuffix("avi") ?? false{
 // MARK: 注释 : 替换视频链接movieLink
 if let urlStr  = model.original {
 if let url = URL.init(string: urlStr) {
 let avPlayer : AVPlayer = AVPlayer.init(url: url)
 avPlayer.play()
 let avPlayerVC : AVPlayerViewController  = AVPlayerViewController.init()
 avPlayerVC.player = avPlayer
 self.present(avPlayerVC, animated: true  , completion: {
 
 })
 
 }
 }
 
 }
 }
 
 func gotoImageBrowser(index : Int = 0)  {
 var phtots = [GDIBPhoto]()
 for model  in datas {
 let photo = GDIBPhoto(dict: nil)
 photo.imageURL = model.original
 phtots.append(photo)
 }
 
 GDIBContentView.init(photos: phtots , showingPage : index)
 }
 
 func bigImageClick(mediaID:String){
 self.seeMoreCmmments(mediaID: mediaID)
 }
 
 func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
 if text == "\n" {//点return键走这里
 if self.currentMediaID != nil  {
 GDNetworkManager.shareManager.commentAndLike(mediaID: self.currentMediaID!, isLike: "0", content: self.textView.text, { (result ) in
 mylog("评论成功\(result.data)")
 self.requestData(loadDataType: LoadDataType.initialize)
 }, failure: { (error ) in
 mylog("发表评论请求失败 : \(error)")
 })
 }
 
 
 
 self.textView.text = nil
 self.currentMediaID = nil
 self.textView.resignFirstResponder()
 
 return false
 }else{return true}
 }
 
 func deleteClick(mediaID:String){
 GDNetworkManager.shareManager.deleteMedia(mediaID: mediaID, { (result ) in
 mylog("删除媒体成功\(String(describing: result.data))")
 if (self.datas.count == 1 ){
 
 self.popToPreviousVC()
 }else{
 self.requestData(loadDataType: LoadDataType.initialize)
 }
 }) { (error ) in
 mylog("删除媒体失败\(error)")
 }
 mylog("删")
 }
 
 func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 self.textView.resignFirstResponder()
 }
 func scrollViewDidScroll(_ scrollView: UIScrollView) {
 self.textView.resignFirstResponder()
 }
 /*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */
 func gotoUserDetail(userID:String)  {
 //            mylog("\(model.title)  \(model.subTitle)  \(model.imageUrl)")
 let skipModel = GDBaseModel.init(dict: nil )
 skipModel.actionkey = "GDUserHistoryVC"
 skipModel.keyparamete =  userID as AnyObject //model.subTitle as AnyObject//用户id
 GDSkipManager.skip(viewController: self , model: skipModel)
 }
 }

 */
*/
