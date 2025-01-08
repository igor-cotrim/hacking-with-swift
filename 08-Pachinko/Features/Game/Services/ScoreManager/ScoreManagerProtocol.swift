//
//  ScoreManagerProtocol.swift
//  08-Pachinko
//
//  Created by Igor Cotrim on 08/01/25.
//

protocol ScoreManagerProtocol {
    var score: Int { get }
    func increment()
    func decrement()
    func reset()
}
