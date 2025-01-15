//
//  CharacterType.swift
//  Swift
//
//  Created by Igor Cotrim on 15/01/25.
//

enum CharacterType {
    case friend
    case enemy
    
    var textureName: String {
        switch self {
        case .friend: return "penguinGood"
        case .enemy: return "penguinEvil"
        }
    }
    
    var nodeName: String {
        switch self {
        case .friend: return "charFriend"
        case .enemy: return "charEnemy"
        }
    }
}
