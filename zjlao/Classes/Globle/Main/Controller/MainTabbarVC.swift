//
//  MainTabbarVC.swift
//  mh824appWithSwift
//
//  Created by wangyuanfei on 16/8/24.
//  Copyright © 2016年 www.16lao.com. All rights reserved.
//

import UIKit

class MainTabbarVC: UITabBarController {
    let mainTabbar  =  MainTabbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTabbar.delegate = self
        setValue(mainTabbar, forKey: "tabBar")
        self.addchileVC()
    }
    
    override  var selectedIndex: Int  {
        set {
            super.selectedIndex = newValue
        }
        get{
            return super.selectedIndex
        }
    
    }
    func addchileVC() -> () {

        self.addChildViewController(HomeVaviVC(rootViewController: HomeVC(vcType: VCType.withoutBackButton)))
        self.addChildViewController(ClassifyNaviVC(rootViewController: ClassifyVC(vcType: VCType.withoutBackButton)))
        self.addChildViewController(LaoNaviVC(rootViewController: LaoVC(vcType: VCType.withoutBackButton)))
        self.addChildViewController(ShopCarNaviVC(rootViewController: ShopCarVC(vcType: VCType.withoutBackButton)))
        self.addChildViewController(ProfileNaviVC(rootViewController: ProfileVC()))
        
        
    }
    
    
    
//     func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool{
//        return true
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
