//
//  GDMapVC.swift
//  zjlao
//
//  Created by WY on 17/3/22.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit

class GDMapVC: GDNormalVC {
    var mapView : GDMapInView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMapView()

        // Do any additional setup after loading the view.
    }
    func setupMapView()  {
        let mapview = GDMapInView.init(frame: CGRect(x: 0, y: 64, width: self.view.bounds.size.width, height: self.view.bounds.size.height - 49 - 64))
        self.mapView = mapview
        self.view.addSubview(mapview)
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

}
