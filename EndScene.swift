//
//  EndScene.swift
//  Catch the Drop
//
//  Created by Callie on 2/28/16.
//  Copyright © 2016 Project Concern International. All rights reserved.
//

import Foundation
import SpriteKit

class EndScene : SKScene //super class is SKScene
{
    var restartBtn : UIButton! //instantiates this var as a UI button
    var highScore : Int!
    var ScoreLbl : UILabel!
    var GameOverLbl : UILabel!
    
    var blah = false;
    override func didMoveToView(view: SKView)
    {
        scene?.backgroundColor = UIColor.blackColor()
        
        
        
        GameOverLbl = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width / 3, height: 30))
        GameOverLbl.center = CGPoint(x: view.frame.size.width / 2 + 20, y: view.frame.size.width / 7)
        GameOverLbl.text = "GAME OVER"
        GameOverLbl.textColor = UIColor.redColor()
        self.view?.addSubview(GameOverLbl)
        
        restartBtn = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width / 3, height: 60))
        restartBtn.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.width / 5)
        restartBtn.setTitle("Restart?", forState: UIControlState.Normal) //text says "restart" when nothing is pressed
        restartBtn.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        restartBtn.addTarget(self, action: Selector("Restart"), forControlEvents: UIControlEvents.TouchUpInside) //once the button is released, call a function Restart()
        self.view?.addSubview(restartBtn);
        
        var scoreDefault = NSUserDefaults.standardUserDefaults()
        var score = scoreDefault.valueForKey("Score") as! NSInteger;
        NSLog("\(score)")
        
        ScoreLbl = UILabel(frame: CGRect(x: 0, y:0, width: view.frame.size.width / 3, height: 30))
        
        ScoreLbl.center = CGPoint(x: view.frame.size.width / 2 + 35, y: view.frame.size.width / 4)
        ScoreLbl.text = "Score: \(score)"
        ScoreLbl.textColor = UIColor.whiteColor()
        self.view?.addSubview(ScoreLbl)
        
/*        var highscoreDefault = NSUserDefaults.standardUserDefaults()
        highscoreDefault.setValue(score, forKey: "HighScore")
        highScore = highscoreDefault.valueForKey("HighScore") as! NSInteger
        NSLog("\(highScore)")
  */      
    }
    
    func Restart()
    {
        if(blah == false) //incase restart is called multiple times during updates
        {
            self.view?.presentScene(GameScene(), transition: SKTransition.crossFadeWithDuration(0.3)) //TODO: HUGE ISSUE WITH PRESENTING SCENE
            restartBtn.removeFromSuperview()
            ScoreLbl.removeFromSuperview()
            GameOverLbl.removeFromSuperview()
            blah = true;
        }
    }
}