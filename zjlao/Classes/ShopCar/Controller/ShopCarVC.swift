//
//  ShopCarVC.swift
//  mh824appWithSwift
//
//  Created by wangyuanfei on 16/8/24.
//  Copyright © 2016年 www.16lao.com. All rights reserved.
/*购物车在选择的时候 , 先通过商品的模型取出店铺id 进行店铺遍历 , 拿到匹配的店铺后 , 对店铺里的商品进行遍历 , 遍历到了就break跳出循环*/
/*在选择商品时的遍历方式  , 选择商品以后把选中的商品的模型放入 选中商品的字典 , 以商品购物车id为键 , 模型为值 , 然后刷新 , 在数据源方法里 , 已模型的购物车id为键 取模型 , 取到的话就设置当前模型的选中字段为true , 否则就是false */
/*在选择店铺时的遍历方式 , 选择店铺以后把店铺的模型放在 选中店铺的字典中 , 以店铺id为键 , 模型为值 , 然后刷新 , 再数据源方法里 , 优先以店铺id为键 ,取店铺模型 , 如果取到 , 就把店铺id对应的商品 选中状态为true ,else  执行选中商品时 数据源方法中的操作流程*/

/**点击编辑按钮批量加入收藏 和删除商品  ,  同时可以修改数量 和 属性 , 但测试不能侧滑*/
/**商品标题最多两行 , 规格上方紧挨着标题下方 , 无论是一行还是两行*/
/**规格右方始终有一个下拉按钮 , 以修改规格*/
/**失效商品以类店铺的形式展示出来*/
import UIKit

class ShopCarVC: VCWithNaviBar {

    let shopDict = [String :AnyObject]()
    let goodDict = [String :AnyObject]()
    func operatorTheSelectGoodOrShop(model: [String :AnyObject]) -> () {
        
        //优先遍历shopDict
        
        if let shopID =  model["shopID"] as? String  {//取出当前模型的shopid
            if  shopDict["shopID"] as! String == shopID {//先拿shopid 去shopdict字典取模型 ,1 如果取到 , 就设置当前model的select 为true    2 取不到 , 为false
                
            }else{//取不到的话 , 再拿当前模型的goodID当键  去gooddict 中取   , 1 ,取到 选中, 2 , 取不到 非选中
            
            }
        }else{
        
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gotShopCarData(type: LoadDataType.initialize, { (model) in }) { (error ) in }
        self.attritNavTitle = NSAttributedString.init(string: GDLanguageManager.titleByKey(key: LTabBar_shopcar));  //gotTitleStr(key: "tabBar_shopcar")!)
        self.view.backgroundColor = UIColor.green
    }
    func gotShopCarData(type : LoadDataType , _ success : @escaping (_ result : OriginalNetDataModel) -> () , failure : @escaping (_ error : NSError) -> ()) {
        switch type {
        case .initialize , .reload:
            NetworkManager.shareManager.gotShopCarData({ (originalNetDataModel) in
                
                if (true){/**选项卡栏显示,布局*/
                    guard let dataAnyObj = originalNetDataModel.data else{
                        GDAlertView.alert("购物车为空", image: nil , time: 2, complateBlock: nil)
                        return
                    }
                }else{//如果隐藏
                
                }
                
            }) { (error) in
                mylog(error)
                GDAlertView.alert("购物车获取失败", image: nil , time: 2, complateBlock: nil)

            }
            break
     
        case .loadMore:
            
            break
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
//        alert("a;lskdjfla", image: UIImage(named:"icon_payfail")!, time: 2) {
            
//        }
//        GDAlertView.alert11(nil, image: nil, time: 2, complateBlock: nil)
        GDAlertView.alert("dalskdfj", image: nil, time: 2) {
            mylog("点击了购物车")
        }
        
        
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
