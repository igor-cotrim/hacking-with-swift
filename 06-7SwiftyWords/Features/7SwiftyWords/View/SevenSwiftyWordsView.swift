//
//  SevenSwiftyWordsView.swift
//  06-7SwiftyWords
//
//  Created by Igor Cotrim on 02/01/25.
//

import UIKit

final class SevenSwiftyWordsView: UIView {
    // MARK: - Properties
    private var letterButtons = [UIButton]()
    private var usedButtons: Set<UIButton> = []
    private var currentButtons: [UIButton] = []
    
    var onSubmitAnswer: (() -> Void)?
    var onLetterTapped: ((String, UIButton) -> Void)?
    var onClearTapped: (() -> Void)?
    
    // MARK: - Subviews
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.text = "Score: 0"
        return label
    }()
    
    private let cluesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24)
        label.text = "CLUES"
        label.numberOfLines = 0
        label.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        return label
    }()
    
    private let answersLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24)
        label.text = "ANSWERS"
        label.textAlignment = .right
        label.numberOfLines = 0
        label.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        return label
    }()
    
    private let currentAnswer: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .center
        textField.placeholder = "Tap letters to guess"
        textField.font = UIFont.systemFont(ofSize: 44)
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("SUBMIT", for: .normal)
        return button
    }()
    
    private let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("CLEAR", for: .normal)
        return button
    }()
    
    private let buttonsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.cgColor
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        
        setupView()
        buildViewHierarchy()
        buildViewConstraints()
        buildActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupView() {
        backgroundColor = .white
        
        setupLetterButtons()
    }
    
    private func setupLetterButtons() {
        let width = 150
        let height = 80
        
        for row in 0..<4 {
            for column in 0..<5 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.setTitle("WWW", for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                let frame = CGRect(
                    x: column * width,
                    y: row * height,
                    width: width,
                    height: height
                )
                letterButton.frame = frame
                
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }
    }
    
    private func buildViewHierarchy() {
        addSubview(scoreLabel)
        addSubview(cluesLabel)
        addSubview(answersLabel)
        addSubview(currentAnswer)
        addSubview(submitButton)
        addSubview(clearButton)
        addSubview(buttonsView)
    }
    
    private func buildViewConstraints() {
        NSLayoutConstraint.activate(
            [
                scoreLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
                scoreLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
                
                cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
                cluesLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 100),
                cluesLabel.widthAnchor.constraint(equalTo: layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
                
                answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
                answersLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -100),
                answersLabel.widthAnchor.constraint(equalTo: layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: 100),
                answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
                
                currentAnswer.centerXAnchor.constraint(equalTo: centerXAnchor),
                currentAnswer.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
                currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
                
                submitButton.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
                submitButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -100),
                submitButton.heightAnchor.constraint(equalToConstant: 44),
                
                clearButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 100),
                clearButton.centerYAnchor.constraint(equalTo: submitButton.centerYAnchor),
                clearButton.heightAnchor.constraint(equalToConstant: 44),
                
                buttonsView.widthAnchor.constraint(equalToConstant: 750),
                buttonsView.heightAnchor.constraint(equalToConstant: 320),
                buttonsView.centerXAnchor.constraint(equalTo: centerXAnchor),
                buttonsView.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 20),
                buttonsView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            ]
        )
    }
    
    private func buildActions() {
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
    }
}

// MARK: - Public Methods
extension SevenSwiftyWordsView {
    func updateScore(_ score: Int) {
        scoreLabel.text = "Score: \(score)"
    }
    
    func updateClues(_ clues: String) {
        cluesLabel.text = clues
    }
    
    func updateAnswers(_ answers: String) {
        answersLabel.text = answers
    }
    
    func updateLetterButtons(_ letters: [String]) {
        usedButtons.removeAll()
        currentButtons.removeAll()
        for (index, letter) in letters.enumerated() where index < letterButtons.count {
            letterButtons[index].setTitle(letter, for: .normal)
            letterButtons[index].alpha = 1
            letterButtons[index].isUserInteractionEnabled = true
        }
    }
    
    func updateCurrentAnswer(_ text: String) {
        currentAnswer.text = text
    }
    
    func resetCurrentButtons() {
        for button in currentButtons {
            if !usedButtons.contains(button) {
                UIView.animate(withDuration: 0.3) {
                    button.alpha = 1
                    button.isUserInteractionEnabled = true
                }
            }
        }
        currentButtons.removeAll()
    }
    
    func markButtonsAsUsedInCorrectWord() {
        for button in currentButtons {
            usedButtons.insert(button)
        }
        currentButtons.removeAll()
    }
}

// MARK: - Objc methods
@objc extension SevenSwiftyWordsView {
    private func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        onLetterTapped?(buttonTitle, sender)
        currentButtons.append(sender)
        
        UIView.animate(withDuration: 0.3) {
            sender.alpha = 0
            sender.isUserInteractionEnabled = false
        }
    }
    
    private func submitTapped(_ sender: UIButton) {
        onSubmitAnswer?()
    }
    
    private func clearTapped(_ sender: UIButton) {
        onClearTapped?()
    }
}
