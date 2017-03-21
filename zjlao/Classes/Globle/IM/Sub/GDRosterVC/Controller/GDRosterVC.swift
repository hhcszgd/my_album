//
//  GDRosterVC.swift
//  zjlao
//
//  Created by WY on 17/1/7.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit
import XMPPFramework
class GDRosterVC: GDNormalVC , NSFetchedResultsControllerDelegate , XMPPRosterDelegate{
    var friendList = [XMPPUserCoreDataStorageObject]()
    
    
    let label  = GDMsgIconView.init(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: "Contacts")
        do {
            try self.contactFetchedresultsController.performFetch()
        } catch  {
            mylog("执行失败")
        }
        
        let arrOp = self.contactFetchedresultsController.fetchedObjects
        if let arr  = arrOp {
            if let arrUsers = arr as?  [XMPPUserCoreDataStorageObject] {
                self.friendList = arrUsers
            }else{
                mylog("数组转换失败")
            }
        }else{
            mylog("取到的联系人为空")
        }

        self.contactFetchedresultsController.delegate = self
        GDXmppManager.share.xmppRoster.addDelegate(self , delegateQueue: DispatchQueue.main)
        self.view.addSubview(self.label)
        self.label.backgroundColor = UIColor.cyan
        self.label.center = self.view.center
        // Do any additional setup after loading the view.
        self.setupTable()
    }

    func setupTable ()  {
        mylog(self.tableView)
        self.tableView.contentInset = UIEdgeInsets(top: NavigationBarHeight, left: 0, bottom: 0, right: 0   )
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friendList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user : XMPPUserCoreDataStorageObject = self.friendList[indexPath.row]
        let cellOp  = tableView.dequeueReusableCell(withIdentifier: "user")
        if let cell = cellOp {
            cell.textLabel?.text = user.jid.user
            return cell
        }else{
            let cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "user")
            cell.textLabel?.text = user.jid.user
            return cell
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(GDChatVC(), animated: true)

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    lazy var contactFetchedresultsController : NSFetchedResultsController = { () -> NSFetchedResultsController<NSFetchRequestResult> in
        let fetchrequest = NSFetchRequest<NSFetchRequestResult>.init()//查询请求
        let entitys = NSEntityDescription.entity(forEntityName: "XMPPUserCoreDataStorageObject", in: XMPPRosterCoreDataStorage.sharedInstance().mainThreadManagedObjectContext)
        fetchrequest.entity = entitys ?? nil
        let predicate = NSPredicate.init(format: "subscription = %@", "both") //有疑问
        fetchrequest.predicate = predicate
        
        let sort  =  NSSortDescriptor(key: "jidStr", ascending: true )
        fetchrequest.sortDescriptors = [sort]
        let temp = NSFetchedResultsController.init(fetchRequest: fetchrequest, managedObjectContext: XMPPRosterCoreDataStorage.sharedInstance().mainThreadManagedObjectContext, sectionNameKeyPath: nil , cacheName: "Contacts")
        return temp
    }()
    //delegate
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>){
        self.friendList = self.contactFetchedresultsController.fetchedObjects as! [XMPPUserCoreDataStorageObject]
        mylog(self.friendList)
        self.tableView.reloadData()
    }
}
