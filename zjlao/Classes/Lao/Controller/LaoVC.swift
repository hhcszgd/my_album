//
//  LaoVC.swift
//  mh824appWithSwift
//
//  Created by wangyuanfei on 16/8/24.
//  Copyright © 2016年 www.16lao.com. All rights reserved.
//

import UIKit

import CoreLocation
import MJRefresh
class LaoVC: GDNormalVC {
    
    let layer = CAGradientLayer();
    let clMar = GDLocationManager.init()
    var datas = [0]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.attritNavTitle = NSAttributedString.init(string: GDLanguageManager.titleByKey(key: LTabBar_lao) /*gotTitleStr(key: "tabBar_shopcar")!*/)
        self.view.backgroundColor = UIColor.blue
        self.setupCollectionView()
        self.setupNotification()
    }
    func setupCollectionView() {
//        collectoinView.collectionViewLayout
        collectionView.contentInset  = UIEdgeInsetsMake(NavigationBarHeight, 0, self.TabBarHeight, 0)
        mylog(collectionView)
    }
    func jianbian()  {
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        let startColor = UIColor.red.cgColor
        let midColor  = UIColor.green.cgColor
        let endColor = UIColor.blue.cgColor
        layer.colors = [startColor,midColor,endColor]
        layer.frame = self.view.bounds
        self.view.layer.addSublayer(layer)
    }
    func gotLocation() {
        self.clMar.start(call: {str , err in
            mylog(str)
        })
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.datas.count
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.naviBar.change(by: scrollView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    override func setupContentAndFrame() {
        self.attritNavTitle = NSAttributedString.init(string: GDLanguageManager.titleByKey(key: LTabBar_lao) /*gotTitleStr(key: "tabBar_shopcar")!*/)

    }

    override func loadMore() {
            
        self.collectionView.mj_footer.state = MJRefreshState.idle
        for _  in 0...4 {
            
            self.datas.append( self.datas.last ?? 0 + 1   )
        }
        self.collectionView.insertItems(at:[IndexPath(item: self.datas.count-5, section: 0),IndexPath(item: self.datas.count-4, section: 0),IndexPath(item: self.datas.count-3, section: 0),IndexPath(item: self.datas.count-2, section: 0),IndexPath(item: self.datas.count-1, section: 0)] )
    
    }
    func setupNotification()  {
        NotificationCenter.default.addObserver(self , selector: #selector(laotabBarReclick), name: GDLaoTabBarReclick, object: nil )
    }
    func laotabBarReclick()  {
        
        mylog("lao重复点击")
    }
    deinit  {
        NotificationCenter.default.removeObserver(self)
    }
}
