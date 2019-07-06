//
//  GameViewController.swift
//  GetTheDot
//
//  Created by Gerardo Gallegos on 7/30/17.
//  Copyright © 2017 Gerardo Gallegos. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import SwiftySound

class GameViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //make view landscape
        //let value = UIInterfaceOrientation.portrait.rawValue
        //UIDevice.current.setValue(value, forKey: "orientation")
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                //depending on iphone or ipad
                if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
                    scene.scaleMode = .aspectFill
                }else{
                    scene.scaleMode = .fill
                }
                // Present the scene
                view.presentScene(scene)
            }
            
            Sound.play(file: "menu", fileExtension: ".mp3", numberOfLoops: -1)
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false
            view.showsDrawCount = false
        }
        
        
        
    }
    
   

    // configure supported orientations
    private func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    //disble autorotate
    override var shouldAutorotate: Bool {
        return false
    }
    /*
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
*/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
}
