//
//  BallsManager.swift
//  Swift
//
//  Created by Igor Cotrim on 08/01/25.
//

import Foundation

class BallsManager: BallsManagerProtocol {
    private(set) var balls: Int = 5
    var onBallsChanged: ((Int) -> Void)?
    
    func increment() {
        balls += 1
        onBallsChanged?(balls)
    }
    
    func decrement() {
        if balls > 0 {
            balls -= 1
            onBallsChanged?(balls)
        }
    }
    
    func reset() {
        balls = 5
        onBallsChanged?(balls)
    }
}
