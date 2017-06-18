//
//  GameScene.swift
//  Catch the Drop
//
//  Created by Richard and Smayra on 12/6/15.
//  Copyright (c) 2015 Project Concern International. All rights reserved.
//
import SpriteKit
import AVFoundation

struct PhysicsCategory{
    static let drop : UInt32 = 1 //000...(32)1
    static let bottom : UInt32 = 2
    static let player : UInt32 = 3
    static let x2 : UInt32 = 4
    static let bomb : UInt32 = 5
    static let enlarge : UInt32 = 6
}

class GamePlayScene: SKScene, SKPhysicsContactDelegate {
    
    var highScore = Int()
    var muted = Bool()
    
    var player = SKSpriteNode(imageNamed: "player")
    var score = 0
    var scoreLabel = UILabel()
    var multiplierLbl = UILabel()
    
    var soundPlayer = AVAudioPlayer()
    var backgroundPlayer = AVAudioPlayer()
    var splash = AVAudioPlayer()
    var click = AVAudioPlayer()
    
    var MULTIPLIER = 1.0
    var scoreMultiplier = 1
    var BOMB_MULTIPLIER =  1.0
    
    var isDone = false
    var isGamePaused = false
    
    var isGolden = false
    // var DropTimer = NSTimer()
    
    var dropArray = [SKSpriteNode]()
    
    var pauseBtn : UIButton!
    var resumeBtn: UIButton!
    
    var muteBtn : UIButton!
    var unmuteBtn : UIButton!
    
    var numberLbl : UILabel!
    
    var mainMenuBtn : UIButton!
    
    let gameLayer = SKNode()
    let pauseLayer = SKNode()
    
    var wait : SKAction!
    var spawn : SKAction!
    var sequence : SKAction!
    var waitX2 : SKAction!
    var spawnX2 : SKAction!
    var sequenceX2 : SKAction!
    var waitBomb : SKAction!
    var spawnBomb : SKAction!
    var sequenceBomb : SKAction!
    var waitEnlarge : SKAction!
    var spawnEnlarge: SKAction!
    var sequenceEnlarge : SKAction!
    
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
    
    override func didMoveToView(view: SKView)
    {
        physicsWorld.contactDelegate = self //CRUCIAL
        self.addChild(gameLayer)
        scoreLabel.text = "\(score)"
        
        
        let viewSize:CGSize = view.bounds.size
        
        let BackGround = SKSpriteNode(imageNamed: "BG2")
        BackGround.position = CGPoint(x: viewSize.width/2+50, y: viewSize.height/2)
        BackGround.zPosition = 0
        
        BackGround.size.height = viewSize.height
        BackGround.size.width = viewSize.width + 100
        
        self.addChild(BackGround)
        
        var highScoreDefault = NSUserDefaults.standardUserDefaults()
        
        if(highScoreDefault.valueForKey("HighScore") == nil)
        {
            highScore = 0;
        }
        else
        {
            highScore = highScoreDefault.valueForKey("HighScore") as! NSInteger
        }
        
        var mutedDefault = NSUserDefaults.standardUserDefaults()
        
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
        
        numberLbl = UILabel(frame: CGRect(x: 0, y:0, width: view.frame.size.width / 4, height: 30))
        numberLbl.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.width / 2)
        numberLbl.text = "Paused"
        numberLbl.font = numberLbl.font.fontWithSize(30)
        numberLbl.textColor = UIColor.whiteColor()
        
        
        
        mainMenuBtn = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width / 3, height: 60))
        mainMenuBtn.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2)
        mainMenuBtn.setTitle("Home", forState: UIControlState.Normal) //text says "Main Menu" when nothing is pressed
        mainMenuBtn.backgroundColor = UIColor.clearColor()
        mainMenuBtn.layer.cornerRadius = 10
        mainMenuBtn.layer.borderWidth = 1
        mainMenuBtn.layer.borderColor = UIColor.blackColor().CGColor
        mainMenuBtn.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        mainMenuBtn.addTarget(self, action: Selector("mainButtonClicked"), forControlEvents: UIControlEvents.TouchDown)
        mainMenuBtn.addTarget(self, action: Selector("mainButtonNotClicked"), forControlEvents: UIControlEvents.TouchDragExit)
        mainMenuBtn.addTarget(self, action: Selector("MainMenuRestart"), forControlEvents: UIControlEvents.TouchUpInside) //once the button is released, call a function MainMenuRestart()
        
        /* Setup your scene here */
        player.xScale = 0.1
        player.yScale = 0.1
        player.zPosition = 1
        
        
/////////////////////////////////////////////////////////////////////////
//AUDIO
/////////////////////////////////////////////////////////////////////////

        let backgroundSound = self.setupAudioPlayer("rainBG", type: "mp3")
        soundPlayer = backgroundSound
        if(muted == false)
        {
            soundPlayer.volume = 0.3
        }
        else
        {
            soundPlayer.volume = 0
        }
        soundPlayer.numberOfLoops = -1
        soundPlayer.play()
        
        let backgroundMusic = self.setupAudioPlayer("duckysong", type: "mp3")
        backgroundPlayer = backgroundMusic
        if(muted == false)
        {
            backgroundPlayer.volume = 0.25
        }
        else
        {
            backgroundPlayer.volume = 0
        }
        backgroundPlayer.numberOfLoops = -1
        backgroundPlayer.play()

        
        
        let splashSound = self.setupAudioPlayer("splash", type: "wav")
        splash = splashSound
      //  splash.volume = 1.0
        
        let clickSound = self.setupAudioPlayer("buttonpress", type: "wav")
        click = clickSound
        
        
    
        createPauseBtn()
        
        self.scene?.backgroundColor = UIColor.darkGrayColor()
        //TODO: WHAT DO I DOOOOOO
        self.scene?.size = CGSize(width: 640, height: 1136)
        
        //let emitter - NSDataAsset(name: "RainParticles")
        self.addChild(SKEmitterNode(fileNamed: "RainParticle")!)
        
        player.position = CGPointMake(self.size.width/2, self.size.height/15)

        var physicsBodySize:CGSize = CGSize(width: 60.0, height : 10.0)
        
        player.physicsBody = SKPhysicsBody(rectangleOfSize: physicsBodySize, center: CGPoint(x : -14, y: 10.0))
        
        //player.physicsBody = SKPhysicsBody(rectangleOfSize: size)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = PhysicsCategory.player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.drop | PhysicsCategory.x2 | PhysicsCategory.enlarge
        player.physicsBody?.usesPreciseCollisionDetection = true
        //triggers didBeginContact
        player.physicsBody?.dynamic = false
        
        let bottomRect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 1)
        let bottom = SKSpriteNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFromRect: bottomRect)
        bottom.physicsBody!.categoryBitMask = PhysicsCategory.bottom
        bottom.physicsBody!.contactTestBitMask = PhysicsCategory.x2 | PhysicsCategory.drop | PhysicsCategory.enlarge
        bottom.physicsBody!.usesPreciseCollisionDetection = true
        
        self.addChild(bottom)
        
        //selector: what function it calls every second
        /////////////////////////////////////////////////////////////////////////
        //spawning
        /////////////////////////////////////////////////////////////////////////
        waitEnlarge = SKAction.waitForDuration((Double(arc4random_uniform(6) + 18)))
        spawnEnlarge = SKAction.runBlock
        {
            let enlarge = SKSpriteNode(imageNamed: "enlarge")
            enlarge.xScale = 0.2
            enlarge.yScale = 0.2
            let minValue = self.size.width/8
            let maxValue = self.size.width - 20
            
            let spawnPoint = UInt32(maxValue - minValue)
            
            enlarge.position = CGPoint(x: CGFloat(arc4random_uniform(spawnPoint)), y: self.size.height)
            enlarge.zPosition = 2
            enlarge.physicsBody = SKPhysicsBody(rectangleOfSize: enlarge.size)
            enlarge.physicsBody?.categoryBitMask = PhysicsCategory.enlarge
            enlarge.physicsBody?.contactTestBitMask = PhysicsCategory.player | PhysicsCategory.bottom
            enlarge.physicsBody?.collisionBitMask = 0
            enlarge.physicsBody?.usesPreciseCollisionDetection = true
            enlarge.physicsBody?.affectedByGravity = false
            enlarge.physicsBody?.allowsRotation = false
            enlarge.physicsBody?.dynamic = true
            
            let action = SKAction.moveToY(-70, duration: (13.0))
            let actionDone = SKAction.removeFromParent()
            enlarge.runAction(SKAction.sequence([action, actionDone]))
            
            self.gameLayer.addChild(enlarge)
        }
        sequenceEnlarge = SKAction.repeatAction(SKAction.sequence([waitEnlarge, spawnEnlarge]), count: 1)
        gameLayer.runAction(sequenceEnlarge, completion: {self.updateEnlargeSpawning()})
        

        
        
        waitBomb = SKAction.waitForDuration(15)
        spawnBomb = SKAction.runBlock
        {
            let bomb = SKSpriteNode(imageNamed: "explosion")
            bomb.xScale = 0.09
            bomb.yScale = 0.09
            let minValue = self.size.width/8
            let maxValue = self.size.width - 20
                
            let spawnPoint = UInt32(maxValue - minValue)
                
            bomb.position = CGPoint(x: CGFloat(arc4random_uniform(spawnPoint)), y: self.size.height)
            bomb.zPosition = 2
            bomb.physicsBody = SKPhysicsBody(rectangleOfSize: bomb.size)
            bomb.physicsBody?.categoryBitMask = PhysicsCategory.bomb
            bomb.physicsBody?.contactTestBitMask = PhysicsCategory.player | PhysicsCategory.bottom
            bomb.physicsBody?.collisionBitMask = 0
            bomb.physicsBody?.usesPreciseCollisionDetection = true
            bomb.physicsBody?.affectedByGravity = false
            bomb.physicsBody?.allowsRotation = false
            bomb.physicsBody?.dynamic = true
            
            let action = SKAction.moveToY(-70, duration: (10.0))
            let actionDone = SKAction.removeFromParent()
            bomb.runAction(SKAction.sequence([action, actionDone]))
                
            self.gameLayer.addChild(bomb)
        }
        sequenceBomb = SKAction.repeatAction(SKAction.sequence([waitBomb, spawnBomb]), count: 1)
        gameLayer.runAction(sequenceBomb, completion: {self.updateBombSpawning()})
        
        waitX2 = SKAction.waitForDuration(10)
        spawnX2 = SKAction.runBlock
        {
            let x2 = SKSpriteNode(imageNamed: "plusOne")
            x2.xScale = 0.275
            x2.yScale = 0.275
            let minValue = self.size.width/8
            let maxValue = self.size.width - 20
            
            let spawnPoint = UInt32(maxValue - minValue)
            
            x2.position = CGPoint(x: CGFloat(arc4random_uniform(spawnPoint)), y: self.size.height)
            x2.zPosition = 2
            x2.physicsBody = SKPhysicsBody(rectangleOfSize: x2.size)
            x2.physicsBody?.categoryBitMask = PhysicsCategory.x2
            x2.physicsBody?.contactTestBitMask = PhysicsCategory.player | PhysicsCategory.bottom
            x2.physicsBody?.collisionBitMask = 0
            x2.physicsBody?.usesPreciseCollisionDetection = true
            //^ have to use the |(or for bits) instead of declaring another contacttestbitmask
            //drop.physicsBody?.contactTestBitMask = PhysicsCategory.bottom
            x2.physicsBody?.affectedByGravity = false
            x2.physicsBody?.allowsRotation = false
            x2.physicsBody?.dynamic = true
                
            let action = SKAction.moveToY(-70, duration: (7.0))
            let actionDone = SKAction.removeFromParent()
            x2.runAction(SKAction.sequence([action, actionDone]))
                
            self.gameLayer.addChild(x2)
        }
        
        sequenceX2 = SKAction.repeatAction(SKAction.sequence([waitX2,spawnX2]), count: 1)
        gameLayer.runAction(sequenceX2, completion: {self.updateX2Spawning()})
        
        
        wait = SKAction.waitForDuration(MULTIPLIER)
        spawn = SKAction.runBlock
        {
            let i = arc4random_uniform(15)
            var drop = SKSpriteNode()
            if(self.isGolden == false && i == 9)
            {
                drop = SKSpriteNode(imageNamed: "wuterdrip6.png")
                drop.name = "golden"
                self.isGolden = true
            }
            else
            {
                drop = SKSpriteNode(imageNamed: "wuterdrip5.png")
                drop.name = "normal"
            }
            
            let minValue = self.size.width/8
            let maxValue = self.size.width - 20
        
            let spawnPoint = UInt32(maxValue - minValue)
        
            drop.position = CGPoint(x: CGFloat(arc4random_uniform(spawnPoint)), y: self.size.height)
            drop.zPosition = 1
            drop.physicsBody = SKPhysicsBody(rectangleOfSize: drop.size)
            drop.physicsBody?.categoryBitMask = PhysicsCategory.drop
            drop.physicsBody?.contactTestBitMask = PhysicsCategory.player | PhysicsCategory.bottom
            drop.physicsBody?.collisionBitMask = 0
            drop.physicsBody?.usesPreciseCollisionDetection = true
        
            drop.physicsBody?.affectedByGravity = false
            drop.physicsBody?.allowsRotation = false
            drop.physicsBody?.dynamic = true
        
            self.dropArray.append(drop)
            let action = SKAction.moveToY(-70, duration: (3.2))
            let actionDone = SKAction.removeFromParent()
            drop.runAction(SKAction.sequence([action, actionDone]))
            self.gameLayer.addChild(drop)
            print(self.dropArray.count)
        }
        
        sequence = SKAction.repeatAction(SKAction.sequence([wait, spawn]), count: 10)
        gameLayer.runAction(sequence, completion: {self.updateSpawning()})

        //        DropTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("spawnDrop"), userInfo: nil, repeats: true)
        gameLayer.addChild(player)
        
        
        scoreLabel.text = "\(score)"
        scoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100,height: 20))
        scoreLabel.backgroundColor = UIColor(red: 0.1, green: 0.6, blue: 0.1, alpha: 0.3)
        scoreLabel.textColor = UIColor.whiteColor()
        
        multiplierLbl.text = "x\(scoreMultiplier)"
        multiplierLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 100,height: 20))
        multiplierLbl.backgroundColor = UIColor(red: 0.1, green: 0.6, blue: 0.1, alpha: 0.3)
        multiplierLbl.textColor = UIColor.whiteColor()
        multiplierLbl.center = CGPoint(x: scoreLabel.center.x , y: scoreLabel.center.y+20)
        
        self.view?.addSubview(scoreLabel)
        self.view?.addSubview(multiplierLbl)
    }
    
    /////////////////////////////////////////////////////////////////////////
    //contact
    /////////////////////////////////////////////////////////////////////////
    
    func didBeginContact(contact: SKPhysicsContact) {
      //  self.splash.
        self.splash.stop()
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if(contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
        {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else
        {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if(firstBody.categoryBitMask == PhysicsCategory.player && secondBody.categoryBitMask == PhysicsCategory.enlarge)
        {
            secondBody.node?.removeFromParent()
            
            let dur = SKAction.waitForDuration(5)
            let action = SKAction.runBlock
                {
                    self.player.xScale = 0.2
                    self.player.yScale = 0.2
                    var physicsBodySize:CGSize = CGSize(width: 75.0, height : 20.0)

                    self.player.physicsBody = SKPhysicsBody(rectangleOfSize: physicsBodySize, center: CGPoint(x: -25.0, y:15.0))
                    self.player.physicsBody?.affectedByGravity = false
                    self.player.physicsBody?.categoryBitMask = PhysicsCategory.player
                    self.player.physicsBody?.contactTestBitMask = PhysicsCategory.drop | PhysicsCategory.x2 | PhysicsCategory.enlarge
                    self.player.physicsBody?.usesPreciseCollisionDetection = true
                    //triggers didBeginContact
                    self.player.physicsBody?.dynamic = false

            }
            let sequence = SKAction.sequence([action,dur])
            
            //SKAction.repeatAction(SKAction.sequence([dur, action]), count: 1)
            gameLayer.runAction(sequence, completion:
                { var physicsBodySize:CGSize = CGSize(width: 45.0, height : 5.0)
                
                self.player.physicsBody = SKPhysicsBody(rectangleOfSize: physicsBodySize, center: CGPoint(x : -13.0, y: 10.0))
                self.player.xScale = 0.1
                self.player.yScale = 0.1
                //player.physicsBody = SKPhysicsBody(rectangleOfSize: size)
                self.player.physicsBody?.affectedByGravity = false
                self.player.physicsBody?.categoryBitMask = PhysicsCategory.player
                self.player.physicsBody?.contactTestBitMask = PhysicsCategory.drop | PhysicsCategory.x2 | PhysicsCategory.enlarge
                self.player.physicsBody?.usesPreciseCollisionDetection = true
                //triggers didBeginContact
                self.player.physicsBody?.dynamic = false})


         /*   let action = SKAction.runBlock
                {
                    //SKAction.scaleBy(2, duration: 4)
                    //firstBody.node?.run
                }
            let actionComp = SKAction.scaleBy(0.5, duration: 4)
            //firstBody.node?.physicsBody =*/
           // firstBody.node?.runAction(action)
            
        }
        else if(firstBody.categoryBitMask == PhysicsCategory.bottom && secondBody.categoryBitMask == PhysicsCategory.enlarge)
        {
            secondBody.node?.removeFromParent()
        }
        else if(firstBody.categoryBitMask == PhysicsCategory.drop && secondBody.categoryBitMask == PhysicsCategory.player)
        {
            
            if(muted == false)
            {
                splash.play()
            }
            
            
            if(firstBody.node?.name == "golden")
            {
                score += 3*scoreMultiplier
                isGolden = false
            }
            else
            {
                score += 1*scoreMultiplier
            }
            multiplierLbl.text = "x\(scoreMultiplier)"
            scoreLabel.text = "\(score)"
            
            let i = dropArray.indexOf(firstBody.node as! SKSpriteNode)
            print("removing index \(i)")
            dropArray.removeAtIndex(i!)
            firstBody.node?.removeFromParent()

        }
        else if(firstBody.categoryBitMask == PhysicsCategory.drop && secondBody.categoryBitMask == PhysicsCategory.bottom)
        {
           
            updateScore();
            
            if(muted == false)
            {
                splash.play()
            }
            
            secondBody.node?.removeFromParent()
            firstBody.node?.removeFromParent()
            player.removeFromParent()
            soundPlayer.stop()
            backgroundPlayer.stop()
            pauseBtn.removeFromSuperview()
            muteBtn.removeFromSuperview()
            unmuteBtn.removeFromSuperview()
            
            let nextScene = EndScene(size: self.scene!.size)
            nextScene.scaleMode = SKSceneScaleMode.ResizeFill
            
            self.view?.presentScene(nextScene) //transition: SKTransition.
                
            //self.view?.presentScene(EndScene())
            
            scoreLabel.removeFromSuperview()
            multiplierLbl.removeFromSuperview()
        }
        else if(firstBody.categoryBitMask == PhysicsCategory.player && secondBody.categoryBitMask == PhysicsCategory.x2)
        {
            secondBody.node?.removeFromParent()
            scoreMultiplier += 1
            multiplierLbl.text = "x\(scoreMultiplier)"
            scoreLabel.text = "\(score)"
        }
        else if(firstBody.categoryBitMask == PhysicsCategory.bottom && secondBody.categoryBitMask == PhysicsCategory.x2)
        {
            secondBody.node?.removeFromParent()
        }
        else if(firstBody.categoryBitMask == PhysicsCategory.player && secondBody.categoryBitMask == PhysicsCategory.bomb)
        {
            if let wnd = self.view
            {
                var v = UIView(frame: wnd.bounds)
                v.backgroundColor = UIColor.whiteColor()
                v.alpha = 1
                
                wnd.addSubview(v)
                UIView.animateWithDuration(1, animations: {
                    v.alpha = 0.0
                    }, completion: {(finished:Bool) in v.removeFromSuperview()
                })
            }
            if(isGolden == false)
            {
                score += dropArray.count * scoreMultiplier
            }
            if(isGolden == true)
            {
                score += (dropArray.count+2) * scoreMultiplier
                isGolden = false
            }
            
            for drop in dropArray
            {
                let i = dropArray.indexOf(drop)
                dropArray.removeAtIndex(i!)
                drop.removeFromParent()
            }
            scoreLabel.text = "\(score)"
            secondBody.node?.removeFromParent()
        }
        else if(firstBody.categoryBitMask == PhysicsCategory.bottom && secondBody.categoryBitMask == PhysicsCategory.bomb)
        {
            secondBody.node?.removeFromParent()
        }
   
        
    }
    
    
    /////////////////////////////////////////////////////////////////////////
    //update spawning
    /////////////////////////////////////////////////////////////////////////
    
    func updateEnlargeSpawning()
    {
        waitEnlarge = SKAction.waitForDuration((Double(arc4random_uniform(5) + 15)))
        sequenceEnlarge = SKAction.repeatAction(SKAction.sequence([waitEnlarge,spawnEnlarge]), count: 1)
        gameLayer.runAction(sequenceEnlarge, completion: {self.updateEnlargeSpawning()})

    }
    
    func updateBombSpawning()
    {
        print("update bomb spawning")
        BOMB_MULTIPLIER = BOMB_MULTIPLIER * 0.93
        waitBomb = SKAction.waitForDuration(Double(arc4random_uniform(4) + 15) * BOMB_MULTIPLIER)
        sequenceBomb = SKAction.repeatAction(SKAction.sequence([waitBomb,spawnBomb]), count: 1)
        gameLayer.runAction(sequenceBomb, completion: {self.updateBombSpawning()})
        
    }
    
    func updateX2Spawning()
    {
        print("update x2 spawning")
        waitX2 = SKAction.waitForDuration(Double(arc4random_uniform(6) + 10))
        sequenceX2 = SKAction.repeatAction(SKAction.sequence([waitX2,spawnX2]), count: 1)
        gameLayer.runAction(sequenceX2, completion: {self.updateX2Spawning()})
    }
    
    func updateSpawning()
    {
        MULTIPLIER = MULTIPLIER * 0.9/////////////////////////////////////////////////////
        wait = SKAction.waitForDuration(MULTIPLIER)
        sequence = SKAction.repeatAction(SKAction.sequence([wait, spawn]), count: 10)
        gameLayer.runAction(sequence, completion: {self.updateSpawning()})
        
    }
    
    func updateScore()
    {
        var scoreDefault = NSUserDefaults.standardUserDefaults()
        scoreDefault.setValue(score, forKey: "Score") //grab this score from NSUerDefaults to update and check high scores. The key("Score) will be used to get the value of scoreDefault
        scoreDefault.synchronize()
        
        if(score > highScore)
        {
            var highScoreDefault = NSUserDefaults.standardUserDefaults()
            highScoreDefault.setValue(score, forKey: "HighScore")
        }
    }
    
    //clicks
   
    func unmuteClick()
    {
        var mutedDefault = NSUserDefaults.standardUserDefaults()
        mutedDefault.setBool(true, forKey: "Mute")
        muted = true;
        soundPlayer.volume = 0;
        backgroundPlayer.volume = 0
        unmuteBtn.removeFromSuperview()
        self.view?.addSubview(muteBtn)
    }
    
    func muteClick()
    {
        var mutedDefault = NSUserDefaults.standardUserDefaults()
        mutedDefault.setBool(false, forKey: "Mute")
        muted = false
        soundPlayer.volume = 0.3
        backgroundPlayer.volume = 0.25
        muteBtn.removeFromSuperview()
        self.view?.addSubview(unmuteBtn)
    }
    func pauseClick()
    {
        
        if(muted == false)
        {
            click.play()
        }
        
        pauseBtn.removeFromSuperview()
        createResumeBtn()
        self.view?.addSubview(numberLbl)
        self.view?.addSubview(mainMenuBtn);
        pauseGame()
        //self.runAction(SKAction.runBlock(self.pauseGame))
    }
    func pauseGame()
    {
        //scene?.physicsWorld.speed = 0
        //self.view?.paused = true
        gameLayer.paused = true
        isGamePaused = true
        //self.view?.paused = true
        //scene?.view?.paused = true
    }
    
    func resumeGame()
    {
        gameLayer.paused = false
        isGamePaused = false
        numberLbl.removeFromSuperview()
    }
    
    func resumeClick()
    {
        
        if(muted == false)
        {
            click.play()
        }
        
        print("resume click")
        resumeBtn.removeFromSuperview()
        mainMenuBtn.removeFromSuperview()
        createPauseBtn()
        resumeGame()
    }
    
    
    func createPauseBtn()
    {
        pauseBtn = UIButton(type: UIButtonType.Custom) as UIButton
        pauseBtn.frame = CGRectMake(50,50,50,50)
        pauseBtn.setImage(UIImage(named: "pause.png") as UIImage?, forState: .Normal)
        pauseBtn.center = CGPoint(x: view!.frame.size.width - 100 , y: 25)
        //pauseBtn.setTitle("Pause", forState: UIControlState.Normal) //text says "Main Menu" when nothing is pressed
        //pauseBtn.backgroundColor = UIColor.clearColor()
        //pauseBtn.layer.cornerRadius = 10
        pauseBtn.layer.borderWidth = 1
        pauseBtn.layer.borderColor = UIColor.blackColor().CGColor
        //pauseBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        pauseBtn.addTarget(self, action: Selector("pauseClick"), forControlEvents: UIControlEvents.TouchDown)
        self.view?.addSubview(pauseBtn);
    }
    
    func createResumeBtn()
    {
        print("create resume btn")
        resumeBtn = UIButton(type: UIButtonType.Custom) as UIButton
        resumeBtn.frame = CGRectMake(50,50,50,50)
        resumeBtn.setImage(UIImage(named: "play.png") as UIImage?, forState: .Normal)
        resumeBtn.center = CGPoint(x: view!.frame.size.width - 100 , y: 25)
        //pauseBtn.setTitle("Pause", forState: UIControlState.Normal) //text says "Main Menu" when nothing is pressed
        //pauseBtn.backgroundColor = UIColor.clearColor()
        //resumeBtn.layer.cornerRadius = 10
        resumeBtn.layer.borderWidth = 1
        resumeBtn.layer.borderColor = UIColor.blackColor().CGColor
        //pauseBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        resumeBtn.addTarget(self, action: Selector("resumeClick"), forControlEvents: UIControlEvents.TouchDown)
        self.view?.addSubview(resumeBtn)
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
    func MainMenuRestart()
    {
        updateScore()
        let nextScene = GameScene(size: self.scene!.size)
        nextScene.scaleMode = SKSceneScaleMode.ResizeFill
        player.removeFromParent()
        soundPlayer.stop()
        backgroundPlayer.stop()
        numberLbl.removeFromSuperview()
        resumeBtn.removeFromSuperview()
        mainMenuBtn.removeFromSuperview()
        scoreLabel.removeFromSuperview()
        muteBtn.removeFromSuperview()
        unmuteBtn.removeFromSuperview()
        multiplierLbl.removeFromSuperview()
        
        self.view?.presentScene(nextScene, transition: SKTransition.crossFadeWithDuration(0.3))
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(gameLayer)
            
            if(isGamePaused == false)
            {
                player.position.x = location.x
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(gameLayer)
            
            if(isGamePaused == false)
            {
                player.position.x = location.x;
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}