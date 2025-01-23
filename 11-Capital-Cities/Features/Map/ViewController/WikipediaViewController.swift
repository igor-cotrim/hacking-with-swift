//
//  WikipediaViewController.swift
//  11-Capital-Cities
//
//  Created by Igor Cotrim on 23/01/25.
//

import UIKit
import WebKit

class WikipediaViewController: UIViewController {
    private let viewModel: WikipediaViewModel
    private var webView: WKWebView!
    
    init(viewModel: WikipediaViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.load(viewModel.createURLRequest())
        
        title = viewModel.navigationTitle
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(dismissViewController)
        )
    }
    
    @objc private func dismissViewController() {
        dismiss(animated: true)
    }
}
