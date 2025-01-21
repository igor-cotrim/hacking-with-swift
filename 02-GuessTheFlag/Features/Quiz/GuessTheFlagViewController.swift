//
//  GuessTheFlagViewController.swift
//  02-GuessTheFlag
//
//  Created by Igor Cotrim on 16/12/24.
//

import UIKit

class GuessTheFlagViewController: UIViewController {
    @IBOutlet weak var buttonOne: UIButton!
    @IBOutlet weak var buttonTwo: UIButton!
    @IBOutlet weak var buttonThree: UIButton!
    
    private var quiz = Quiz()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startNewRound()
    }
    
    private func startNewRound() {
        quiz.startNewQuestion()
        updateUI()
    }
    
    private func updateUI() {
        buttonOne.setImage(UIImage(named: quiz.currentCountries[0]), for: .normal)
        buttonTwo.setImage(UIImage(named: quiz.currentCountries[1]), for: .normal)
        buttonThree.setImage(UIImage(named: quiz.currentCountries[2]), for: .normal)
        
        title = "\(quiz.currentCountries[quiz.correctAnswerIndex].uppercased()) | Score: \(quiz.score) | Question: \(quiz.questionNumber) to \(quiz.totalQuestions)"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .compose,
            target: self,
            action: #selector(showCurrentScore)
        )
    }
    
    private func presentAlert(title: String, message: String, action: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default) { _ in action() })
        present(alert, animated: true)
    }
    
    private func presentGameOverAlert() {
        let alert = UIAlertController(title: "Game Over!", message: "Your final score is \(quiz.score).", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Play Again", style: .default) { _ in
            self.quiz.resetGame()
            self.startNewRound()
        })
        present(alert, animated: true)
    }
    
    private func animate(_ button: UIButton) {
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       options: [],
                       animations: {
            button.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            UIView.animate(withDuration: 0.2,
                           delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0.5,
                           options: [],
                           animations: {
                button.transform = CGAffineTransform.identity
            })
        }
    }
    
    @objc private func showCurrentScore() {
        let alert = UIAlertController(
            title: "YOUR CURRENT SCORE",
            message: "\(quiz.score)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Continue", style: .default))
        present(alert, animated: true)
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        guard let index = [buttonOne, buttonTwo, buttonThree].firstIndex(of: sender) else { return }
        
        animate(sender)
        
        let isCorrect = quiz.checkAnswer(index: index)
        let message = isCorrect ? "Correct!" : "Wrong! That’s the flag of \(quiz.currentCountries[quiz.correctAnswerIndex])"
        
        if quiz.isGameOver {
            presentGameOverAlert()
        } else {
            presentAlert(title: message, message: "Your score is \(quiz.score).", action: startNewRound)
        }
    }
}
