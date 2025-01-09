//
//  BallsManagerProtocol.swift
//  Swift
//
//  Created by Igor Cotrim on 08/01/25.
//

protocol BallsManagerProtocol {
    var balls: Int { get }
    func increment()
    func decrement()
    func reset()
}
