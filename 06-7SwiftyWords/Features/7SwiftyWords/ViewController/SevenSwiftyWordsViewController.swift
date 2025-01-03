//
//  SevenSwiftyWordsViewController.swift
//  06-7SwiftyWords
//
//  Created by Igor Cotrim on 02/01/25.
//

import UIKit

class SevenSwiftyWordsViewController: UIViewController {
    // MARK: - Properties
    private let contentView = SevenSwiftyWordsView()
    private let viewModel = SevenSwiftyWordsViewModel()
    //
    //    // MARK: - Initializer
    //    init(contentView: SevenSwiftyWordsView) {
    //        self.contentView = contentView
    //
    //        super.init(nibName: nil, bundle: nil)
    //    }
    //
    //    @available (*, unavailable)
    //    required init?(coder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
        contentView.setup()
    }
    
    private func setupBindings() {
        contentView.onLevelUp = { [weak self] in
            let action = UIAlertController(
                title: "Well done!",
                message: "Are you ready for the next challenge?",
                preferredStyle: .alert
            )
            action
                .addAction(
                    UIAlertAction(
                        title: "Let's go!",
                        style: .default,
                        handler: { _ in self?.contentView.levelUp() }
                    )
                )
            
            self?.present(action, animated: true)
        }
        
        contentView.onWrongAnswer = { [weak self] in
            let action = UIAlertController(
                title: "Your answer is wrong!",
                message: "Try again",
                preferredStyle: .alert
            )
            action
                .addAction(
                    UIAlertAction(
                        title: "Ok",
                        style: .default,
                        handler: { _ in self?.contentView.wrongAnswer() }
                    )
                )
            
            self?.present(action, animated: true)
        }
    }
}
