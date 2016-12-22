//
//  GDScene.swift
//  zjlao
//
//  Created by WY on 16/12/20.
//  Copyright © 2016年 com.16lao.zjlao. All rights reserved.
//

import UIKit
import SpriteKit
class GDScene: SKScene {
    
    private var contentCreated:Bool  = false
    override func didMove(to view: SKView) {
        
        //判断是否是第一次创建
        if(!self.contentCreated){
            //置位 以后就不会在执行这里的代码拉
            self.contentCreated = true
            
            //创建一个节点 但是是label的节点！ 字体是Chalkduster
            let helloNode = SKLabelNode(fontNamed: "Chalkduster")
            helloNode.text = "Hello Wolrd"
            helloNode.fontSize = 22
            helloNode.name = "helloNode"
            
            //位置是放在屏幕中间
            helloNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
//            helloNode.position = CGPoitMake(CGRectGetMidX(self.frame),
//                                            CGRectGetMidY(self.frame))
//            self.backgroundColor = SKColor.blueColor()
            self.backgroundColor = SKColor.clear
            self.scaleMode = SKSceneScaleMode.aspectFit
            //添加进去
            self.addChild(helloNode)
        } 
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //记住 返回的是可选类型SKNode? 有可能得到nil  所以你要解包
        //比如你要查找的节点名字拼错就意味着找不到 等于nil
        if let helloNode = childNode(withName: "helloNode"){
            //纯手打，不对之处见谅
            
            //在x，y方向上移动相对举例，比如原来在(0,100) 执行下面之后是(0,200)
            //moveTo才是移动到具体某个位置
            let moveUp = SKAction.moveBy(x: 0, y: 100, duration: 0.5)
            
            //放大操作
            let zoom = SKAction.scale(to: 2.0, duration: 0.25)
            //延迟
            let pause = SKAction.wait(forDuration: 0.5)
            //说白了就是透明度最终变0，即渐隐
            let fadeAway = SKAction.fadeOut(withDuration: 0.25)
            //从节点树种移除该节点
            let remove = SKAction.removeFromParent()
            let moveSequence = SKAction.sequence([moveUp,zoom,pause , fadeAway , remove])
//            let moveSequence = SKAction.sequence[moveUp,zoom,
//                                                 pause,fadeAway,remove]
            helloNode.run(moveSequence, completion: { 
            
                //实例化一个宇宙飞船场景实例！！
                let spaceshipScene = GDSKSceneA(size: (self.view?.frame.size)!)
                //创建一个新的场景过渡方式
                let doors = SKTransition.doorsOpenVertical(withDuration: 0.5)
                //呈现
                self.view?.presentScene(spaceshipScene, transition: doors)
            })
//            helloNode.run(moveSequence)
//            helloNode.runAction(moveSequence)
        }

    }


}
/*
 用法
 func setupSence ()  {
 let w  : CGFloat = 300.0
 let h : CGFloat  = 500.0
 let x = (self.view.bounds.size.width - w ) / 2
 let y = (self.view.bounds.size.height - h) / 2
 let spriteView = SKView(frame: CGRect(x: x, y: y, width: w, height: h))
 spriteView.backgroundColor = UIColor.blue
 spriteView.showsDrawCount = true    //显示绘制次数
 spriteView.showsNodeCount = true    //显示当前节点数 越少越好
 spriteView.showsFPS = true          //显示帧数
 
 let sence = GDScene(size: CGSize(width: spriteView.bounds.size.width, height: spriteView.bounds.size.height))
 //        sence.position = self.view.center // Setting the position of a SKScene has no effect.
 spriteView.presentScene(sence)
 self.view.addSubview(spriteView)
 }
 
 */
