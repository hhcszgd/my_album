//
//  GDMapInView.swift
//  zjlao
//
//  Created by WY on 17/3/18.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit
import MapKit

class GDMapInView: UIView , MKMapViewDelegate {
    var mapView : GDMapView? = GDMapView()

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.testMapView()
        GDLocationManager.share.gotCurrentLocation { (result , error) in
            mylog(result)
            mylog(error)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func testMapView()  {
        
        let  map = GDMapView(frame: CGRect(x: 0, y: 64, width: self.bounds.size.width, height: self.bounds.size.height - 49 - 64))
        map.showsUserLocation = true
        map.delegate = self
        if #available(iOS 9.0, *) {
            map.showsScale = true
        } else {
            // Fallback on earlier versions
        }//比例尺
        if #available(iOS 9.0, *) {
            map.showsTraffic = true
        } else {
            // Fallback on earlier versions
        }
        self.mapView = map
        if #available(iOS 9.0, *) {
            self.mapView?.showsCompass = true
        } else {
            // Fallback on earlier versions
        }
//        map.userLocation//用户当前位置
        self.addSubview(self.mapView!)
    }
    //防止内存占用过高
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        //        switch <#value#> {
        //        case <#pattern#>:
        //            <#code#>
        //        default:
        //            <#code#>
        //        }
        let type = mapView.mapType
        switch (type) {
        case MKMapType.hybrid:
            
            self.mapView?.mapType = MKMapType.standard;
            
            
            break;
        case MKMapType.standard:
            
            self.mapView?.mapType = MKMapType.hybrid;
            
            
            break;
        default:
            break;
        }
        self.mapView?.mapType = MKMapType.standard;
        
    }
    
    
    //实时获取用户位置代理
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation){
        mapView.setCenter(userLocation.coordinate, animated: true)//设置当前位置到屏幕中心
        let span :  MKCoordinateSpan = MKCoordinateSpan.init(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let  region: MKCoordinateRegion = MKCoordinateRegion.init(center: userLocation.coordinate, span: span)
        mapView.setRegion(region, animated: true)//当region改变的时候设置这些
    }
    

}
