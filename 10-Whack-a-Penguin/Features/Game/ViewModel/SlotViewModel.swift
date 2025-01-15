//
//  SlotViewModel.swift
//  Swift
//
//  Created by Igor Cotrim on 15/01/25.
//

class SlotViewModel {
    private(set) var isVisible = false
    private(set) var isHit = false
    private(set) var characterType: CharacterType?
    
    func show() {
        isVisible = true
        isHit = false
        characterType = Bool.random() ? .friend : .enemy
    }
    
    func hide() {
        isVisible = false
        characterType = nil
    }
    
    func hit() {
        isHit = true
    }
}
