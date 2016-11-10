//
//  LaoVC.swift
//  mh824appWithSwift
//
//  Created by wangyuanfei on 16/8/24.
//  Copyright © 2016年 www.16lao.com. All rights reserved.
//

import UIKit

import CoreLocation

class LaoVC: VCWithNaviBar {
    
    let layer = CAGradientLayer();
    
    let geoCoder = CLGeocoder.init()
    
    let clMar = GDLocationManager.init()
    
//    var  startx  = 0.0 ;
//    var  starty = 0.0
//    var endx = 1.0
//    var endy = 1.0
    
    var i = 0
    var type = "+"
    
    var theReturnType = ""

    func rotate() -> () {

//        var i = 0
//        var type = "+"
//        
//        var theReturnType = ""
        
        repeat{
           
            
            theReturnType = self.returnType(i)
            if theReturnType == "+" {
                 i += 1
                type = "+"
            }else if theReturnType == "-"{
                i -= 1
                type = "-"
            }else if theReturnType == "."{
                if type == "+" {
                    i += 1
                }
                if type == "-" {
                    i -= 1
                }
            }
            
            self.view.alpha = CGFloat(10 - i) / 10.0
            
//            self.layer.startPoint = CGPointMake(0 , 0)
//            self.layer.endPoint = CGPointMake(CGFloat(10 - i) / 10.0, CGFloat(10 - i) / 10.0)
            
            print(i)
            
//            UIView.animateWithDuration(0.0001, delay: 0, options: UIViewAnimationOptions.Repeat, animations: {
//                self.layer.startPoint = CGPointMake( CGFloat( i) / 10.0 , CGFloat( i) / 10.0)
//                self.layer.endPoint = CGPointMake(CGFloat(10 - i) / 10.0, CGFloat(10 - i) / 10.0)

//                }, completion: nil )
            
//            UIView.animateWithDuration(0.001, delay: 0, options: UIViewAnimationOptions.Repeat, animations: {
//                
//                self.layer.startPoint = CGPointMake( CGFloat( i) / 10.0 , CGFloat( i) / 10.0)
//                self.layer.endPoint = CGPointMake(CGFloat(10 - i) / 10.0, CGFloat(10 - i) / 10.0)
//            }){ (true) in
//                
//            }
            
        } while true
        
        
        
        
        


        
        
        
    }
    
    func returnType (_ i : Int) -> String  {
        if i<=0 {
            return "+"
        } else if i>=10 {
            return "-"
        }
        return "."
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = "lao"
//        self.title = NSLocalizedString("tabBar_lao", tableName: nil, bundle: Bundle.main, value:"", comment: "")
        self.attritNavTitle = NSAttributedString.init(string: GDLanguageManager.titleByKey(key: "tabBar_shopcar") /*gotTitleStr(key: "tabBar_shopcar")!*/)

        self.view.backgroundColor = UIColor.blue
//        let layer = CAGradientLayer();
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        let startColor = UIColor.red.cgColor
        let midColor  = UIColor.green.cgColor
        let endColor = UIColor.blue.cgColor
        layer.colors = [startColor,midColor,endColor]
        layer.frame = self.view.bounds
        self.view.layer.addSublayer(layer)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.clMar.start(call: {str , err in
            mylog(str)
        
        })
/*///        self.rotate()
//        NumberTool.init().callback = {(i) in
//                    UIView.animateWithDuration(4, delay: 0, options: UIViewAnimationOptions.Repeat, animations: {
//            
//                        var start =  CGPointMake(0, CGFloat(10 - i) / 10.0)
//                        var end = CGPointMake(CGFloat( i) / 10.0,0)
//                        self.layer.startPoint = start
//                        self.layer.endPoint = end
//                        
//                        print("这是起点\(start)")
//                        print("这是终点\(end)")
//                        
//                    }){ (true) in
//                        
//                    }
//        }


//        self.geoCoder.geocodeAddressString("北京") { (CLPlacemarkArr, error) in
//            //CLPlacemark
//            let placemark = CLPlacemarkArr?.first
//            mylog(placemark?.name)
//            
//        }//
        let zhengzhou = CLLocation.init(latitude:34.7 , longitude:113.6 )
        let beijing =  CLLocation.init(latitude:40.0 , longitude:116.0 )
        self.geoCoder.reverseGeocodeLocation(beijing) { (CLPlacemarkArr, error) in
            let placemark = CLPlacemarkArr?.first
            
            /*    location             : CLLocation 类型, 位置对象信息, 里面包含经纬度, 海拔等等
             region                 : CLRegion 类型, 地标对象对应的区域
             addressDictionary  : NSDictionary 类型, 存放街道,省市等信息
             name                : NSString 类型, 地址全称
             thoroughfare        : NSString 类型, 街道名称
             locality            : NSString 类型, 城市名称//不太准 , 也可能是乡
             administrativeArea : NSString 类型, 省名称 //也可能是直辖市名 //
             country                : NSString 类型, 国家名称
             subLocality ://区
             
             取 addressDictionary 最靠谱
             addressDictionary["Country"] //国家
             addressDictionary["State"] //省/直辖市
             addressDictionary["City"] //城市
             addressDictionary["SubLocality"] //区
             addressDictionary["Name"] //乡镇
             addressDictionary["CountryCode"] //国家码(中国的是CN)
             
             addressDictionary["FormattedAddressLines"] //格式化后的全部地址 (是个数组,  .first取第一个)
             */
            mylog("name : \(placemark?.name)")
            mylog("thoroughfare : \(placemark?.thoroughfare)")
            mylog("locality : \(placemark?.name)")
            mylog("administrativeArea : \(placemark?.administrativeArea)")
            mylog("country : \(placemark?.country)")
            mylog("postalCode : \(placemark?.postalCode)")
 
            mylog("isoCountryCode : \(placemark?.isoCountryCode)")
            mylog("subAdministrativeArea : \(placemark?.subAdministrativeArea)")
            mylog("subLocality : \(placemark?.subLocality)")//区
            mylog("addressDictionary : \(placemark?.addressDictionary)")//区
            /*addressDictionary : Optional([AnyHashable("Country"): 中国, AnyHashable("City"): 郑州市, AnyHashable("Name"): 侯寨乡, AnyHashable("State"): 河南省, AnyHashable("FormattedAddressLines"): <__NSArrayM 0x60000024d140>(
            中国河南省郑州市二七区侯寨乡
             
             addressDictionary : Optional([AnyHashable("Country"): 中国, AnyHashable("City"): 北京市, AnyHashable("Name"): 妙峰山镇, AnyHashable("State"): 北京市, AnyHashable("FormattedAddressLines"): <__NSArrayM 0x600000056320>(
             中国北京市门头沟区妙峰山镇
             )
             , AnyHashable("CountryCode"): CN, AnyHashable("SubLocality"): 门头沟区])
            )*/
            
            let  resultArrM = placemark?.addressDictionary?["FormattedAddressLines"] as? [AnyObject]
            if let formatterStr  = resultArrM?.first {
                if let Str = formatterStr as? String {
                    mylog(Str)
                }
            }
            
            mylog(error)
        }
 */
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
