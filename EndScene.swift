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
    override func didMoveToView(view: SKView)
    {
        scene?.backgroundColor = UIColor.whiteColor()
        
        restartBtn = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/3, height: 30))
        restartBtn.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.width / 7)
        
        restartBtn.setTitle("Restart", forState: UIControlState.Normal) //text says "restart" when nothing is pressed
        restartBtn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        restartBtn.addTarget(self, action: Selector("Restart"), forControlEvents: UIControlEvents.TouchUpInside) //once the button is released, call a function Restart()
        self.view?.addSubview(restartBtn);
        
    }
    
    func Restart()
    {
        self.view?.presentScene(GameScene(), transition: SKTransition.crossFadeWithDuration(0.3))
        restartBtn.removeFromSuperview()
    
    }
}