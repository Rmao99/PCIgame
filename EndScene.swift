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
    
    var blah = false;
    override func didMoveToView(view: SKView)
    {
        scene?.backgroundColor = UIColor.blackColor()
        
        restartBtn = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/3, height: 30))
        restartBtn.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.width / 7)
        
        restartBtn.setTitle("Restart", forState: UIControlState.Normal) //text says "restart" when nothing is pressed
        restartBtn.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        restartBtn.addTarget(self, action: Selector("Restart"), forControlEvents: UIControlEvents.TouchUpInside) //once the button is released, call a function Restart()
        self.view?.addSubview(restartBtn);
        
        var scoreDefault = NSUserDefaults.standardUserDefaults()
        var score = scoreDefault.valueForKey("Score") as! NSInteger;
        NSLog("\(score)")
        
    }
    
    func Restart()
    {
        if(blah == false) //incase restart is called multiple times during updates
        {
            self.view?.presentScene(GameScene(), transition: SKTransition.crossFadeWithDuration(0.3)) //TODO: HUGE ISSUE WITH PRESENTING SCENE
            restartBtn.removeFromSuperview()
            blah = true;
        }
    }
}