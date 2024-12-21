//
//  EasyBrowserViewController.swift
//  03-EasyBrowser
//
//  Created by Igor Cotrim on 20/12/24.
//

import UIKit
@preconcurrency import WebKit

class EasyBrowserViewController: UIViewController {
    private var webView: WKWebView!
    private var progressView: UIProgressView!
    var selectedWebsite: String?
    private let viewModel = EasyBrowserViewModel()
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupToolbar()
        observeWebViewProgress()
        loadSelectedWebsite()
    }
    
    // MARK: - Setup Methods
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Open",
            style: .plain,
            target: self,
            action: #selector(openTapped)
        )
    }
    
    private func setupToolbar() {
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: webView, action: #selector(webView.goBack))
        let forwardButton = UIBarButtonItem(image: UIImage(systemName: "chevron.forward"), style: .plain, target: webView, action: #selector(webView.goForward))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [progressButton, spacer, backButton, forwardButton, refreshButton]
        navigationController?.isToolbarHidden = false
    }
    
    private func observeWebViewProgress() {
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    private func loadSelectedWebsite() {
        guard let selectedWebsite = selectedWebsite,
              let url = viewModel.buildURL(for: selectedWebsite) else { return }
        
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    // MARK: - User Actions
    @objc private func openTapped() {
        let alertController = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        
        for website in viewModel.websites {
            alertController.addAction(
                UIAlertAction(title: website, style: .default, handler: { [weak self] action in
                    self?.openPage(action.title)
                })
            )
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(alertController, animated: true)
    }
    
    private func openPage(_ website: String?) {
        guard let website = website, let url = viewModel.buildURL(for: website) else { return }
        webView.load(URLRequest(url: url))
    }
}

// MARK: - WKNavigationDelegate
extension EasyBrowserViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }
        
        if viewModel.isAllowed(url: url) {
            decisionHandler(.allow)
        } else {
            decisionHandler(.cancel)
            showAlert(
                title: Constants.errorTitle,
                message: Constants.errorMessage,
                actions: [
                    UIAlertAction(title: "Ok", style: .default, handler: { [weak self] _ in
                        if let googleURL = URL(string: Constants.googleURL) {
                            self?.webView.load(URLRequest(url: googleURL))
                        }
                    })
                ]
            )
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
}
