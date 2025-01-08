//
//  GameScene.swift
//  08-Pachinko
//
//  Created by Igor Cotrim on 08/01/25.
//

import Foundation
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    // MARK: - Properties
    private let scoreManager = ScoreManager()
    private let physicsManager = PhysicsManager()
    private var state = GameState()
    
    private var scoreLabel: SKLabelNode!
    private var editLabel: SKLabelNode!
    
    // MARK: - Scene Lifecycle
    override func didMove(to view: SKView) {
        setupBackground()
        setupUI()
        setupPhysics()
        setupGameElements()
    }
    
    // MARK: - Setup Methods
    private func setupBackground() {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = GameConfiguration.backgroundPosition
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
    }
    
    private func setupUI() {
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = GameConfiguration.scoreLabelPosition
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = GameConfiguration.editLabelPosition
        addChild(editLabel)
        
        scoreManager.onScoreChanged = { [weak self] score in
            self?.scoreLabel.text = "Score: \(score)"
        }
    }
    
    private func setupPhysics() {
        physicsManager.setupPhysics(for: self)
    }
    
    private func setupGameElements() {
        // Setup slots
        for (index, position) in GameConfiguration.slotPositions.enumerated() {
            makeSlot(at: position, isGood: index % 2 == 0)
        }
        
        // Setup bouncers
        for position in GameConfiguration.bouncerPositions {
            makeBouncer(at: position)
        }
    }
    
    // MARK: - Game Element Creation
    private func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = physicsManager.createPhysicsBody(for: .bouncer, size: bouncer.size)
        addChild(bouncer)
    }
    
    private func makeSlot(at position: CGPoint, isGood: Bool) {
        let slotBase = SKSpriteNode(imageNamed: isGood ? "slotBaseGood" : "slotBaseBad")
        let slotGlow = SKSpriteNode(imageNamed: isGood ? "slotGlowGood" : "slotGlowBad")
        
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.name = isGood ? "good" : "bad"
        slotBase.physicsBody = physicsManager.createPhysicsBody(for: .slot(isGood: isGood), size: slotBase.size)
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi / 2, duration: 10)
        slotGlow.run(.repeatForever(spin))
    }
    
    // MARK: - Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let objects = nodes(at: location)
        
        if objects.contains(editLabel) {
            state.isEditingMode.toggle()
            editLabel.text = state.isEditingMode ? "Done" : "Edit"
        } else if state.isEditingMode {
            createObstacle(at: location)
        } else {
            createBall(at: location)
        }
    }
    
    private func createObstacle(at position: CGPoint) {
        let size = CGSize(width: Int.random(in: 16...128), height: 16)
        let color = UIColor(
            red: CGFloat.random(in: 0...1),
            green: CGFloat.random(in: 0...1),
            blue: CGFloat.random(in: 0...1),
            alpha: 1
        )
        
        let box = SKSpriteNode(color: color, size: size)
        box.zRotation = CGFloat.random(in: 0...3)
        box.position = position
        box.physicsBody = physicsManager.createPhysicsBody(for: .obstacle(size: size, color: color), size: size)
        addChild(box)
    }
    
    private func createBall(at position: CGPoint) {
        let ball = SKSpriteNode(imageNamed: "ballRed")
        ball.position = position
        ball.name = GameItem.ball.name
        ball.physicsBody = physicsManager.createPhysicsBody(for: .ball, size: ball.size)
        addChild(ball)
    }
    
    // MARK: - Collision Handling
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node, let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == GameItem.ball.name {
            handleCollision(ball: nodeA, with: nodeB)
        } else if nodeB.name == GameItem.ball.name {
            handleCollision(ball: nodeB, with: nodeA)
        }
    }
    
    private func handleCollision(ball: SKNode, with object: SKNode) {
        if object.name == "good" {
            destroyBall(ball)
            scoreManager.increment()
        } else if object.name == "bad" {
            destroyBall(ball)
            scoreManager.decrement()
        }
    }
    
    private func destroyBall(_ ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        ball.removeFromParent()
    }
}
