//
//  ViewController.swift
//  04-WordScramble
//
//  Created by Igor Cotrim on 23/12/24.
//

import UIKit

final class WordScrambleViewController: UITableViewController {
    private var viewModel = WordScrambleViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        bindViewModel()
        viewModel.startGame()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(promptForAnswer)
        )
    }
    
    private func bindViewModel() {
        viewModel.onGameStart = { [weak self] title in
            self?.title = title
            self?.tableView.reloadData()
        }
        
        viewModel.onWordAdded = { [weak self] indexPath in
            self?.tableView.insertRows(at: [indexPath], with: .automatic)
        }
        
        viewModel.onError = { [weak self] errorTitle, errorMessage in
            let alert = UIAlertController(
                title: errorTitle,
                message: errorMessage,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }
    
    @objc private func promptForAnswer() {
        let alert = UIAlertController(title: "Enter Answer", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.autocapitalizationType = .words
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak alert] _ in
            guard let answer = alert?.textFields?[0].text else { return }
            self?.viewModel.submit(answer: answer)
        }
        
        alert.addAction(submitAction)
        present(alert, animated: true)
    }
}

// MARK: - TableView
extension WordScrambleViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        let word = viewModel.usedWords[indexPath.row]
        cell.textLabel?.text = word
        
        return cell
    }
}
