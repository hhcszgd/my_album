//
//  GDChatVC.swift
//  zjlao
//
//  Created by WY on 17/1/8.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit
import CoreData
import XMPPFramework
class GDChatVC: GDNormalVC , NSFetchedResultsControllerDelegate  , XMPPvCardTempModuleDelegate , UIDynamicAnimatorDelegate{
    var messages  = [XMPPMessageArchiving_Message_CoreDataObject]()
    var toUserJid  : XMPPJID =  XMPPJID(user: "kefu", domain: "jabber.zjlao.com", resource: "iOS")
    var contactFetchedresultsController : NSFetchedResultsController<NSFetchRequestResult>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.testDinamyc()
        //获取当前联系人名片
        let vcard  = GDXmppManager.share.xmppVCardTempModule.vCardTemp(for: self.toUserJid, shouldFetch: true )
        mylog(vcard?.nickname)
        GDXmppManager.share.xmppVCardTempModule.addDelegate(self , delegateQueue: DispatchQueue.main)
        
        NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: "Message")
        _ = self.setupContactFetchedresultsController()
        do {
            try self.contactFetchedresultsController?.performFetch()
            
            self.messages = self.contactFetchedresultsController?.fetchedObjects as! [XMPPMessageArchiving_Message_CoreDataObject]
            mylog(self.messages.count)
        } catch  {
            mylog("shibai")
        }
        

        // Do any additional setup after loading the view.
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
    

    func setupContactFetchedresultsController() -> NSFetchedResultsController<NSFetchRequestResult> {
        if self.contactFetchedresultsController == nil  {
            
            let fetchrequest = NSFetchRequest<NSFetchRequestResult>.init()//查询请求
            let entitys = NSEntityDescription.entity(forEntityName: "XMPPMessageArchiving_Message_CoreDataObject", in: XMPPMessageArchivingCoreDataStorage.sharedInstance().mainThreadManagedObjectContext)
            fetchrequest.entity = entitys ?? nil
            let domain = "@\(self.toUserJid.domain)"
            let source = "/\(self.toUserJid.resource)"
            let bearStr = self.toUserJid.user.appending(domain).appending(source)
            let predicate = NSPredicate.init(format: "bareJidStr = %@", self.toUserJid.bare() as String ) //有疑问
            fetchrequest.predicate = predicate
            
            let sort  =  NSSortDescriptor(key: "timestamp", ascending: true )
            fetchrequest.sortDescriptors = [sort]
            let temp = NSFetchedResultsController.init(fetchRequest: fetchrequest, managedObjectContext: XMPPMessageArchivingCoreDataStorage.sharedInstance().mainThreadManagedObjectContext, sectionNameKeyPath: nil , cacheName: nil )
            temp.delegate = self
            self.contactFetchedresultsController = temp
            return self.contactFetchedresultsController!
        }else{
            return self.contactFetchedresultsController!
        }
        
    }
    var myview  = UIView(frame: CGRect(x: 66, y: 66, width: 88, height: 88))
    var ani : UIDynamicAnimator?
    func testDinamyc() {
        self.view.addSubview(self.myview)
        self.myview.backgroundColor = UIColor.red
        let ani : UIDynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        self.ani = ani
        ani.delegate = self
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       //self.testSnap()
        //self.testGravity()
       self.testCollision()
        //self.testPush()
    }
    func testSnap() {//来回震动//
        let behiver = UISnapBehavior(item: self.myview , snapTo: CGPoint(x: 222, y: 567))
        behiver.damping = 0.1
        behiver.action =  {() in mylog(2)}
        ani!.addBehavior(behiver)
    }
    func testGravity() {//重力行为
        let gravity = UIGravityBehavior(items: [self.myview])
        //gravity.gravityDirection = CGVector(dx: 0 , dy: 1)//方向和速度大小的矢量
        gravity.angle = CGFloat(M_PI_2)//弧度
        gravity.magnitude = 9.8 //重力加速度
//        gravity.setAngle(CGFloat(M_PI), magnitude: 0.8)//动态修改
        self.ani?.addBehavior(gravity)
    }
    func testCollision() {//碰撞(与重力结合使用)//
        let collision = UICollisionBehavior(items: [self.myview])
        collision.collisionMode = UICollisionBehaviorMode.everything
        collision.translatesReferenceBoundsIntoBoundary = true
        //addBoundary(withIdentifier: NSCopying, from: CGPoint, to: CGPoint)
        collision.addBoundary(withIdentifier: "xxx" as NSCopying, from:  CGPoint(x: 0, y: 567), to: CGPoint(x: 222, y: 567))//碰撞边界
        
        let gravity = UIGravityBehavior(items: [self.myview])
        gravity.gravityDirection = CGVector(dx: 0 , dy: 1)//方向和速度大小的矢量
        //gravity.angle = CGFloat(M_PI_2)//弧度
        gravity.magnitude = 9.8 //重力加速度
        //        gravity.setAngle(CGFloat(M_PI), magnitude: 0.8)//动态修改
        self.ani?.addBehavior(gravity)
        self.ani?.addBehavior(collision)
        
//        self.myview.center =  CGPoint(x: 66, y: 666)
        
    }
    func testAttachment() {
//        let attachment = UIAttachmentBehavior(item: <#T##UIDynamicItem#>, attachedTo: <#T##UIDynamicItem#>)
        /*    // 1 可以跟锚点 2 可以item 与 item
         self.attach = [[UIAttachmentBehavior alloc] initWithItem:self.view1 attachedToItem:self.view2];
         self.attach.length = 100;// 距离
         self.attach.damping = 0.3;// 阻尼系数（阻碍变化）
         self.attach.frequency = 0.5;// 振动频率，（变化速度）
         
         //    self.attach.anchorPoint = CGPointMake(100, 100);
         
         [self.animator addBehavior:self.attach];
         // 2者在其他动画作用下保持相互作用力，比如某一个添加重力效果。
         */
    }
    func testPush() {//和重力类似 , 只是没有加速度
        let push = UIPushBehavior(items: [self.myview], mode: UIPushBehaviorMode.continuous)
        push.angle = CGFloat(M_PI_2)//决定方向
        push.magnitude = 85
        //push.pushDirection = CGVector(dx: 0, dy: 1)//也能决定方向0,1向下 , 1,1是45度右下方向 , 1,0是向右 , 1,-1是45度右上 , 0,-1是向上 , -1,0是向左
        push.active = true
        self.ani?.addBehavior(push)
      /*
    self.push = [[UIPushBehavior alloc] init];
    
    self.push.active = YES;// 是否激活
    self.push.angle = M_PI/4;// 方向
    self.push.magnitude = 0.5;// 力
    self.push.pushDirection = CGVectorMake(1, 2);// 矢量
    */
   }
//    lazy var contactFetchedresultsController : NSFetchedResultsController = { () -> NSFetchedResultsController<NSFetchRequestResult> in
//        let fetchrequest = NSFetchRequest<NSFetchRequestResult>.init()//查询请求
//        let entitys = NSEntityDescription.entity(forEntityName: "XMPPMessageArchiving_Message_CoreDataObject", in: XMPPMessageArchivingCoreDataStorage.sharedInstance().mainThreadManagedObjectContext)
//        fetchrequest.entity = entitys ?? nil
//        
//        let predicate = NSPredicate.init(format: "bareJidStr = %@", self.toUserJid.bare() ) //有疑问
//        fetchrequest.predicate = predicate
//        
//        let sort  =  NSSortDescriptor(key: "timestamp", ascending: true )
//        fetchrequest.sortDescriptors = [sort]
//        let temp = NSFetchedResultsController.init(fetchRequest: fetchrequest, managedObjectContext: XMPPMessageArchivingCoreDataStorage.sharedInstance().mainThreadManagedObjectContext, sectionNameKeyPath: nil , cacheName: "Message")
//        return temp
//    }()
    //delegate
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>){
        self.messages = self.contactFetchedresultsController?.fetchedObjects as! [XMPPMessageArchiving_Message_CoreDataObject]
        mylog(self.messages.count)
        //self.tableView.reloadData()
    }
}
