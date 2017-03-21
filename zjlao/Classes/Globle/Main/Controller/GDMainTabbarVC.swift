//
//  GDMainTabbarVC.swift
//  zjlao
//
//  Created by WY on 17/1/15.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit

class GDMainTabbarVC: UITabBarController {

    let mainTabbar  =  GDTabBar.share
    override func viewDidLoad() {
        super.viewDidLoad()
        //mainTabbar.delegate = self
        self.setValue(mainTabbar, forKey: "tabBar")
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
        
        for subVC in self.childViewControllers {
            subVC.removeFromParentViewController()
        }
        self.addChildViewController(HomeVaviVC(rootViewController: HomeVC()))
        self.addChildViewController(ClassifyNaviVC(rootViewController: ClassifyVC()))
        self.addChildViewController(LaoNaviVC(rootViewController: LaoVC()))
        self.addChildViewController(ShopCarNaviVC(rootViewController: ShopCarVC()))
        self.addChildViewController(ProfileNaviVC(rootViewController: ProfileVC()))
        
        
        mylog(self.childViewControllers)
        
    }
    
    func restartAfterChangeLanguage() {
        self.setViewControllers([HomeVaviVC(rootViewController: HomeVC()),ClassifyNaviVC(rootViewController: ClassifyVC()),LaoNaviVC(rootViewController: LaoVC()),ShopCarNaviVC(rootViewController: ShopCarVC()),ProfileNaviVC(rootViewController: ProfileVC())], animated: true)
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
    
}
