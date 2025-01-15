//
//  WhackSlot.swift
//  Swift
//
//  Created by Igor Cotrim on 15/01/25.
//

import SpriteKit

class WhackSlot: SKNode {
    private(set) var charNode: SKSpriteNode!
    let viewModel: SlotViewModel
    
    init(viewModel: SlotViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(at position: CGPoint) {
        self.position = position
        setupSlotSprite()
        setupCharacterNode()
    }
    
    func show(hideTime: Double) {
        guard !viewModel.isVisible else { return }
        
        viewModel.show()
        updateCharacterAppearance()
        animateShow()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + hideTime * 3.5) { [weak self] in
            self?.hide()
        }
    }
    
    func hide() {
        guard viewModel.isVisible else { return }
        
        viewModel.hide()
        animateHide()
    }
    
    func hit() {
        viewModel.hit()
        
        let scaleDown = SKAction.scale(to: 0.85, duration: 0.05)
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        
        let notVisible = SKAction.run { [weak self] in
            self?.viewModel.hide()
        }
        
        let sequence = SKAction.sequence([
            scaleDown,
            delay,
            hide,
            notVisible
        ])
        
        charNode.run(sequence)
    }
    
    // MARK: - Private Methods
    private func setupSlotSprite() {
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
    }
    
    private func setupCharacterNode() {
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        
        cropNode.addChild(charNode)
        addChild(cropNode)
    }
    
    private func updateCharacterAppearance() {
        guard let characterType = viewModel.characterType else { return }
        charNode.texture = SKTexture(imageNamed: characterType.textureName)
        charNode.name = characterType.nodeName
        charNode.xScale = 1
        charNode.yScale = 1
    }
    
    private func animateShow() {
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
    }
    
    private func animateHide() {
        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
    }
    
    private func animateHit() {
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let notVisible = SKAction.run { [weak self] in
            self?.viewModel.hide()
        }
        let sequence = SKAction.sequence([delay, hide, notVisible])
        charNode.run(sequence)
    }
}
