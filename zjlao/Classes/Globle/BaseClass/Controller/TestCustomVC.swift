 //
//  TestCustomVC.swift
//  zjlao
//
//  Created by WY on 28/04/2017.
//  Copyright © 2017 com.16lao.zjlao. All rights reserved.
//

import UIKit

class TestCustomVC: GDUnNormalVC {
//    let gdrefresh : GDRefreshControl = GDRefreshControl()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.collectionView.gdRefreshControl?.refreshStatus = GDRefreshStatus.refreshing
        self.collectionView.gdLoadControl?.loadStatus = GDLoadStatus.loading
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.setupTableView()
        self.setupCollection()

        // Do any additional setup after loading the view.
    }
    
    func setupCollection() {
        self.view.addSubview(self.collectionView)
        if let flowLayout  = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: 100, height: 100)
            flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical
            
        }
        self.collectionView.frame = CGRect(x: 0, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT - 44)
        self.collectionView.mj_header = nil
        self.collectionView.mj_footer = nil
        self.collectionView.isPagingEnabled = true
        // MARK: 注释 : refresh
        let gdrefresh : GDRefreshControl = GDRefreshControl(target: self , selector: #selector(collectionViewPerforRefresh))
        gdrefresh.direction = GDDirection.top
        self.collectionView.gdRefreshControl = gdrefresh
        // MARK: 注释 : load
        let gdLoad : GDLoadControl = GDLoadControl(target: self , selector: #selector(load))
        gdLoad.direction = GDDirection.bottom
        self.collectionView.gdLoadControl = gdLoad
    }
    @objc func load()  {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            
            self.collectionView.reloadData()
            self.collectionView.gdLoadControl?.endLoad(result: GDLoadResult.success)
        }
    }
    
    func setupTableView()  {
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.tableView)
        self.tableView.mj_header = nil
        self.tableView.mj_footer = nil 
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.delegate  = self
        self.tableView.dataSource = self
        let gdrefresh : GDRefreshControl = GDRefreshControl(target: self , selector: #selector(tableViewPerforRefresh))
        gdrefresh.direction = GDDirection.top 
        self.tableView.gdRefreshControl = gdrefresh
//        self.gdrefresh.addTarget(self, refreshAction: #selector(refreshOrInit))
//        self.tableView.mj_footer = GDRefreshGifFooter(refreshingTarget: self , refreshingAction: #selector(loadMore))
//        self.tableView.mj_header = GDRefreshHeader(refreshingTarget: self, refreshingAction: #selector(refreshOrInit))
        
    }
    
    @objc func tableViewPerforRefresh()  {
//        cells = 4 + cells
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) { 
            
            self.tableView.reloadData()
            
            self.tableView.gdRefreshControl?.endRefresh(result: GDRefreshResult.success)
        }
        }
    
    @objc  func collectionViewPerforRefresh()  {
                cells = 4 + cells
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            
            self.collectionView.gdRefreshControl?.endRefresh(result: GDRefreshResult.networkError)
            self.collectionView.reloadData()
        }
    }

    func refreshOrInit()  {
        mylog("刷新啦")
        
    }
    override func loadMore()  {
        
    }
    var cells  = 34
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func test() {
//        circleCollection.bounces = true
//        circleCollection.isPagingEnabled = false
//        self.gdrefresh.direction = GDDirection.left
//        self.gdrefresh.scrollView = self.circleCollection
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
