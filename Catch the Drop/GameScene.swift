//
//  MainMenuScene.swift
//  Catch the Drop
//
//  Created by Richard and Smayra on 5/15/16.
//  Copyright © 2016 Project Concern International. All rights reserved.
//

import SpriteKit
import AVFoundation
import SafariServices
import UIKit

class GameScene : SKScene,SFSafariViewControllerDelegate
{
 //   var playBtn: SKNode! = nil
    
    var playBtnTest : UIButton!
    var linkBtn: UIButton!
    var registerBtn: UIButton!
    var donateBtn: UIButton!
    
    var click = AVAudioPlayer()
    
    var muteBtn : UIButton!
    var unmuteBtn : UIButton!
    var muted = Bool()
    func setupAudioPlayer(file:String, type:String) -> AVAudioPlayer
    {
        var audioPlayer:AVAudioPlayer?
        if let asset = NSDataAsset(name: file){
            do{
                try audioPlayer = AVAudioPlayer(data: asset.data, fileTypeHint: type)
                
            }
            catch{
                
            }
        }
        
        return audioPlayer!
    }

    func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer{
        
        let path = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String) //needs to find where the soundfile is
        let url = NSURL.fileURLWithPath(path!) //converts to url
        
        var audioPlayer:AVAudioPlayer? //optional AVAudioPlayer incase it isn't created
        
        do{
            try audioPlayer = AVAudioPlayer(contentsOfURL: url)
        }
        catch{
            print("Player not available")
        }
        
        return audioPlayer!
    }
    
    override func didMoveToView(view: SKView) {
        
        let mutedDefault = NSUserDefaults.standardUserDefaults()
        
        if(mutedDefault.valueForKey("Mute") == nil)
        {
            muted = false
        }
        else
        {
            muted = mutedDefault.valueForKey("Mute") as! Bool
        }
        
        unmuteBtn = UIButton(type: UIButtonType.Custom) as UIButton
        unmuteBtn.frame = CGRectMake(50,50,50,50)
        unmuteBtn.setImage(UIImage(named: "unmute") as UIImage?, forState: .Normal)
        unmuteBtn.center = CGPoint(x: view.frame.size.width - 50 , y: 25)
        unmuteBtn.layer.borderWidth = 1
        unmuteBtn.layer.borderColor = UIColor.blackColor().CGColor
        //pauseBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        unmuteBtn.addTarget(self, action: Selector("unmuteClick"), forControlEvents: UIControlEvents.TouchDown)
        if(muted == false)
        {
            self.view?.addSubview(unmuteBtn);
        }
        
        muteBtn = UIButton(type: UIButtonType.Custom) as UIButton
        muteBtn.frame = CGRectMake(50,50,50,50)
        muteBtn.setImage(UIImage(named: "mute") as UIImage?, forState: .Normal)
        muteBtn.center = CGPoint(x: view.frame.size.width - 50 , y: 25)
        muteBtn.layer.borderWidth = 1
        muteBtn.layer.borderColor = UIColor.blackColor().CGColor
        //pauseBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        muteBtn.addTarget(self, action: Selector("muteClick"), forControlEvents: UIControlEvents.TouchDown)
        if(muted == true)
        {
            self.view?.addSubview(muteBtn);
        }
        
        let clickSound = self.setupAudioPlayer("buttonpress", type: "wav")
        click = clickSound
        click.volume = 1.0
        
        
        
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
        
       /* playBtn = SKSpriteNode(imageNamed: "playBtn")
        playBtn.position = CGPoint(x: viewSize.width/2, y: viewSize.height/2+100)
        playBtn.name = "playBtn"
        playBtn.zPosition = 1*/
        
        let img = UIImage(named: "playBtn")
        playBtnTest = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        playBtnTest.center = CGPoint(x : view.frame.size.width / 2, y: view.frame.size.height / 2 - 100)
        playBtnTest.backgroundColor = UIColor.clearColor()
        playBtnTest.layer.cornerRadius = 0.5 * playBtnTest.bounds.size.width
        playBtnTest.layer.borderColor = UIColor.blackColor().CGColor
        playBtnTest.clipsToBounds = true
        playBtnTest.setImage(UIImage(named: "playBtn"), forState: UIControlState.Normal)
        playBtnTest.addTarget(self, action: Selector("playBtnClicked"), forControlEvents: UIControlEvents.TouchDown)
        playBtnTest.addTarget(self, action: Selector("playBtn"), forControlEvents: UIControlEvents.TouchUpInside)
        playBtnTest.addTarget(self, action: Selector("playBtnNotClicked"), forControlEvents: UIControlEvents.TouchDragExit)
        view.addSubview(playBtnTest)
                
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
        //self.addChild(playBtn)
    }
    
    func hyperlink1()
    {
        let svc = SFSafariViewController(URL: NSURL(string: "https://www.pciglobal.org/w4w2017/")!)
        svc.delegate=self
        
        var vc: UIViewController = UIViewController()
        vc = self.view!.window!.rootViewController!
        vc.presentViewController(svc,animated:true,completion:nil)
    }
    func hyper1Clicked()
    {
        
        if(muted == false)
        {
            click.play()
        }
        linkBtn.backgroundColor = UIColor.lightGrayColor()
    }
    
    func hyper1NotClicked()
    {
        linkBtn.backgroundColor = UIColor.clearColor()
    }
    
    func hyperlink2()
    {
        //let url = NSURL(string: "https://my.pciglobal.org/san-diego/events/2016-walk-for-water-registration/e69752")
        
        let svc = SFSafariViewController(URL: NSURL(string: "https://my.pciglobal.org/san-diego/events/2016-walk-for-water-registration/e69752")!)
        svc.delegate=self
        
        var vc: UIViewController = UIViewController()
        vc = self.view!.window!.rootViewController!
        vc.presentViewController(svc,animated:true,completion:nil)
       
        //donate now
        //let url = NSURL(string: "https://my.pciglobal.org/checkout/donation?eid=69752")
        
        //UIApplication.sharedApplication().openURL(url!)
    }
    
    func hyper2Clicked()
    {
        
        if(muted == false)
        {
            click.play()
        }
        registerBtn.backgroundColor = UIColor.lightGrayColor()
    }
    
    func hyper2NotClicked()
    {
        registerBtn.backgroundColor = UIColor.clearColor()
    }
    
    func hyperlink3()
    {
        let svc = SFSafariViewController(URL:  NSURL(string: "https://my.pciglobal.org/checkout/donation?eid=69752")!)
        svc.delegate=self
        
        var vc: UIViewController = UIViewController()
        vc = self.view!.window!.rootViewController!
        vc.presentViewController(svc,animated:true,completion:nil)

    }
    func hyper3Clicked()
    {
        
        if(muted == false)
        {
            click.play()
        }
        donateBtn.backgroundColor = UIColor.lightGrayColor()
    }
    
    func hyper3NotClicked()
    {
        donateBtn.backgroundColor = UIColor.clearColor()
    }
    
    
    func safariViewControllerDidFinish(controller: SFSafariViewController)
    {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    func playBtnClicked()
    {
        
        if(muted == false)
        {
            click.play()
        }
        playBtnTest.backgroundColor = UIColor.lightGrayColor()
    }
    
    func playBtnNotClicked()
    {
        playBtnTest.backgroundColor = UIColor.clearColor()
    }
    
    func playBtn()
    {
        donateBtn.removeFromSuperview()
        linkBtn.removeFromSuperview()
        registerBtn.removeFromSuperview()
        playBtnTest.removeFromSuperview()
        if(muted == false)
        {
            unmuteBtn.removeFromSuperview()
        }
        else
        {
            muteBtn.removeFromSuperview()
        }
        
        let scene = GamePlayScene(size: view!.bounds.size)
        
        // Configure the view.
        
        let skView = self.view! as SKView
        
        
        skView.showsFPS = true
        skView.showsNodeCount = true
//        skView.showsPhysics = true
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = false
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .ResizeFill
        
        scene.size = skView.bounds.size
        skView.presentScene(scene)
        //self.view?.presentScene(scene)
    }
    
    func unmuteClick()
    {
        var mutedDefault = NSUserDefaults.standardUserDefaults()
        mutedDefault.setBool(true, forKey: "Mute")
        muted = true;
        unmuteBtn.removeFromSuperview()
        self.view?.addSubview(muteBtn)
    }
    
    func muteClick()
    {
        var mutedDefault = NSUserDefaults.standardUserDefaults()
        mutedDefault.setBool(false, forKey: "Mute")
        muted = false
        muteBtn.removeFromSuperview()
        self.view?.addSubview(unmuteBtn)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch: AnyObject in touches{
            let location = touch.locationInNode(self)
            
            //let node:SKNode = self.nodeAtPoint(location)
            
        /*    if(playBtn.containsPoint(location))
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
            }*/
        }
    }
}
