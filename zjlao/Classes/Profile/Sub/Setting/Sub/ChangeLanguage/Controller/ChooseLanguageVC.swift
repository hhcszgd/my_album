//
//  ChooseLanguageVC.swift
//  zjlao
//
//  Created by WY on 16/10/19.
//  Copyright © 2016年 WY. All rights reserved.
//

import UIKit

import MJRefresh
class ChooseLanguageVC: GDNormalVC/*,UITableViewDelegate ,*/ /*, UITableViewDataSource */{
    let languages : [String] = [LFollowSystemLanguage,LEnglish,LChinese,"Japanese","aa","bb","cc","dd","ee","ff","gg","hh","ii","jj","kk","ll","mm","nn","oo","pp","qq","rr","ss","tt","uu","vv","ww","xx","yy","zz"]
    let bottomButton = UIButton()
//    let tableView = BaseTableView(frame: CGRect.zero, style: UITableViewStyle.plain)
    var  currentIndexPath = IndexPath(row: 0, section: 0)
    var choosedIndexPaths = [String : IndexPath]()
    
    var selectedLanguage : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.naviBar.currentBarActionType = .color//.alpha //.offset // 
        self.naviBar.layoutType = .desc
        self.automaticallyAdjustsScrollViewInsets = false
        self.setupSubViews()
        self.view.addSubview(bottomButton)
//        self.view.addSubview(tableView)
//        self.naviBar.currentBarStatus = .disapear
        // Do any additional setup after loading the view.
    }

    func setupSubViews()  {
        self.tableView.mj_header = GDRefreshHeader(refreshingTarget: self , refreshingAction:  #selector(refresh))
        self.tableView.mj_footer = GDRefreshBackFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
        let margin : CGFloat = 20.0
        
        let btnW : CGFloat = GDDevice.width - margin * 2
        let btnH : CGFloat = 44
        let btnX : CGFloat = margin
        let btnY : CGFloat = GDDevice.height - margin - btnH
        self.bottomButton.frame = CGRect(x: btnX, y: btnY, width: btnW, height: btnH)
        
        let tableViewX : CGFloat = 0
//        let tableViewY : CGFloat = NavigationBarHeight
        let tableViewY : CGFloat = 0
        let tableViewW : CGFloat = GDDevice.width
        let tableViewH : CGFloat = btnY - tableViewY - margin
        self.tableView.frame = CGRect(x: tableViewX, y: tableViewY, width: tableViewW, height: tableViewH)
//        self.tableView.contentInset  = UIEdgeInsetsMake(NavigationBarHeight, 0, 20, 0)
        self.tableView.backgroundColor = UIColor.randomColor()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        self.bottomButton.embellishView(redius: 5)
        self.bottomButton.backgroundColor = UIColor.red
        self.bottomButton.setTitle(GDLanguageManager.titleByKey(key: "confirm"), for: UIControlState.normal)
        self.bottomButton.addTarget(self, action: #selector(sureClick(sender:)), for: UIControlEvents.touchUpInside)

        
    }
    override func refresh ()  {
        self.tableView.mj_header.endRefreshing()
        self.tableView.mj_footer.state = MJRefreshState.idle
    }
    override func loadMore ()  {
        self.tableView.mj_footer.endRefreshingWithNoMoreData()
    }
    //MARK:UITableViewDelegate and UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.languages.count ;
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell  = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil  {
            cell = BaseCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = self.languages[indexPath.row]
        return cell ?? BaseCell()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentStr = "\(indexPath.row)"
        if  let _ = self.choosedIndexPaths[currentStr] {//键能找到值
            self.choosedIndexPaths.removeValue(forKey: currentStr)
        }else{//找不到就加进去
            self.choosedIndexPaths[currentStr] = indexPath
        }
        
        
        self.currentIndexPath = indexPath
        self.selectedLanguage = self.languages[indexPath.row]
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         let currentStr = "\(indexPath.row)"
        if  let _ = self.choosedIndexPaths[currentStr] {
            return 66
        }else{return 33}
        
    }
    //MARK:customMethod
    func sureClick(sender : UIButton) {
        mylog(GDStorgeManager.standard.object(forKey: "AppleLanguages"))
        mylog(GDLanguageManager.gotcurrentSystemLanguage())
        if self.selectedLanguage == "" {
            GDAlertView.alert("请选择目标语言", image: nil, time: 2, complateBlock: nil)
            return
        }
        GDLanguageManager.performChangeLanguage(targetLanguage: self.selectedLanguage)
//        (UIApplication.shared.delegate as? AppDelegate)?.performChangeLanguage(targetLanguage: self.selectedLanguage)//更改语言

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        mylog(scrollView.contentOffset)
//        mylog(scrollView.contentSize)
//        mylog(scrollView.bounds.size)
//        self.naviBar.currentBarActionType = .alpha
//        self.naviBar.layoutType = .desc
        self.naviBar.change(by: scrollView)
//        self.naviBar.changeWithOffset(offset: (scrollView.contentOffset.y + 64) / scrollView.contentSize.height)
//        self.naviBar.changeWithOffset(offset: scrollView.contentOffset.y, contentSize: scrollView.contentSize)

    }

}
