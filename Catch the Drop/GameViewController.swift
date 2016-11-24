//
//  GameViewController.swift
//  Catch the Drop
//
//  Created by Richard and Smayra on 12/6/15.
//  Copyright (c) 2015 Project Concern International. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class GameViewController: UIViewController{

    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        let scene = GamePlayScene(size: view.bounds.size)
            // Configure the view.
        
        
            let skView = self.view as! SKView
        
        
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = false
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .ResizeFill
            
            scene.size = skView.bounds.size
            skView.presentScene(scene)
        
        
        
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
 
}
