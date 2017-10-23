//
//  AlbumHomeVC.swift
//  zjlao
//
//  Created by WY on 2017/10/23.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit
import SnapKit
class AlbumHomeVC: GDBaseVC {

   
    let tipsLabel = UILabel.init(frame: CGRect(x: 0, y: 200, width: SCREENWIDTH, height: 44))
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "茄子云相册"
        self.view.backgroundColor = UIColor.white
        self.configNavigationBar()
        self.testAPI()
        self.configSubviews()
        // Do any additional setup after loading the view.
    }
    func configSubviews() {
        self.view.addSubview(self.tipsLabel)
        self.tipsLabel.textAlignment = NSTextAlignment.center
        self.tipsLabel.textColor = UIColor.lightGray
        self.tipsLabel.numberOfLines = 2
        self.tipsLabel.text = "您还没有建立相册\n点击右上角+,新建相册"
        self.tipsLabel.snp.makeConstraints { (make ) in
            make.left.right.equalToSuperview()
            make.height.equalTo(48)
            make.top.equalToSuperview().offset(200)
        }
    }
    func configNavigationBar() {
        //        let left = UIBarButtonItem.init(image: UIImage(named:""), style: UIBarButtonItemStyle.plain, target: self , action: #selector(iconClick))
        //        self.navigationController?.navigationItem.leftBarButtonItem = left
        let icon = UIButton.init(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
        icon.addTarget(self , action: #selector(iconClick), for: UIControlEvents.touchUpInside)
        icon.backgroundColor = UIColor.red
        icon.layer.masksToBounds = true
        icon.layer.cornerRadius = 17
        let left = UIBarButtonItem.init(customView: icon)
        self.navigationItem.leftBarButtonItems = [left]
        
        let add  = UIButton.init(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
        add.addTarget(self , action: #selector(addClick), for: UIControlEvents.touchUpInside)
        add.backgroundColor = UIColor.green
        let right1 = UIBarButtonItem.init(customView: add )
        
        
        let sift  = UIButton.init(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
        sift.addTarget(self , action: #selector(siftClick), for: UIControlEvents.touchUpInside)
        sift.backgroundColor = UIColor.blue
        let right2 = UIBarButtonItem.init(customView: sift)
        self.navigationItem.rightBarButtonItems = [right1 , right2]
    }
    @objc func iconClick() {
        print("\(#file)")
    }
    @objc func addClick() {
        let addVc = CreatAlbumVC()
        addVc.title = "新建相册"
        self.navigationController?.pushViewController(addVc, animated: true )
        print("\(#file)")
    }
    @objc func siftClick() {
        print("\(#file)")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func testAPI() {
        GDNetworkManager.shareManager.getUserInfomation(userID: Account.shareAccount.member_id ?? "", success: { (result ) in
            print("get user info result status:\(result.status ) , data: \(result.data )")
        }) { (error ) in
            print("get user info error \(error)")
        }
        
        GDNetworkManager.shareManager.getAlbums(album_type: 0, create_at: "2017-10-22 10:00:01", page: 1, success: { (result ) in
            print("get albums result status : \(result.status) , data :  \(result.data)")
        }) { (error ) in
            print("get albums error \(error)")
        }
    }
}
