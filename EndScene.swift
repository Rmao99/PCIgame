//
//  EndScene.swift
//  Catch the Drop
//
//  Created by Callie on 2/28/16.
//  Copyright © 2016 Project Concern International. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit


class EndScene : SKScene //super class is SKScene
{
    var restartBtn : UIButton! //instantiates this var as a UI button
    var ScoreLbl : UILabel!
    var GameOverLbl : UILabel!
    var HighScoreLbl: UILabel!
    
    var didRestart = false;
    override func didMoveToView(view: SKView)
    {
        scene?.backgroundColor = UIColor.darkGrayColor()
        
        
        
        GameOverLbl = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width / 1.5, height: 120))
        GameOverLbl.center = CGPoint(x: view.frame.size.width / 2 + 20, y: view.frame.size.width / 7)
        GameOverLbl.font = GameOverLbl.font.fontWithSize(50)
        GameOverLbl.text = "GAME OVER"
        GameOverLbl.textColor = UIColor.redColor()
        self.view?.addSubview(GameOverLbl)
        
        restartBtn = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width / 3, height: 120))
        
        restartBtn.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.width / 4)
        restartBtn.setTitle("Restart?", forState: UIControlState.Normal) //text says "restart" when nothing is pressed
        restartBtn.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        restartBtn.addTarget(self, action: Selector("Restart"), forControlEvents: UIControlEvents.TouchUpInside) //once the button is released, call a function Restart()
        self.view?.addSubview(restartBtn);
        
        var scoreDefault = NSUserDefaults.standardUserDefaults()
        var score = scoreDefault.valueForKey("Score") as! NSInteger;
        NSLog("\(score)")
        
        ScoreLbl = UILabel(frame: CGRect(x: 0, y:0, width: view.frame.size.width / 3, height: 30))
        
        ScoreLbl.center = CGPoint(x: view.frame.size.width / 2 + 35, y: view.frame.size.width / 3)
        ScoreLbl.text = "Score: \(score)"
        ScoreLbl.textColor = UIColor.whiteColor()
        self.view?.addSubview(ScoreLbl)
        
       var highScoreDefault = NSUserDefaults.standardUserDefaults()
        var highScore = highScoreDefault.valueForKey("HighScore") as! NSInteger
        
        HighScoreLbl = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/3, height: 30))
        HighScoreLbl.font = HighScoreLbl.font.fontWithSize(10)
        HighScoreLbl.center = CGPoint(x: 35 + view.frame.size.width / 2, y: view.frame.size.width / 3 + 25)
        
        
        
        
        HighScoreLbl.text = "HighScore: \(highScore)"
        HighScoreLbl.textColor = UIColor.whiteColor()
        self.view?.addSubview(HighScoreLbl)
        
    }
    
    func Restart()
    {
        if(didRestart == false) //incase restart is called multiple times during updates
        {
            self.view?.presentScene(GameScene(), transition: SKTransition.crossFadeWithDuration(0.3)) //TODO: HUGE ISSUE WITH PRESENTING SCENE
            restartBtn.removeFromSuperview()
            ScoreLbl.removeFromSuperview()
            GameOverLbl.removeFromSuperview()
            HighScoreLbl.removeFromSuperview()
            ScoreLbl.removeFromSuperview()
            didRestart = true;
        }
    }
}