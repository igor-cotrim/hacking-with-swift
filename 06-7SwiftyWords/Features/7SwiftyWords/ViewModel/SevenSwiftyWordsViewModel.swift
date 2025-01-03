//
//  SevenSwiftyWordsViewModel.swift
//  06-7SwiftyWords
//
//  Created by Igor Cotrim on 02/01/25.
//

import Foundation
import UIKit

final class SevenSwiftyWordsViewModel {
    var onUpdateScore: ((Int) -> Void)?
    var onUpdateCluesAndAnswers: ((String, String) -> Void)?
    var onUpdateLetterButtons: (([String]) -> Void)?

    private(set) var score = 0 {
        didSet {
            onUpdateScore?(score)
        }
    }

    func loadLevel() {
        // Implementar carregamento do nível
    }

    func selectLetter(_ letter: String, button: UIButton) {
        // Implementar lógica para letra selecionada
    }

    func submitAnswer() {
        // Implementar lógica para submissão
    }

    func clearInput() {
        // Implementar lógica para limpar entrada
    }
}
