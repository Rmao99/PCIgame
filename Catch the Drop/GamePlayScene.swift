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
}

class GamePlayScene: SKScene, SKPhysicsContactDelegate {
    
    var highScore = Int()
    var player = SKSpriteNode(imageNamed: "walk 4 water (3).png")
    var score = 0
    var scoreLabel = UILabel()
    var soundPlayer = AVAudioPlayer()
    //var splash = AVAudioPlayer()
    let splash = SKAction.playSoundFileNamed("Water-splash-sound-effect.mp3", waitForCompletion: false)
    var MULTIPLIER = 1.0
    var scoreMultiplier = 1
    var isDone = false
    var isGamePaused = false
    // var DropTimer = NSTimer()
    
    var dropArray = [SKSpriteNode]()
    
    var pauseBtn : UIButton!
    var resumeBtn: UIButton!
    
    var numberLbl : UILabel!
    
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
        
        self.addChild(gameLayer)
        
        
        let viewSize:CGSize = view.bounds.size
        
        let BackGround = SKSpriteNode(imageNamed: "cartoonsky1.png")
        BackGround.position = CGPoint(x: viewSize.width/2+50, y: viewSize.height/2)
        BackGround.zPosition = 0
        
        BackGround.size.height = viewSize.height
        BackGround.size.width = viewSize.width + 100
        
        self.addChild(BackGround)
        
        numberLbl = UILabel(frame: CGRect(x: 0, y:0, width: view.frame.size.width / 3, height: 30))
        numberLbl.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.width / 2)
        numberLbl.text = "Resume in 1s"
        numberLbl.font = numberLbl.font.fontWithSize(30)
        numberLbl.textColor = UIColor.whiteColor()
        
        
        /* Setup your scene here */
        player.xScale = 0.1
        player.yScale = 0.1
        player.zPosition = 1
        
        let backgroundMusic = self.setupAudioPlayerWithFile("Rain-background", type: "mp3")
        soundPlayer = backgroundMusic
        soundPlayer.volume = 0.3
        soundPlayer.numberOfLoops = -1
        soundPlayer.play();
        
        //       let splashSound = self.setupAudioPlayerWithFile("Water-splash-sound-effect", type: "mp3")
        //       splash = splashSound;
        
        var highScoreDefault = NSUserDefaults.standardUserDefaults()
        
        if(highScoreDefault.valueForKey("HighScore") == nil){
            highScore = 0;
        }
        else{
            highScore = highScoreDefault.valueForKey("HighScore") as! NSInteger
        }
        
        physicsWorld.contactDelegate = self //CRUCIAL
        
        //pauseBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        
        createPauseBtn()
        
        self.scene?.backgroundColor = UIColor.darkGrayColor()
        //TODO: WHAT DO I DOOOOOO
        self.scene?.size = CGSize(width: 640, height: 1136)
        
        self.addChild(SKEmitterNode(fileNamed: "RainParticle")!)
        
        player.position = CGPointMake(self.size.width/2, self.size.height/15)
        var point = CGPointMake(player.position.x, player.position.y)
        var size = CGSize(width: 13, height: 10)
        
        var physicsBodySize:CGSize = CGSize(width: 10.0, height : 5.0)
        
        player.physicsBody = SKPhysicsBody(rectangleOfSize: physicsBodySize, center: CGPoint(x : -10.0, y: 0.0))
        
        //player.physicsBody = SKPhysicsBody(rectangleOfSize: size)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = PhysicsCategory.player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.drop | PhysicsCategory.x2
        player.physicsBody?.usesPreciseCollisionDetection = true
        //triggers didBeginContact
        player.physicsBody?.dynamic = false
        
        let bottomRect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 1)
        let bottom = SKSpriteNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFromRect: bottomRect)
        bottom.physicsBody!.categoryBitMask = PhysicsCategory.bottom
        bottom.physicsBody!.contactTestBitMask = PhysicsCategory.x2 | PhysicsCategory.drop
        bottom.physicsBody!.usesPreciseCollisionDetection = true
        
        self.addChild(bottom)
        
        //selector: what function it calls every second
        ////////////////////////////////////////////
        //spawning
        ////////////////////////////////////////////
        
   /*     waitBomb = SKAction.waitForDuration(15)
        spawnBomb = SKAction.runBlock
            {
                let bomb = SKSpriteNode(imageNamed: "bomb.png")
                bomb.xScale = 0.1
                bomb.yScale = 0.1
                let minValue = self.size.width/8
                let maxValue = self.size.width - 20
                
                let spawnPoint = UInt32(maxValue - minValue)
                
                bomb.position = CGPoint(x: CGFloat(arc4random_uniform(spawnPoint)), y: self.size.height)
                bomb.zPosition = 2
                bomb.physicsBody = SKPhysicsBody(rectangleOfSize: bomb.size)
                bomb.physicsBody?.categoryBitMask = PhysicsCategory.bomb
                bomb.physicsBody?.contactTestBitMask = PhysicsCategory.player | PhysicsCategory.bottom
                bomb.physicsBody?.usesPreciseCollisionDetection = true
                //^ have to use the |(or for bits) instead of declaring another contacttestbitmask
                //drop.physicsBody?.contactTestBitMask = PhysicsCategory.bottom
                bomb.physicsBody?.affectedByGravity = false
                bomb.physicsBody?.allowsRotation = false
                bomb.physicsBody?.dynamic = true
                
                let action = SKAction.moveToY(-70, duration: (10.0))
                let actionDone = SKAction.removeFromParent()
                bomb.runAction(SKAction.sequence([action, actionDone]))
                
                self.gameLayer.addChild(bomb)
        }*/
        
        waitX2 = SKAction.waitForDuration(10)
        spawnX2 = SKAction.runBlock
            {
                let x2 = SKSpriteNode(imageNamed: "x2-logo.png")
                x2.xScale = 0.1
                x2.yScale = 0.1
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
        var drop = SKSpriteNode(imageNamed: "wuterdrip.png")
        let minValue = self.size.width/8
        let maxValue = self.size.width - 20
        
        var spawnPoint = UInt32(maxValue - minValue)
        
        drop.position = CGPoint(x: CGFloat(arc4random_uniform(spawnPoint)), y: self.size.height)
        drop.zPosition = 1
        drop.physicsBody = SKPhysicsBody(rectangleOfSize: drop.size)
        drop.physicsBody?.categoryBitMask = PhysicsCategory.drop
        drop.physicsBody?.contactTestBitMask = PhysicsCategory.player | PhysicsCategory.bottom
            drop.physicsBody?.collisionBitMask = 0
        drop.physicsBody?.usesPreciseCollisionDetection = true
        
        //^ have to use the |(or for bits) instead of declaring another contacttestbitmask
        //drop.physicsBody?.contactTestBitMask = PhysicsCategory.bottom
        drop.physicsBody?.affectedByGravity = false
        drop.physicsBody?.allowsRotation = false
        drop.physicsBody?.dynamic = true
        
        self.dropArray.append(drop)
        let action = SKAction.moveToY(-70, duration: (3.0))
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
        
        self.view?.addSubview(scoreLabel)
        
    }
    
    ////////////////////////////////////////////
    //contact
    ////////////////////////////////////////////
    
    func didBeginContact(contact: SKPhysicsContact) {
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
        
        if(firstBody.categoryBitMask == PhysicsCategory.drop && secondBody.categoryBitMask == PhysicsCategory.player)
        {
            score += 1*scoreMultiplier
            scoreLabel.text = "\(score)"
            let i = dropArray.indexOf(firstBody.node as! SKSpriteNode)
            print("removing index \(i)")
            dropArray.removeAtIndex(i!)
            firstBody.node?.removeFromParent()

        }
            
        else if(firstBody.categoryBitMask == PhysicsCategory.drop && secondBody.categoryBitMask == PhysicsCategory.bottom)
        {
            updateScore();
            
            
            secondBody.node?.removeFromParent()
            firstBody.node?.removeFromParent()
            player.removeFromParent()
            soundPlayer.stop()
            pauseBtn.removeFromSuperview()
            self.view?.presentScene(EndScene())
            
            scoreLabel.removeFromSuperview()
        }
        else if(firstBody.categoryBitMask == PhysicsCategory.player && secondBody.categoryBitMask == PhysicsCategory.x2)
        {
            secondBody.node?.removeFromParent()
            scoreMultiplier += 1
            scoreLabel.text = "\(score)"
        }
        else if(firstBody.categoryBitMask == PhysicsCategory.bottom && secondBody.categoryBitMask == PhysicsCategory.x2)
        {
            secondBody.node?.removeFromParent()
        }
        
    }
    func updateX2Spawning()
    {
        print("update x2 spawning")
        let random = Double(arc4random_uniform(6) + 10)
        waitX2 = SKAction.waitForDuration(random)
        sequenceX2 = SKAction.repeatAction(SKAction.sequence([waitX2,spawnX2]), count: 1)
        gameLayer.runAction(sequenceX2, completion: {self.updateX2Spawning()})
    }
    
    func updateSpawning()
    {
        MULTIPLIER = MULTIPLIER * 1/////////////////////////////////////////////////////
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
   
    func pauseClick()
    {
        print("pause click")
        pauseBtn.removeFromSuperview()
        createResumeBtn()
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
        print("resume click")
        resumeBtn.removeFromSuperview()
        createPauseBtn()
        resumeGame()
    }
    
    func createPauseBtn()
    {
        print("create pause btn")
        pauseBtn = UIButton(type: UIButtonType.Custom) as UIButton
        pauseBtn.frame = CGRectMake(100,100,100,100)
        pauseBtn.setImage(UIImage(named: "pause.jpe") as UIImage?, forState: .Normal)
        pauseBtn.center = CGPoint(x: view!.frame.size.width - 100 , y: 40)
        //pauseBtn.setTitle("Pause", forState: UIControlState.Normal) //text says "Main Menu" when nothing is pressed
        //pauseBtn.backgroundColor = UIColor.clearColor()
        pauseBtn.layer.cornerRadius = 10
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
        resumeBtn.frame = CGRectMake(100,100,100,100)
        resumeBtn.setImage(UIImage(named: "play.png") as UIImage?, forState: .Normal)
        resumeBtn.center = CGPoint(x: view!.frame.size.width - 100 , y: 40)
        //pauseBtn.setTitle("Pause", forState: UIControlState.Normal) //text says "Main Menu" when nothing is pressed
        //pauseBtn.backgroundColor = UIColor.clearColor()
        resumeBtn.layer.cornerRadius = 10
        resumeBtn.layer.borderWidth = 1
        resumeBtn.layer.borderColor = UIColor.blackColor().CGColor
        //pauseBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        resumeBtn.addTarget(self, action: Selector("resumeClick"), forControlEvents: UIControlEvents.TouchDown)
        self.view?.addSubview(resumeBtn)
        self.view?.addSubview(numberLbl)
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