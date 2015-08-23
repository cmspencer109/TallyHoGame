//
//  WelcomeScene.swift
//  TallyHo
//
//  Created by Christopher Spencer on 8/22/15.
//  Copyright (c) 2015 Christopher Spencer. All rights reserved.
//

import Foundation
import SpriteKit

class WelcomeScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        let introLabel = childNodeWithName("play")
        let action0 = SKAction.scaleTo(1.1, duration: 0.5)
        let action1 = SKAction.scaleTo(1.13, duration: 0.2)
        let action2 = SKAction.scaleTo(1.1, duration: 0.2)
        let action3 = SKAction.scaleTo(1.0, duration: 0.5)
        let pulseAction = SKAction.sequence([action0, action1, action2, action3])
        introLabel?.runAction(SKAction.repeatActionForever(pulseAction))
    }
    
    override func mouseDown(event: NSEvent) {
    
        let clickedNode = self.nodeAtPoint(event.locationInNode(self))
        
        if clickedNode.name == "play" {
            let fadeOut = SKAction.fadeOutWithDuration(0.7)
            clickedNode.runAction(fadeOut, completion: {
                let introTransition = SKTransition.doorsOpenHorizontalWithDuration(1.7)
                let gameScene = GameScene(fileNamed: "GameScene")
                self.view?.presentScene(gameScene, transition: introTransition)
            })
        }
    }
    
}
