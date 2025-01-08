//
//  PhysicsManagerProtocol.swift
//  08-Pachinko
//
//  Created by Igor Cotrim on 08/01/25.
//

import SpriteKit

protocol PhysicsManagerProtocol {
    func setupPhysics(for scene: SKScene)
    func createPhysicsBody(for item: GameItem, size: CGSize) -> SKPhysicsBody
}
