//
//  GameScene.swift
//  TallyHo
//
//  Created by Christopher Spencer on 8/10/15.
//  Copyright (c) 2015 Christopher Spencer. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var node: GamePart!
    var nodeStartPosition: CGPoint!
    var mouseStartPosition: CGPoint!
    
    var lastSquare: SKShapeNode!
    
    let darkGreen = SKColor(red: 0.1, green: 0.6, blue: 0.2, alpha: 1)
    let lightGreen = SKColor(red: 0.3, green: 0.6, blue: 0.3, alpha: 1)
    
    let initialPieces: [PartType: Int] = [
        .Bear: 2,
        .Fox: 6,
        .Lumberjack: 2,
        .Hunter: 8,
        .Pheasant: 8,
        .Duck: 7,
        .Tree: 15
    ]
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.scaleMode = SKSceneScaleMode.AspectFit
        prepareScene()
        newBoard()
        fillBoard()
    }
    
    override func mouseDown(event: NSEvent) {
        /* Called when a mouse click occurs */
        let node = self.nodeAtPoint(event.locationInNode(self))
        
        if let gamePart = node as? GamePart {
            if gamePart.flipped == false {
                gamePart.flip()
            }
            
            if gamePart.canDrag {
                self.node = gamePart
                gamePart.zPosition = 2
                self.nodeStartPosition = gamePart.position
                self.mouseStartPosition = event.locationInNode(self)
            } else {
                self.node = nil
            }
        } else {
            self.node = nil
        }
    }
    
    override func mouseDragged(event: NSEvent) {
        if node != nil {
            let offset = event.locationInNode(self) - self.mouseStartPosition
            node.position = self.nodeStartPosition + offset
            node.zPosition = 1
            
            if let square = squareAtLocation(event.locationInNode(self)) {
                let row = square.userData!["row"] as! Int
                let column = square.userData!["column"] as! Int
                
                let canDrop = self.node.canDrop(row, column: column)
                
                if square != self.lastSquare {
                    if lastSquare != nil {
                        lastSquare.fillColor = SKColor(white: 0, alpha: 0)
                    }
                    
                    square.fillColor = SKColor(white: 0, alpha: canDrop ? 1 : 0)
                    self.lastSquare = square
                }
            }
        }
    }
    
    override func mouseUp(event: NSEvent) {
        if node != nil {
            if let square = squareAtLocation(event.locationInNode(self)) {
                let row = square.userData!["row"] as! Int
                let column = square.userData!["column"] as! Int
                
                let canDrop = self.node.canDrop(row, column: column)
                
                if lastSquare != nil {
                    lastSquare.fillColor = SKColor(white: 0, alpha: 0)
                    lastSquare = nil
                }
                
                if canDrop {
                    var partAtSquare = self.childNodeWithName("part-\(row)-\(column)") as? GamePart
                    if partAtSquare != nil {
                        partAtSquare?.removeFromParent()
                    }
                    node.move(row, column: column)
                } else {
                    node.reset()
                }
            } else {
                node.reset()
            }
        }
    }
    
    func squareAtLocation(location: CGPoint) -> SKShapeNode? {
        let nodes = self.nodesAtPoint(location)
        
        for newNode in nodes {
            if let square = newNode as? SKShapeNode {
                return square
            }
        }
        
        return nil
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func fillBoard() {
        let size = 100
        
        var parts = self.initialPieces
        
        while parts.count > 0 {
            let part = parts.keys.first as PartType!
            
            let place = randomPlace()
            
            self.addChild(GamePart(row: place.row, column: place.column, size: size, type: part))
            
            parts[part] = parts[part]! - 1
            
            if parts[part] == 0 {
                parts.removeValueForKey(part)
            }
        }
    }
    
    func newBoard() {
        let count = 7
        let size = 100
        
        for row in 0..<count {
            for column in 0..<count {
                let x = column * size + 85
                let y = row * size + 85
                
                var square = SKShapeNode(rectOfSize: CGSize(width: size, height: size))
                square.name = "square-\(row)-\(column)"
                square.userData = [
                    "row": row,
                    "column": column
                ]
                square.lineWidth = 2.0 // set to 2.0 for use
                square.strokeColor = lightGreen
                //square.fillColor = darkGreen
                square.position = CGPoint(x: x, y: y)
                
                self.addChild(square)
            }
        }
    }
    
    func randomPlace() -> (row: Int, column: Int) {
        while true {
            let row = Int(arc4random_uniform(7))
            let column = Int(arc4random_uniform(7))
            
            if row == 3 && column == 3 {
                continue
            }
            
            let partName = "part-\(row)-\(column)"
            
            println(partName)
            println(self.childNodeWithName(partName))
            
            if self.childNodeWithName(partName) == nil {
                return (row: row, column: column)
            }
        }
    }
    
    func prepareScene() {
        // set background image
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        background.size = self.frame.size
        background.zPosition = -2
        self.addChild(background)
        // set gameboard image
        let gameBoard = SKSpriteNode(imageNamed: "game_board")
        gameBoard.position = CGPoint(x: 385, y: 385)
        gameBoard.size = CGSize(width: 750, height: 750)
        gameBoard.zPosition = -1
        self.addChild(gameBoard)
    }
}

func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}
