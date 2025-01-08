//
//  GameItem.swift
//  08-Pachinko
//
//  Created by Igor Cotrim on 08/01/25.
//

import Foundation
import UIKit

enum GameItem {
    case ball
    case bouncer
    case slot(isGood: Bool)
    case obstacle(size: CGSize, color: UIColor)
    
    var name: String {
        switch self {
        case .ball: return "ball"
        case .bouncer: return "bouncer"
        case .slot(let isGood): return isGood ? "good" : "bad"
        case .obstacle: return "obstacle"
        }
    }
}
