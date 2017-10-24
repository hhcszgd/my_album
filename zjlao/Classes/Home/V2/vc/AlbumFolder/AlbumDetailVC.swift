//
//  AlbumDetailVC.swift
//  zjlao
//
//  Created by WY on 2017/10/24.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit

class AlbumDetailVC: GDBaseVC {
    var albumID : Int  = 0
    
    convenience init(albumID:Int){
        self.init()
        self.albumID = albumID
        self.view.backgroundColor = UIColor.red 
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAlbumDetail()
        // Do any additional setup after loading the view.
    }

    func getAlbumDetail() {
        GDNetworkManager.shareManager.getAlbumDetail(albumID: self.albumID, success: { (model ) in
            print("get album detail result status : \(model.status) , data : \(model.data)")
        }) { (error ) in
            print("get album detail fail : \(error)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(<#T##touches: Set<UITouch>##Set<UITouch>#>, with: <#T##UIEvent?#>)
        GDNetworkManager.shareManager.insertMediaToAlbum(albumID: "\(self.albumID)", original: "Fnl6zK1pf5wfzJod0Y2B7tKq8lji", type: "1", success: { (model ) in
            print("upload media media to album result status : \(model.status) , data : \(model.data)")
        }) { (error ) in
            print(" upload media media to album fail : \(error)")
        }
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
