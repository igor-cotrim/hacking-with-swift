//
//  SevenSwiftyWordsViewController.swift
//  06-7SwiftyWords
//
//  Created by Igor Cotrim on 02/01/25.
//

import UIKit

final class SevenSwiftyWordsViewController: UIViewController {
    private let contentView = SevenSwiftyWordsView()
    private let viewModel = SevenSwiftyWordsViewModel()
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        viewModel.loadLevel()
    }
    
    private func setupBindings() {
        // View -> ViewModel bindings
        contentView.onLetterTapped = { [weak self] letter, button in
            self?.viewModel.appendLetter(letter)
        }
        
        contentView.onSubmitAnswer = { [weak self] in
            self?.viewModel.submitAnswer()
        }
        
        contentView.onClearTapped = { [weak self] in
            self?.viewModel.clearCurrentAnswer()
        }
        
        // ViewModel -> View bindings
        viewModel.onCurrentAnswerUpdated = { [weak self] text in
            self?.contentView.updateCurrentAnswer(text)
        }
        
        viewModel.onMarkButtonsAsUsed = { [weak self] in
            self?.contentView.markButtonsAsUsedInCorrectWord()
        }
        
        viewModel.onClearButtons = { [weak self] in
            self?.contentView.resetCurrentButtons()
        }
        
        viewModel.onResetCurrentButtons = { [weak self] in
            self?.contentView.resetCurrentButtons()
        }
        
        viewModel.onScoreUpdated = { [weak self] score in
            self?.contentView.updateScore(score)
        }
        
        viewModel.onCluesUpdated = { [weak self] clues in
            self?.contentView.updateClues(clues)
        }
        
        viewModel.onAnswersUpdated = { [weak self] answers in
            self?.contentView.updateAnswers(answers)
        }
        
        viewModel.onLettersUpdated = { [weak self] letters in
            self?.contentView.updateLetterButtons(letters)
        }
        
        viewModel.onLevelCompleted = { [weak self] in
            let action = UIAlertController(
                title: "Well done!",
                message: "Are you ready for the next challenge?",
                preferredStyle: .alert
            )
            action.addAction(
                UIAlertAction(
                    title: "Let's go!",
                    style: .default,
                    handler: { [weak self] _ in
                        self?.viewModel.levelUp()
                    }
                )
            )
            self?.present(action, animated: true)
        }
        
        viewModel.onWrongAnswer = { [weak self] in
            let action = UIAlertController(
                title: "Your answer is wrong!",
                message: "Try again",
                preferredStyle: .alert
            )
            action.addAction(
                UIAlertAction(
                    title: "Ok",
                    style: .default
                )
            )
            self?.present(action, animated: true)
        }
    }
}
