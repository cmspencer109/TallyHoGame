//
//  GamePart.swift
//  TallyHo
//
//  Created by Christopher Spencer on 8/14/15.
//  Copyright (c) 2015 Christopher Spencer. All rights reserved.
//

import Foundation
import SpriteKit

enum AttackResult {
    case Win, Lose
}

enum PartType {
    case Bear
    case Fox
    case Lumberjack
    case Hunter
    case Pheasant
    case Duck
    case Tree
    
    var canMove: Bool {
        switch self {
        case .Bear, .Fox, .Lumberjack, .Hunter, .Pheasant, .Duck:
            return true
        case .Tree:
            return false
        }
    }
    
    var pieceFront: String {
        switch self {
        case .Bear:
            return "bear_front"
        case .Fox:
            return "fox_front"
        case .Lumberjack:
            return "lumberjack_front"
        case .Hunter:
            return "hunter_front"
        case .Pheasant:
            return "pheasant_front"
        case .Duck:
            return "duck_front"
        case .Tree:
            return "tree_front"
        }
    }
}

class GamePart: SKSpriteNode {
    
    var row: Int
    var column: Int
    var type: PartType
    var partSize: Int
    var flipped: Bool = false {
        didSet {
            let texture = SKTexture(imageNamed: flipped ? self.type.pieceFront : "piece_back")
            self.texture = texture
        }
    }
    func flip() {
        let action0 = SKAction.scaleYTo(1.0, duration: 0.1)
        let action1 = SKAction.scaleYTo(0.1, duration: 0.1)
        let action2 = SKAction.scaleYTo(-0.1, duration: 0.1)
        let action3 = SKAction.scaleYTo(-4.0, duration: 0.1)
        let actionMiddle = SKAction.runBlock {
            self.flipped = true
        }
        let flipAction = SKAction.sequence([action0, action1, actionMiddle, action2, action3])
        self.runAction(flipAction)
    }
    
    init(row: Int, column: Int, size: Int, type: PartType) {
        self.row = row
        self.column = column
        self.type = type
        self.partSize = size
        
        let texture = SKTexture(imageNamed: "piece_back")
        super.init(texture: texture, color: nil, size: texture.size())
        
        self.position = CGPoint(x: column * size + 85, y: row * size + 85)
        
        self.name = "part-\(row)-\(column)"
        println(self.name)
        self.setScale(4.0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var canDrag: Bool {
        get {
            return flipped && type.canMove
        }
    }
    
    func canDrop(row: Int, column: Int) -> Bool {
        var partAtSquare = self.scene?.childNodeWithName("part-\(row)-\(column)")
        return partAtSquare == nil
    }
    
    func move(row: Int, column: Int) {
        self.row = row
        self.column = column
        self.name = "part-\(row)-\(column)"
        
        let action = SKAction.moveTo(CGPoint(x: column * partSize + 85, y: row * partSize + 85),
                                     duration: 0.2)
        self.runAction(action)
    }
    
    func reset() {
        move(row, column: column)
    }
}