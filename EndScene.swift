//
//  EndScene.swift
//  Catch the Drop
//
//  Created by Richard Mao and Smayra Ramesh on 2/28/16.
//  Copyright © 2016 Project Concern International. All rights reserved.
//



/*TODO:
    change the play button to a literal "play" button
    gameplay scene: more powerups (increase the size of the person + golden drop) add sound effects
    app icon
*/

import Foundation
import SpriteKit
import GameKit
import AVFoundation


class EndScene : SKScene //super class is SKScene
{
    var muted = Bool()
    
    var restartBtn : UIButton! //instantiates this var as an absolute UI button
    var ScoreLbl : UILabel!
    var GameOverLbl : UILabel!
    var HighScoreLbl: UILabel!
    var GameOverLbl2 : UILabel!
    var mainMenuBtn : UIButton!
    var linkBtn : UIButton!
    
    var muteBtn : UIButton!
    var unmuteBtn : UIButton!
    
    var didRestart = false;
    var didMainRestart = false;
    
    var backgroundPlayer = AVAudioPlayer()
    var click = AVAudioPlayer()
    
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

    override func didMoveToView(view: SKView)
    {
        
        let viewSize:CGSize = view.bounds.size
        
        let BackGround = SKSpriteNode(imageNamed: "gameover1")
        BackGround.position = CGPoint(x: viewSize.width/2, y: viewSize.height/2 + 70)
        BackGround.zPosition = 0
       // BackGround.xScale = 0.1
       // BackGround.yScale = 0.1
        BackGround.size.height = viewSize.height + 150
        BackGround.size.width = viewSize.width + 100
        
        self.addChild(BackGround)
        
        linkBtn = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width / 3, height: 120))
        linkBtn.center = CGPoint(x : view.frame.size.width / 2, y: view.frame.size.width / 2 + 410)
        linkBtn.backgroundColor = UIColor.clearColor()
        linkBtn.setTitle("About us", forState: UIControlState.Normal)
        linkBtn.layer.cornerRadius = 10
        linkBtn.layer.borderWidth = 1
        linkBtn.layer.borderColor = UIColor.blackColor().CGColor
        linkBtn.addTarget(self, action: Selector("hyperlink"), forControlEvents: UIControlEvents.TouchUpInside)
        linkBtn.addTarget(self, action: Selector("linkBtnClicked"), forControlEvents: UIControlEvents.TouchDown)
        linkBtn.addTarget(self, action: Selector("linkBtnNotClicked"), forControlEvents: UIControlEvents.TouchDragExit)
        self.view?.addSubview(linkBtn)
        UIView.animateWithDuration(0.7 ,
            animations: {
                self.linkBtn.transform = CGAffineTransformMakeScale(0.6,0.6)
            },
            completion:{ finish in
                UIView.animateWithDuration(0.6){
                    self.linkBtn.transform = CGAffineTransformIdentity
                }
                
        })
        
        let mutedDefault = NSUserDefaults.standardUserDefaults()
        muted = mutedDefault.valueForKey("Mute") as! Bool
        
        
        let backgroundSound = self.setupAudioPlayerWithFile("gameoversoud2", type: "wav")
        backgroundPlayer = backgroundSound
        if(muted == false)
        {
            backgroundPlayer.volume = 0.3
        }
        else
        {
            backgroundPlayer.volume = 0
        }
        backgroundPlayer.numberOfLoops = -1
        backgroundPlayer.play()
        
        let clickSound = self.setupAudioPlayerWithFile("buttonpresssound2", type: "wav")
        click = clickSound
        click.volume = 1.0

      
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
        
        scene?.backgroundColor = UIColor.cyanColor()
        
        self.addChild(SKEmitterNode(fileNamed: "RainParticle")!)
        
        mainMenuBtn = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width / 3, height: 120))
        mainMenuBtn.center = CGPoint(x: view.frame.size.width / 2 - 100, y: view.frame.size.width / 2 + 260)
        mainMenuBtn.setTitle("Main Menu", forState: UIControlState.Normal) //text says "Main Menu" when nothing is pressed
        mainMenuBtn.backgroundColor = UIColor.clearColor()
        mainMenuBtn.layer.cornerRadius = 10
        mainMenuBtn.layer.borderWidth = 1
        mainMenuBtn.layer.borderColor = UIColor.blackColor().CGColor
        mainMenuBtn.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        mainMenuBtn.addTarget(self, action: Selector("mainButtonClicked"), forControlEvents: UIControlEvents.TouchDown)
        mainMenuBtn.addTarget(self, action: Selector("mainButtonNotClicked"), forControlEvents: UIControlEvents.TouchDragExit)
        mainMenuBtn.addTarget(self, action: Selector("MainMenuRestart"), forControlEvents: UIControlEvents.TouchUpInside) //once the button is released, call a function MainMenuRestart()
        self.view?.addSubview(mainMenuBtn);
       
        UIView.animateWithDuration(0.6 ,
            animations: {
                self.mainMenuBtn.transform = CGAffineTransformMakeScale(0.6,0.6)
            },
            completion:{ finish in
                UIView.animateWithDuration(0.6){
                    self.mainMenuBtn.transform = CGAffineTransformIdentity
                }
            
            })

        
  
        restartBtn = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width / 3, height: 120))
        restartBtn.backgroundColor = UIColor.clearColor()
        restartBtn.layer.cornerRadius = 10
        restartBtn.layer.borderWidth = 1
        restartBtn.layer.borderColor = UIColor.blackColor().CGColor
        restartBtn.center = CGPoint(x: view.frame.size.width / 2+100, y: view.frame.size.width / 2 + 260)
        restartBtn.setTitle("Restart", forState: UIControlState.Normal) //text says "restart" when nothing is pressed
        restartBtn.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        restartBtn.addTarget(self, action: Selector("restartButtonClicked"), forControlEvents: UIControlEvents.TouchDown)
        restartBtn.addTarget(self, action: Selector("restartButtonNotClicked"), forControlEvents: UIControlEvents.TouchDragExit)
        restartBtn.addTarget(self, action: Selector("Restart"), forControlEvents: UIControlEvents.TouchUpInside) //once the button is released, call a function Restart()
        self.view?.addSubview(restartBtn);
        
        UIView.animateWithDuration(0.6 ,
            animations: {
                self.restartBtn.transform = CGAffineTransformMakeScale(0.6,0.6)
            },
            completion:{ finish in
                UIView.animateWithDuration(0.6){
                    self.restartBtn.transform = CGAffineTransformIdentity
                }
                
        })
        
        var scoreDefault = NSUserDefaults.standardUserDefaults()
        var score = scoreDefault.valueForKey("Score") as! NSInteger;
        
        ScoreLbl = UILabel(frame: CGRect(x: 0, y:0, width: view.frame.size.width / 2+100, height: 30))
        ScoreLbl.center = CGPoint(x: view.frame.size.width / 2+50, y: view.frame.size.width / 4)
        ScoreLbl.text = "Score: \(score)"
        ScoreLbl.textColor = UIColor.blackColor()
        ScoreLbl.font = UIFont(name: "Chalkduster", size: 40)

        self.view?.addSubview(ScoreLbl)
        
        var highScoreDefault = NSUserDefaults.standardUserDefaults()
        var highScore = highScoreDefault.valueForKey("HighScore") as! NSInteger
        
        HighScoreLbl = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/2+100, height: 30))
        HighScoreLbl.font = UIFont(name: "Chalkduster", size: 20)
        HighScoreLbl.textColor = UIColor.blackColor()
        HighScoreLbl.center = CGPoint(x: view.frame.size.width / 2+50, y: view.frame.size.width / 4 + 70)
        HighScoreLbl.text = "HighScore: \(highScore)"
        self.view?.addSubview(HighScoreLbl)
        
    }
    
    func hyperlink()
    {
        let url = NSURL(string: "https://www.pciglobal.org/w4w2017/")
        // register: let url = NSURL(string: "https://my.pciglobal.org/san-diego/events/2016-walk-for-water-registration/e69752")
        //donate now
        //let url = NSURL(string: "https://my.pciglobal.org/checkout/donation?eid=69752")
        
        UIApplication.sharedApplication().openURL(url!)
    }
    func linkBtnClicked()
    {
        if(muted == false)
        {
            click.play()
        }
        
        linkBtn.backgroundColor = UIColor.lightGrayColor()
    }
    func linkBtnNotClicked()
    {
        linkBtn.backgroundColor = UIColor.clearColor()
    }
    
    func MainMenu()
    {
        //PRESENT MAINMENU
        
    }
    
    func restartButtonNotClicked()
    {
        restartBtn.backgroundColor = UIColor.clearColor()
    }
    func restartButtonClicked()
    {
        if(muted == false)
        {
            click.play()
        }
        
        restartBtn.backgroundColor = UIColor.lightGrayColor()
    }
    func mainButtonNotClicked()
    {
        mainMenuBtn.backgroundColor = UIColor.clearColor()
    }
    
    func mainButtonClicked()
    {
        if(muted == false)
        {
            click.play()
        }
        mainMenuBtn.backgroundColor = UIColor.lightGrayColor()
    }
    
    func Restart()
    {
        if(didRestart == false) //incase restart is called multiple times during updates
        {
            let scene = GamePlayScene(size: view!.bounds.size)
            
            // Configure the view.
            
            let skView = self.view! as SKView
            
            
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = false
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .ResizeFill
            
            scene.size = skView.bounds.size
            skView.presentScene(scene)

            restartBtn.removeFromSuperview()
            linkBtn.removeFromSuperview()
            ScoreLbl.removeFromSuperview()
        //    GameOverLbl.removeFromSuperview()
        //    GameOverLbl2.removeFromSuperview()
            HighScoreLbl.removeFromSuperview()
            ScoreLbl.removeFromSuperview()
            mainMenuBtn.removeFromSuperview()
            if(muted == false)
            {
                unmuteBtn.removeFromSuperview()
            }
            else
            {
                muteBtn.removeFromSuperview()
            }
            didRestart = true;
        }
    }
    
    func MainMenuRestart()
    {
        
        if(didMainRestart == false) //incase restart is called multiple times during updates
        {
            let nextScene = GameScene(size: self.scene!.size)
            nextScene.scaleMode = SKSceneScaleMode.ResizeFill
            
            self.view?.presentScene(nextScene, transition: SKTransition.crossFadeWithDuration(0.3))
            
            restartBtn.removeFromSuperview()
            linkBtn.removeFromSuperview()
            ScoreLbl.removeFromSuperview()
          //  GameOverLbl.removeFromSuperview()
          //  GameOverLbl2.removeFromSuperview()
            HighScoreLbl.removeFromSuperview()
            ScoreLbl.removeFromSuperview()
            mainMenuBtn.removeFromSuperview()
            didMainRestart = true;
            if(muted == false)
            {
                unmuteBtn.removeFromSuperview()
            }
            else
            {
                muteBtn.removeFromSuperview()
            }
            //
        }
    }
    
    func unmuteClick()
    {
        
        let mutedDefault = NSUserDefaults.standardUserDefaults()
        mutedDefault.setBool(true, forKey: "Mute")
        muted = true;
        backgroundPlayer.volume = 0;
        backgroundPlayer.volume = 0
        unmuteBtn.removeFromSuperview()
        self.view?.addSubview(muteBtn)
    }
    
    func muteClick()
    {
        let mutedDefault = NSUserDefaults.standardUserDefaults()
        mutedDefault.setBool(false, forKey: "Mute")
        muted = false
        backgroundPlayer.volume = 0.3
        backgroundPlayer.volume = 0.3
        muteBtn.removeFromSuperview()
        self.view?.addSubview(unmuteBtn)
    }

    
    
}