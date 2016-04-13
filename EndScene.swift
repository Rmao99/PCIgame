//
//  EndScene.swift
//  Catch the Drop
//
//  Created by Richard Mao and Smayra Ramesh on 2/28/16.
//  Copyright © 2016 Project Concern International. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit


class EndScene : SKScene //super class is SKScene
{
    var restartBtn : UIButton! //instantiates this var as an absolute UI button
    var ScoreLbl : UILabel!
    var GameOverLbl : UILabel!
    var HighScoreLbl: UILabel!
    var GameOverLbl2 : UILabel!
    var mainMenuBtn : UIButton!
    
    var didRestart = false;
    override func didMoveToView(view: SKView)
    {
        scene?.backgroundColor = UIColor.darkGrayColor()
        
        self.addChild(SKEmitterNode(fileNamed: "RainParticle")!)
        
        mainMenuBtn = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width / 3, height: 120))
        mainMenuBtn.center = CGPoint(x: view.frame.size.width / 2 - 100, y: view.frame.size.width / 2 + 150)
        mainMenuBtn.setTitle("Main Menu", forState: UIControlState.Normal) //text says "restart" when nothing is pressed
        mainMenuBtn.backgroundColor = UIColor.clearColor()
        mainMenuBtn.layer.cornerRadius = 5
        mainMenuBtn.layer.borderWidth = 1
        mainMenuBtn.layer.borderColor = UIColor.blackColor().CGColor
        mainMenuBtn.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        mainMenuBtn.addTarget(self, action: Selector("MainMenu"), forControlEvents: UIControlEvents.TouchUpInside) //once the button is released, call a function Restart()
        self.view?.addSubview(mainMenuBtn);

        
        GameOverLbl = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width / 1.5, height: view.frame.height/2))
        GameOverLbl.center = CGPoint(x: view.frame.size.width / 2 , y: view.frame.size.width / 7)
        GameOverLbl.font = GameOverLbl.font.fontWithSize(100)
        GameOverLbl.text = "GAME"
        GameOverLbl.textColor = UIColor.redColor()
        self.view?.addSubview(GameOverLbl)
        
        
        GameOverLbl2 = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width / 1.5, height: view.frame.height/2))
        GameOverLbl2.center = CGPoint(x: view.frame.size.width / 2 , y: view.frame.size.width / 7 + 100)
        GameOverLbl2.font = GameOverLbl2.font.fontWithSize(100)
        GameOverLbl2.text = "OVER"
        GameOverLbl2.textColor = UIColor.redColor()
        self.view?.addSubview(GameOverLbl2)
        
        restartBtn = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width / 3, height: 120))
        restartBtn.backgroundColor = UIColor.clearColor()
        restartBtn.layer.cornerRadius = 5
        restartBtn.layer.borderWidth = 1
        restartBtn.layer.borderColor = UIColor.blackColor().CGColor
        restartBtn.center = CGPoint(x: view.frame.size.width / 2+100, y: view.frame.size.width / 2 + 150)
        restartBtn.setTitle("Restart?", forState: UIControlState.Normal) //text says "restart" when nothing is pressed
        restartBtn.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        restartBtn.addTarget(self, action: Selector("Restart"), forControlEvents: UIControlEvents.TouchUpInside) //once the button is released, call a function Restart()
        self.view?.addSubview(restartBtn);
        
        var scoreDefault = NSUserDefaults.standardUserDefaults()
        var score = scoreDefault.valueForKey("Score") as! NSInteger;
        NSLog("\(score)")
        
        ScoreLbl = UILabel(frame: CGRect(x: 0, y:0, width: view.frame.size.width / 3, height: 30))
        ScoreLbl.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.width / 3 + 90)
        ScoreLbl.text = "Score: \(score)"
        ScoreLbl.font = ScoreLbl.font.fontWithSize(30)
        ScoreLbl.textColor = UIColor.whiteColor()
        self.view?.addSubview(ScoreLbl)
        
       var highScoreDefault = NSUserDefaults.standardUserDefaults()
        var highScore = highScoreDefault.valueForKey("HighScore") as! NSInteger
        
        HighScoreLbl = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/3, height: 30))
        HighScoreLbl.font = HighScoreLbl.font.fontWithSize(20)
        HighScoreLbl.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.width / 3 + 130)
        
        
        
        
        HighScoreLbl.text = "HighScore: \(highScore)"
        HighScoreLbl.textColor = UIColor.whiteColor()
        self.view?.addSubview(HighScoreLbl)
        
    }
    func MainMenu()
    {
        //PRESENT MAINMENU
        
    }
    
    func Restart()
    {
        if(didRestart == false) //incase restart is called multiple times during updates
        {
            self.view?.presentScene(GameScene(), transition: SKTransition.crossFadeWithDuration(0.3)) //TODO: HUGE ISSUE WITH PRESENTING SCENE
            restartBtn.removeFromSuperview()
            ScoreLbl.removeFromSuperview()
            GameOverLbl.removeFromSuperview()
            GameOverLbl2.removeFromSuperview()
            HighScoreLbl.removeFromSuperview()
            ScoreLbl.removeFromSuperview()
            mainMenuBtn.removeFromSuperview()
            didRestart = true;
        }
    }
}