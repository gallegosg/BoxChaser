//
//  GameScene.swift
//  GetTheDot
//
//  Created by Gerardo Gallegos on 7/30/17.
//  Copyright © 2017 Gerardo Gallegos. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion
import GoogleMobileAds
import SwiftySound
import Firebase


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //ad
    var interstitial: GADInterstitial!
    
    var motionManager = CMMotionManager()
    
    var score: Int = 0
    
    var highScore: Int = 0
    
    var ball = SKSpriteNode()
    
    var enemy = SKSpriteNode()
    
    var logo = SKSpriteNode()

    var scoreLabel: SKLabelNode!
    
    var timerLabel: SKLabelNode!
    
    var highScoreLabel: SKLabelNode!
    
    var button = SKSpriteNode()
    
    var banner = SKSpriteNode()
    
    var optionsButton = SKSpriteNode()
    
    var buttonLabel: SKLabelNode!
    
    //CHANGE TO 30
    var tcount: Int = 30 {
        didSet {
            //timerLabel.text = "Time left: \(tcount)"
        }
    }

    struct game {
        static var IsOver : Bool = false
        static var IsRunning : Bool = false
    }
    
    struct CategoryBitMask {
        static let Ball: UInt32 = 0b1 << 0
        static let Enemy: UInt32 = 0b1 << 1
        static let Edge   : UInt32 = 0b1

    }
    
    
    override func didMove(to view: SKView) {
        
        
        //AD
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-6937210582976662/9744563437")//fake ca-app-pub-3940256099942544/4411468910
        //real ca-app-pub-6937210582976662/9744563437
        let request = GADRequest()
        //request.testDevices = [ kGADSimulatorID, "041d6da59580f2493337b3844055eb8a" ]
        interstitial.load(request)
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = CategoryBitMask.Edge
        self.physicsWorld.contactDelegate = self
        
        // Set the scene world's gravity to 0.
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)

        
        //background
        self.backgroundColor = UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha:1.0)

        //border
        self.view?.layer.borderWidth = 1
        self.view?.layer.borderColor = UIColor.red.cgColor
        
        //LOGO
        logo = SKSpriteNode(imageNamed: "logo")
        
        logo.size = CGSize(width: 575, height: 600)
        
        logo.position = CGPoint(x: self.frame.minX + 120, y: frame.maxY - 230)
        
        logo.zPosition = 0
        
        self.addChild(logo)

        //////////////////////////
        
       
        //TOP BANNER
        banner = SKSpriteNode(color: UIColor.white, size: CGSize(width: 2000, height: 125))
        // Put it in the top of the scene
        banner.position = CGPoint(x: self.frame.maxX, y: self.frame.midY);
        banner.zRotation = CGFloat(Double.pi / 2)
        banner.zPosition = 1
        self.addChild(banner)
        
        //SCORE LABEL
        scoreLabel = SKLabelNode(fontNamed: "Helvetica")
        
        scoreLabel.fontColor = SKColor.black
        
        scoreLabel.zRotation = CGFloat(-Double.pi / 2);
        
        scoreLabel.text = "Score: 0"
        
        scoreLabel.fontSize = 50
        
        scoreLabel.zPosition = 1
        
        scoreLabel.position = CGPoint(x: self.frame.maxX - 50, y: self.frame.maxY - 115)
        
        self.addChild(scoreLabel)
        
        //HIGH SCORE LABEL
        
        highScoreLabel = SKLabelNode(fontNamed: "Helvetica")
        
        highScoreLabel.fontColor = SKColor.black
        
        highScoreLabel.zRotation = CGFloat(-Double.pi / 2);
        
        highScoreLabel.text = "High Score: 0"
        
        highScoreLabel.fontSize = 50
        
        highScoreLabel.zPosition = 1
        
        highScoreLabel.position = CGPoint(x: self.frame.maxX - 50, y: self.frame.minY + 200)
        
        self.addChild(highScoreLabel)
        
        //add button
        button = SKSpriteNode(color: SKColor.black, size: CGSize(width: 600, height: 100))
        // Put it in the center of the scene
        button.position = CGPoint(x: self.frame.midX, y: self.frame.midY);
        button.zRotation = CGFloat(Double.pi / 2)
        button.zPosition = 1
        
        //BUTTON LABEL
        buttonLabel = SKLabelNode(fontNamed: "Damascus")
        
        buttonLabel.fontColor = SKColor.white
        
        buttonLabel.zRotation = CGFloat(-Double.pi / 2);
        
        buttonLabel.zPosition = 1
        
        buttonLabel.text = "Start"
        
        buttonLabel.fontSize = 100
        
        buttonLabel.position = CGPoint(x: self.frame.midX - 33, y: self.frame.midY)
        
        self.addChild(buttonLabel)
        
        self.addChild(button)
        
        //TIMER LABEL
        timerLabel = SKLabelNode(fontNamed: "Arial")
        
        
        timerLabel.fontColor = SKColor.black
        
        timerLabel.text = "Time Left: 30"
        
        timerLabel.fontSize = 50
        
        timerLabel.zPosition = 1
        
        timerLabel.zRotation = CGFloat(-Double.pi / 2);
        
        timerLabel.position = CGPoint(x: self.frame.maxX - 50, y: self.frame.midY)
        
        
        self.addChild(timerLabel)
        
        //OPTIONS BUTTON
        //add button
        optionsButton = SKSpriteNode(imageNamed: "options.png")
        optionsButton.position = CGPoint(x: self.frame.minX + 70, y: self.frame.minY + 70);
        optionsButton.zPosition = 1
        self.addChild(optionsButton)
        
        //screen ratio detect for ipad vs iphone///////////////////////////////
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            
            logo.size = CGSize(width: 375, height: 400)
            
            logo.position = CGPoint(x: self.frame.minX + 75, y: frame.maxY - 315)
            
            scoreLabel.fontSize = 30
            
            highScoreLabel.fontSize = 30
            
            timerLabel.fontSize = 30
        
            button.size = CGSize(width: 380, height: 80)
            
            buttonLabel.fontSize = 70
            
            buttonLabel.position = CGPoint(x: self.frame.midX - 25, y: self.frame.midY)

            optionsButton.position = CGPoint(x: self.frame.minX + 70, y: self.frame.minY + 230);

            
            scoreLabel.position = CGPoint(x: self.frame.maxX - 35, y: self.frame.maxY - 250)
            
            timerLabel.position = CGPoint(x: self.frame.maxX - 35, y: self.frame.midY)
            
            highScoreLabel.position = CGPoint(x: self.frame.maxX - 35, y: self.frame.minY + 300)

            banner.size = CGSize(width: 2000, height: 85)
            
            print("Using ipad")
        }
        ////////////////////////////////////////////////
    
        //HIGHSCORE
        let highDefault = UserDefaults.standard
        if highDefault.value(forKey: "highscore") != nil {
            highScore = highDefault.value(forKey: "highscore") as! Int
            highScoreLabel.text = "High Score: \(highScore)"
        }
       
    }
    
    
    
    func random(lo: Int, hi: Int) -> Int {
        return lo + Int(arc4random_uniform(UInt32(hi - lo + 1)))
    }
    
    func addEnemy() {
        
        enemy = SKSpriteNode(color: SKColor.red, size: CGSize(width: 90, height: 90))
        
        //screen ratio detect for ipad vs iphone
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            
            enemy.size = CGSize(width: 65, height: 65)
    
            
        }
        
        var randomX = Int()
        var randomY = Int()
        
        //screen ratio detect for ipad vs iphone///////////////////////////////
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            
            //x coordinate between MinX (left) and MaxX (right):
            
            randomX = random(lo: Int(self.frame.minX + 50), hi: Int(self.frame.maxX - 50))
            
            //y coordinate between MinY (top) and MidY (middle):
            
            randomY = random(lo: Int(self.frame.minY + 300), hi: Int(self.frame.maxY - 300))
            
        }else {
        
            //x coordinate between MinX (left) and MaxX (right):
        
            randomX = random(lo: Int(self.frame.minX + 100), hi: Int(self.frame.maxX - 100))
        
            //y coordinate between MinY (top) and MidY (middle):
        
            randomY = random(lo: Int(self.frame.minY + 100), hi: Int(self.frame.maxY - 100))
        }
        
        
        let randomPoint = CGPoint(x: randomX, y: randomY)
        
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        
        enemy.physicsBody!.categoryBitMask = CategoryBitMask.Enemy
        enemy.physicsBody!.contactTestBitMask = CategoryBitMask.Ball | CategoryBitMask.Enemy
        enemy.physicsBody!.isDynamic = false
        enemy.physicsBody?.affectedByGravity = false
        
        enemy.position = randomPoint
        
        enemy.name = "enemy"
        
        addChild(enemy)

       
    }
    
    //ADD TO TOTAL SCORE
    func addToTotalScore(score: Int) {
        let totalScore = UserDefaults.standard.integer(forKey: "totalScore")
        let scoreToAdd = score + totalScore
        
        UserDefaults.standard.set(scoreToAdd, forKey: "totalScore")
    }
   
    //DETECT COLLISION
    
    func collisionBetween(enemy: SKNode, object: SKNode) {
    
            let fadeAway = SKAction.fadeOut(withDuration: 0.1)
            let removeNode = SKAction.removeFromParent()
            let sequence = SKAction.sequence([fadeAway, removeNode, SKAction.run(addEnemy)])
            enemy.run(sequence)
    }
  
    func didBegin(_ contact: SKPhysicsContact) {
        
        //on contact remove hit object and create new one
        
        
         if contact.bodyB.node?.name == "enemy" {
            
            collisionBetween(enemy: contact.bodyB.node!, object: contact.bodyA.node!)
            
            
            //play sound for enemy touched
            Sound.play(file: "thp.wav")
            

          
            
            //add 1 to score
            
            score = score + 1

            self.scoreLabel.text = "Score: \(score)"
            

        
         }
    }
    
    func checkHighScore() {
        
        if self.score > self.highScore {
            highScore = score
            
            //print("HighScore: \(self.highScore)")
            
            
            let highDefault = UserDefaults.standard
            
            highDefault.set(highScore, forKey: "highscore")
            
            self.timerLabel.text = "New Highscore!"
            
            self.highScoreLabel.text = "High Score: \(self.highScore)"


            
            highDefault.synchronize()
        }
    }
    
    func displayAd() {
        
        
            let vc:UIViewController=UIApplication.shared.keyWindow!.rootViewController!
     
            if self.interstitial.isReady {
                self.interstitial.present(fromRootViewController: vc)
     
            } else {
                print("Ad wasn't ready")
     
            }
       
    
    }
 
    
    func timer() {
        
        
        let wait = SKAction.wait(forDuration: 1) // countdown speed
        let action = SKAction.run({
            [unowned self] in
            
            //Timer is counting down
            if(self.tcount > 0){
                self.tcount = self.tcount - 1
                self.timerLabel.text = "Time Left: \(self.tcount)"

                //print("count: \(self.tcount)")
            
            //timer is done..GAme is over
            } else if (self.tcount == 0){
                
                game.IsRunning = false

                self.timerLabel.text = "Times Up!"
                
                self.buttonLabel.text = "Play Again"
                
                self.highScoreLabel.text = "High Score: \(self.highScore)"
                
                self.endOfGameClean()
                
                self.button.isPaused = false
                self.button.isHidden = false
                
                self.buttonLabel.isPaused = false
                self.buttonLabel.isHidden = false
                
                game.IsOver = true
                
                self.ball.isHidden = true
                self.ball.isPaused = true
                
                self.addChild(self.optionsButton)// show options when done
                
                self.checkHighScore()
                
                //fade back in logo
                let fadeIn = SKAction.fadeIn(withDuration: 0.5)
                let sequence = SKAction.sequence([fadeIn])
                self.logo.run(sequence)
                //////
                
                //end game code
                self.tcount = self.tcount - 1
                
                //ADD TO TOTAL SCORE WHEN GAME FINISHES
                self.addToTotalScore(score: self.score)
                
                //stop music
                Sound.stop(file: "game.mp3")
                Sound.play(file: "menu", fileExtension: ".mp3", numberOfLoops: -1)

            }
        })
        
        run(SKAction.repeatForever(SKAction.sequence([wait,action])))
 
    }

    
    
    //MIDDLE BUTTON
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Loop over all the touches in this event
        for touch: AnyObject in touches {
            // Get the location of the touch in this scene
            let location = touch.location(in: self)
            // Check if the location of the touch is within the button's bounds
            
            //START GAME button
            if button.contains(location) && !game.IsOver && !game.IsRunning  {
                
                
                //set isRunning to true while game is playing
                game.IsRunning = true
                
                //if sound switch is on, play sound
                if UserDefaults.standard.bool(forKey: "muteSwitchState")
                {
                    //stop menu music
                    Sound.stop(file: "menu.mp3")
                    //play game music
                    Sound.play(file: "game.mp3")
                    print("playing music")
                    
                }
                
                
                ball.name = "ball"
                print("enemy draw  1")
                run(SKAction.run(addEnemy))

                print("enemy draw 2")
                run(SKAction.run(addEnemy))

                
                button.isHidden = true
                button.isPaused = true
                
                buttonLabel.isHidden = true
                buttonLabel.isPaused = true
                
                self.ball.isHidden = false
                self.ball.isPaused = false
                
                self.enemy.isPaused = false
                self.enemy.isHidden = false
                
                //fade away logo
                let fadeAway = SKAction.fadeOut(withDuration: 0.5)
                let sequence = SKAction.sequence([fadeAway])
                self.logo.run(sequence)
                //////
                
                drawBall()
                
                ////////////////////////////////
                
                timer()
                
                
                optionsButton.removeFromParent() //hide options button when starting game
                
                
            //PLAY AGAIN _ RESET GAME
            }else if button.contains(location) && game.IsOver{
                
                //show ads
                rollForAds()
                
                //start new scene
                goToGameScene()
                print("Reset")
                game.IsOver = false
            }
        }
    }
    
    
    func drawBall(){
        
        //BALL
        ball = SKSpriteNode(imageNamed: UserDefaults.standard.string(forKey: "userBall")!)
        ball.size = CGSize(width: 100, height: 100)
        ball.position = CGPoint(x: self.frame.maxX/2, y: self.frame.maxY/2)
        ball.physicsBody = SKPhysicsBody(rectangleOf: ball.size)
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody!.categoryBitMask = CategoryBitMask.Ball
        ball.physicsBody!.contactTestBitMask = CategoryBitMask.Enemy
        ball.physicsBody!.collisionBitMask = CategoryBitMask.Edge
        ball.physicsBody!.mass = 0.01
        ball.zPosition = 1
        
        motionManager.accelerometerUpdateInterval = 0.1
        
        //BALL MOVEMENT
        if motionManager.isAccelerometerAvailable{
            
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: {
                (data, error) in
            
            
                //self.ball.physicsBody!.applyImpulse(CGVector(dx: (data?.acceleration.x)! * 5, dy: (data?.acceleration.y)! * 5))
                self.ball.physicsBody!.applyForce(CGVector(dx: (data?.acceleration.x)! * 300, dy: (data?.acceleration.y)! * 300))

                /*
                let currentX = self.ball.position.x
                
                let currentY = self.ball.position.y
                
                let self.destX = currentX + CGFloat((data?.acceleration.x)! * 2700)
                
                let self.destY = currentY + CGFloat((data?.acceleration.y)! * 2700)
                
                let action = SKAction.move(to: CGPoint(x: self.destX, y: self.destY), duration: 1)
                self.ball.run(action)
                */
            })
            
        }
        
        
        /*
        var xRange = SKRange()
        var yRange = SKRange()
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            
            xRange = SKRange(lowerLimit:self.frame.minX + 40, upperLimit:self.frame.maxX - 40)
            
            yRange = SKRange(lowerLimit:self.frame.minY + 210, upperLimit:self.frame.maxY - 210)
            
            
        }else {
            
            xRange = SKRange(lowerLimit:self.frame.minX, upperLimit:self.frame.maxX)
            
            yRange = SKRange(lowerLimit:self.frame.minY, upperLimit:self.frame.maxY)
            
        }
        ball.constraints = [SKConstraint.positionX(xRange, y: yRange)]
        */
        self.addChild(ball)
    }
    
    
    
    //determine if ads should be shown, show ads when rand is not 1
    func rollForAds() {
        let rand = random(lo: 0, hi: 3)
        
        if !UserDefaults.standard.bool(forKey: "adsRemoved"){
            if (rand != 1) {
                self.displayAd()
                //ads are shown
                print("yes ad \(rand)")
            
            }else {
                //no ads
                print("no ad \(rand)")
            }
        } else {
            print("ads have been removed")
        }
        
    }

    
    func endOfGameClean() {
        //remove all enemy and ball
        for child in self.children {
            
            if child.name == "enemy" || child.name == "ball" {
                child.removeFromParent()
            }
        }
    }
    
    
    
    //GO TO OPTIONS SCENE
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Loop over all the touches in this event
        for touch: AnyObject in touches {
            // Get the location of the touch in this scene
            let location = touch.location(in: self)
            
            // Check if the location of the touch is within the button's bounds
            if optionsButton.contains(location) {
                
              
                
                
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = mainStoryboard.instantiateViewController(withIdentifier: "Options")
                self.view?.window?.rootViewController?.present(vc, animated: true, completion: nil)
 
                
            }
            
        }
    }
    
    //reset gamescene
    func goToGameScene(){
        
        let gameScene = GameScene(size: self.size) // create your new scene
        gameScene.backgroundColor = UIColor.white
        let transition = SKTransition.crossFade(withDuration: 0.3) // create type of transition (you can check in documentation for more transtions)
        gameScene.scaleMode = self.scaleMode
        self.view!.presentScene(gameScene, transition: transition)
        
    }
    
    
    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("interstitialDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print("interstitialWillPresentScreen")
    }
    
    
   
}

