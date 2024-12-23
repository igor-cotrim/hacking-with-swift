//
//  ViewController.swift
//  04-WordScramble
//
//  Created by Igor Cotrim on 23/12/24.
//

import UIKit

class WordScrambleViewController: UITableViewController {
    var allWords: [String] = []
    var usedWords: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(promptForAnswer)
        )
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(
                contentsOf: startWordsURL,
                encoding: .utf8
            ) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        startGame()
    }
    
    private func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    @objc private func promptForAnswer() {
        let alert = UIAlertController(title: "Enter Answer", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.autocapitalizationType = .words
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak alert] _ in
            guard let answer = alert?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        alert.addAction(submitAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        let errorTitle: String
        let errorMessage: String
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(answer, at: 0)
                    
                    let IndexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [IndexPath], with: .automatic)
                    
                    return
                } else {
                    errorTitle = "Word not recognized"
                    errorMessage = "You can't just make them up, you know!"
                }
            } else {
                errorTitle = "Word already used"
                errorMessage = "Be more original, please!"
            }
        } else {
            errorTitle = "Word not possible"
            errorMessage = "You can't make words out of letters you don't have!"
        }
        
        let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        
        for character in word {
            if let index = tempWord.firstIndex(of: character) {
                tempWord.remove(at: index)
            } else {
                return false
            }
        }
        
        return true
    }
    
    private func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    private func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
}

// MARK: - TableView
extension WordScrambleViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        let word = usedWords[indexPath.row]
        cell.textLabel?.text = word
        
        return cell
    }
}
