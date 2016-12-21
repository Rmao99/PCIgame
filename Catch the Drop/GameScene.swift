//
//  MainMenuScene.swift
//  Catch the Drop
//
//  Created by Richard and Smayra on 5/15/16.
//  Copyright © 2016 Project Concern International. All rights reserved.
//

import SpriteKit

class GameScene : SKScene
{
    var playBtn: SKNode! = nil
    var linkBtn: UIButton!
    var registerBtn: UIButton!
    var donateBtn: UIButton!
    
    override func didMoveToView(view: SKView) {
        
        let viewSize:CGSize = view.bounds.size
        
        let BG = SKSpriteNode(imageNamed: "BG")
        BG.position = CGPoint(x: viewSize.width/2+50, y: viewSize.height/2)
        BG.zPosition = 0
        
        BG.size.height = viewSize.height
        BG.size.width = viewSize.width + 100
        
        let myLabel = SKLabelNode(fontNamed: "Chalkduster")
        myLabel.fontColor = UIColor.blackColor()
        myLabel.text = "Catch The Drop"
        myLabel.fontSize = 35
        myLabel.position = CGPoint(x: viewSize.width/2, y: viewSize.height * 0.8)
        myLabel.zPosition = 1
        
        playBtn = SKSpriteNode(imageNamed: "playBtn")
        playBtn.position = CGPoint(x: viewSize.width/2, y: viewSize.height/2+100)
        playBtn.name = "playBtn"
        playBtn.zPosition = 1
        
        
        linkBtn = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width / 3, height: 60))
        linkBtn.center = CGPoint(x : view.frame.size.width / 2, y: view.frame.size.width / 2 + 200)
        linkBtn.backgroundColor = UIColor.clearColor()
        linkBtn.setTitle("About us", forState: UIControlState.Normal)
        linkBtn.layer.cornerRadius = 10
        linkBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        linkBtn.layer.borderWidth = 1
        linkBtn.layer.borderColor = UIColor.blackColor().CGColor
        linkBtn.addTarget(self, action: Selector("hyperlink1"), forControlEvents: UIControlEvents.TouchUpInside)
        linkBtn.addTarget(self, action: Selector("hyper1Clicked"), forControlEvents: UIControlEvents.TouchDown)
        linkBtn.addTarget(self, action: Selector("hyper1NotClicked"), forControlEvents: UIControlEvents.TouchDragExit)
        self.view?.addSubview(linkBtn)
        UIView.animateWithDuration(0.6 ,
            animations: {
                self.linkBtn.transform = CGAffineTransformMakeScale(0.6,0.6)
            },
            completion:{ finish in
                UIView.animateWithDuration(0.6){
                    self.linkBtn.transform = CGAffineTransformIdentity
                }
                
        })
        
        registerBtn = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width / 3, height: 60))
        registerBtn.center = CGPoint(x : view.frame.size.width / 2, y: view.frame.size.width / 2 + 300)
        registerBtn.backgroundColor = UIColor.clearColor()
        registerBtn.setTitle("Register", forState: UIControlState.Normal)
        registerBtn.layer.cornerRadius = 10
        registerBtn.layer.borderWidth = 1
        registerBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        registerBtn.layer.borderColor = UIColor.blackColor().CGColor
        registerBtn.addTarget(self, action: Selector("hyperlink2"), forControlEvents: UIControlEvents.TouchUpInside)
        registerBtn.addTarget(self, action: Selector("hyper2Clicked"), forControlEvents: UIControlEvents.TouchDown)
        registerBtn.addTarget(self, action: Selector("hyper2NotClicked"), forControlEvents: UIControlEvents.TouchDragExit)
        self.view?.addSubview(registerBtn)
        UIView.animateWithDuration(0.7 ,
            animations: {
                self.registerBtn.transform = CGAffineTransformMakeScale(0.6,0.6)
            },
            completion:{ finish in
                UIView.animateWithDuration(0.6){
                    self.registerBtn.transform = CGAffineTransformIdentity
                }
                
        })
      
        donateBtn = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width / 3, height: 60))
        donateBtn.center = CGPoint(x : view.frame.size.width / 2, y: view.frame.size.width / 2+400)
        donateBtn.backgroundColor = UIColor.clearColor()
        donateBtn.layer.cornerRadius = 10
        donateBtn.layer.borderWidth = 1
        donateBtn.layer.borderColor = UIColor.clearColor().CGColor
        donateBtn.setTitle("Donate", forState: UIControlState.Normal)
        donateBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        //donateBtn.font = UIFont(name: "ChalkDuster", size: 20)!
        donateBtn.layer.borderColor = UIColor.blackColor().CGColor
        donateBtn.addTarget(self, action: Selector("hyperlink3"), forControlEvents: UIControlEvents.TouchUpInside)
        donateBtn.addTarget(self, action: Selector("hyper3Clicked"), forControlEvents: UIControlEvents.TouchDown)
        donateBtn.addTarget(self, action: Selector("hyper3NotClicked"), forControlEvents: UIControlEvents.TouchDragExit)
        self.view?.addSubview(donateBtn)
        
        UIView.animateWithDuration(0.8 ,
            animations: {
                self.donateBtn.transform = CGAffineTransformMakeScale(0.6,0.6)
            },
            completion:{ finish in
                UIView.animateWithDuration(0.6){
                    self.donateBtn.transform = CGAffineTransformIdentity
                }
                
        })
        
        self.addChild(myLabel)
        self.addChild(BG)
        self.addChild(playBtn)
    }
    
    func hyperlink1()
    {
        let url = NSURL(string: "https://www.pciglobal.org/w4w2017/")
        // register: let url = NSURL(string: "https://my.pciglobal.org/san-diego/events/2016-walk-for-water-registration/e69752")
        //donate now
        //let url = NSURL(string: "https://my.pciglobal.org/checkout/donation?eid=69752")
        
        UIApplication.sharedApplication().openURL(url!)
    }
    func hyper1Clicked()
    {
        linkBtn.backgroundColor = UIColor.lightGrayColor()
    }
    
    func hyper1NotClicked()
    {
        linkBtn.backgroundColor = UIColor.clearColor()
    }
    
    func hyperlink2()
    {
        let url = NSURL(string: "https://my.pciglobal.org/san-diego/events/2016-walk-for-water-registration/e69752")
        //donate now
        //let url = NSURL(string: "https://my.pciglobal.org/checkout/donation?eid=69752")
        
        UIApplication.sharedApplication().openURL(url!)
    }
    
    func hyper2Clicked()
    {
        registerBtn.backgroundColor = UIColor.lightGrayColor()
    }
    
    func hyper2NotClicked()
    {
        registerBtn.backgroundColor = UIColor.clearColor()
    }
    
    func hyperlink3()
    {
        let url = NSURL(string: "https://my.pciglobal.org/checkout/donation?eid=69752")
        
        UIApplication.sharedApplication().openURL(url!)
    }
    func hyper3Clicked()
    {
        donateBtn.backgroundColor = UIColor.lightGrayColor()
    }
    
    func hyper3NotClicked()
    {
        donateBtn.backgroundColor = UIColor.clearColor()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch: AnyObject in touches{
            let location = touch.locationInNode(self)
            
            //let node:SKNode = self.nodeAtPoint(location)
            
            if(playBtn.containsPoint(location))
            {
                donateBtn.removeFromSuperview()
                linkBtn.removeFromSuperview()
                registerBtn.removeFromSuperview()
                
                let scene = GamePlayScene(size: view!.bounds.size)
                
                // Configure the view.
                
                let skView = self.view! as SKView
                
                
                skView.showsFPS = true
                skView.showsNodeCount = true
                skView.showsPhysics = true
                /* Sprite Kit applies additional optimizations to improve rendering performance */
                skView.ignoresSiblingOrder = false
                
                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = .ResizeFill
                
                scene.size = skView.bounds.size
                skView.presentScene(scene)
                //self.view?.presentScene(scene)
            }
        }
    }
}
