//
//  PhysicsManager.swift
//  08-Pachinko
//
//  Created by Igor Cotrim on 08/01/25.
//

import Foundation
import SpriteKit

class PhysicsManager: PhysicsManagerProtocol {
    func setupPhysics(for scene: SKScene) {
        scene.physicsBody = SKPhysicsBody(edgeLoopFrom: scene.frame)
        scene.physicsWorld.contactDelegate = scene as? SKPhysicsContactDelegate
    }
    
    func createPhysicsBody(for item: GameItem, size: CGSize) -> SKPhysicsBody {
        switch item {
        case .ball:
            let body = SKPhysicsBody(circleOfRadius: size.width / 2.0)
            body.restitution = 0.4
            body.contactTestBitMask = body.collisionBitMask
            return body
        case .bouncer:
            let body = SKPhysicsBody(circleOfRadius: size.width / 2)
            body.isDynamic = false
            return body
        case .slot:
            let body = SKPhysicsBody(rectangleOf: size)
            body.isDynamic = false
            return body
        case .obstacle:
            let body = SKPhysicsBody(rectangleOf: size)
            body.isDynamic = false
            return body
        }
    }
}
