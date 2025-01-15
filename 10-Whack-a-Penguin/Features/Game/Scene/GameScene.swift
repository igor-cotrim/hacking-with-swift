//
//  GameScene.swift
//  10-Whack-a-Penguin
//
//  Created by Igor Cotrim on 14/01/25.
//

import SpriteKit

class GameScene: SKScene {
    private var slots = [WhackSlot]()
    private var gameScore: SKLabelNode!
    private var finalScore: SKLabelNode!
    private let viewModel: GameViewModel
    
    init(size: CGSize, viewModel: GameViewModel) {
        self.viewModel = viewModel
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupScoreLabel()
        setupSlots()
        startGame()
        
        viewModel.onScoreChanged = { [weak self] newScore in
            self?.gameScore.text = "Score: \(newScore)"
        }
        
        viewModel.onGameOver = { [weak self] finalScore in
            self?.showGameOver(score: finalScore)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            guard let whackSlot = node.parent?.parent as? WhackSlot,
                  let characterType = whackSlot.viewModel.characterType,
                  whackSlot.viewModel.isVisible,
                  !whackSlot.viewModel.isHit else { continue }
            
            whackSlot.hit()
            viewModel.handleCharacterTap(type: characterType)
        }
    }
    
    // MARK: - Private Methods
    private func setupBackground() {
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
    }
    
    private func setupScoreLabel() {
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
    }
    
    private func setupSlots() {
        for i in 0..<5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 410)) }
        for i in 0..<4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 320)) }
        for i in 0..<5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 230)) }
        for i in 0..<4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 140)) }
    }
    
    private func createSlot(at position: CGPoint) {
        let slot = WhackSlot(viewModel: SlotViewModel())
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }
    
    private func startGame() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.createEnemy()
        }
    }
    
    private func createEnemy() {
        guard viewModel.gameState == .playing else { return }
        
        viewModel.incrementRound()
        
        guard viewModel.gameState == .playing else { return }
        
        slots.shuffle()
        showRandomSlots()
        scheduleNextEnemy()
    }
    
    private func showRandomSlots() {
        slots[0].show(hideTime: viewModel.popupTime)
        
        if Int.random(in: 0...12) > 4 { slots[1].show(hideTime: viewModel.popupTime) }
        if Int.random(in: 0...12) > 8 { slots[2].show(hideTime: viewModel.popupTime) }
        if Int.random(in: 0...12) > 10 { slots[3].show(hideTime: viewModel.popupTime) }
        if Int.random(in: 0...12) > 1 { slots[4].show(hideTime: viewModel.popupTime) }
    }
    
    private func scheduleNextEnemy() {
        guard viewModel.gameState == .playing else { return }
        
        let minDelay = viewModel.popupTime / 2.0
        let maxDelay = viewModel.popupTime * 2
        let delay = Double.random(in: minDelay...maxDelay)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self else { return }
            if self.viewModel.gameState == .playing {
                self.createEnemy()
            }
        }
    }
    
    private func showGameOver(score: Int) {
        for slot in slots {
            slot.hide()
        }
        
        removeAllActions()
        
        let gameOver = SKSpriteNode(imageNamed: "gameOver")
        gameOver.position = CGPoint(x: 512, y: 384)
        gameOver.zPosition = 1
        
        finalScore = SKLabelNode(fontNamed: "Chalkduster")
        finalScore.text = "Final Score: \(score)"
        finalScore.position = CGPoint(x: 512, y: 288)
        finalScore.fontSize = 32
        finalScore.zPosition = 1
        
        addChild(gameOver)
        addChild(finalScore)
    }
}
