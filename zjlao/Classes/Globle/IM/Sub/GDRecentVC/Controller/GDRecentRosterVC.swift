//
//  GDRecentRosterVC.swift
//  zjlao
//
//  Created by WY on 17/1/8.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit
import XMPPFramework
class GDRecentRosterVC: GDNormalVC  ,NSFetchedResultsControllerDelegate {

    var recentFriends = [XMPPMessageArchiving_Contact_CoreDataObject]()
    var topArr : [String] = {
        var temp = [String]()
        for  index  in 0 ... 3 {
            switch index {
            case 0:
                temp.append("商城公告")
                break
            case 1:
                temp.append("物流信息")
                break
            case 2:
                temp.append("促销")
                break
            case 3:
                temp.append("活动")
                break
            default:
                break
                
            }
        }
        
        return temp
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: "Recently")
        do {
            try self.recentContactFetchedresultsController.performFetch()
        } catch  {
            mylog("执行失败")
        }
        

        
        let arrOp = self.recentContactFetchedresultsController.fetchedObjects
        if let arr  = arrOp {
            if let arrUsers = arr as?  [XMPPMessageArchiving_Contact_CoreDataObject] {
                self.recentFriends = arrUsers
            }else{
                mylog("数组转换失败")
            }
        }else{
            mylog("取到的联系人为空")
        }
        
        self.recentContactFetchedresultsController.delegate = self
        GDXmppManager.share.xmppRoster.addDelegate(self , delegateQueue: DispatchQueue.main)

        // Do any additional setup after loading the view.
        self.setupTable()
        editMyVCardInfo()
        // Do any additional setup after loading the view.
    }
    func editMyVCardInfo()  {
        //GDXmppManager.share.xmppVCardTempModule.addDelegate(self , delegateQueue: DispatchQueue.main)
        //let myCard = GDXmppManager.share.xmppVCardTempModule.myvCardTemp
    }
    func setupTable ()  {
       // mylog(self.tableView)
        self.tableView.contentInset = UIEdgeInsets(top: NavigationBarHeight, left: 0, bottom: 0, right: 0   )
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0  {
                return self.topArr.count
        }else{
            return self.recentFriends.count
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let str = self.topArr[indexPath.row]
            let cellOp  = tableView.dequeueReusableCell(withIdentifier: "user")
            
            if let cell = cellOp {
                cell.textLabel?.text = str
                return cell
            }else{
                let cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "user")
                cell.textLabel?.text = str
                return cell
            }
        }else{
        
            let user : XMPPMessageArchiving_Contact_CoreDataObject = self.recentFriends[indexPath.row]
            let cellOp  = tableView.dequeueReusableCell(withIdentifier: "user")
            
            if let cell = cellOp {
                cell.textLabel?.text = user.bareJid.user
                return cell
            }else{
                let cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "user")
                cell.textLabel?.text = user.bareJid.user
                return cell
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0  {
            let model = GDBaseModel.init(dict: nil)
            model.actionkey = "webpage"

            if (indexPath.row==0) {
                model.keyparamete = "https://m.zjlao.com/AppOrder/Notice.html" as AnyObject?
            }else if (indexPath.row==1){
                model.keyparamete = "https://m.zjlao.com/AppOrder/logisticsList.html" as AnyObject?
            }else if (indexPath.row==2){
                model.keyparamete = "https://m.zjlao.com/AppOrder/promotion.html" as AnyObject?
            }else if (indexPath.row==3){
                model.keyparamete = "https://m.zjlao.com/AppOrder/activity.html" as AnyObject?
            }
            GDSkipManager.skip(viewController: self , model: model)

        }else{
        
//            self.navigationController?.pushViewController(GDChatVC(), animated: true)
            self.navigationController?.pushViewController(GDTestWebVC(), animated: true)

        }
        
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0  {
            return false
        }else{
            return true
        }
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let contact = self.recentFriends[indexPath.row]
        XMPPMessageArchivingCoreDataStorage.sharedInstance().mainThreadManagedObjectContext.delete(contact)
        do {
            try XMPPMessageArchivingCoreDataStorage.sharedInstance().mainThreadManagedObjectContext.save()
            self.tableView.reloadData()
        } catch  {
            mylog("删除最近联系人失败")
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
    lazy var recentContactFetchedresultsController : NSFetchedResultsController = { () -> NSFetchedResultsController<NSFetchRequestResult> in
        let fetchrequest = NSFetchRequest<NSFetchRequestResult>.init()//查询请求
        let entitys = NSEntityDescription.entity(forEntityName: "XMPPMessageArchiving_Contact_CoreDataObject", in: XMPPMessageArchivingCoreDataStorage.sharedInstance().mainThreadManagedObjectContext)
        fetchrequest.entity = entitys
        let sort  =  NSSortDescriptor(key: "mostRecentMessageTimestamp", ascending: true )
         fetchrequest.sortDescriptors = [sort]
        let temp = NSFetchedResultsController.init(fetchRequest: fetchrequest, managedObjectContext: XMPPMessageArchivingCoreDataStorage.sharedInstance().mainThreadManagedObjectContext, sectionNameKeyPath: nil , cacheName: "Recently")
        //        temp.delegate = self //
        return temp
    }()
    //delegate
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>){
        self.recentFriends = self.recentContactFetchedresultsController.fetchedObjects as! [XMPPMessageArchiving_Contact_CoreDataObject]//解包安全问题
        mylog(self.recentFriends)
        self.tableView.reloadData()
    }
}
