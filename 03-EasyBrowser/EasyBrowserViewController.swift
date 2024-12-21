//
//  EasyBrowserViewController.swift
//  03-EasyBrowser
//
//  Created by Igor Cotrim on 20/12/24.
//

import UIKit
import WebKit

class EasyBrowserViewController: UIViewController {
    var webView: WKWebView!
    var progressView: UIProgressView!
    var websites: [String] = [
        "Google",
        "Github",
        "Stackoverflow",
    ]
    var selectedWebsite: String?
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Open",
            style: .plain,
            target: self,
            action: #selector(openTapped)
        )
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refreshButton = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: webView,
            action: #selector(webView.reload)
        )
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                         style: .plain,
                                         target: webView,
                                         action: #selector(webView.goBack))
        let forwardButton = UIBarButtonItem(image: UIImage(systemName: "chevron.forward"),
                                            style: .plain,
                                            target: webView,
                                            action: #selector(webView.goForward))
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        
        let progressButton = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [
            progressButton,
            spacer,
            backButton,
            forwardButton,
            refreshButton
        ]
        navigationController?.isToolbarHidden = false
        
        webView
            .addObserver(
                self,
                forKeyPath: #keyPath(WKWebView.estimatedProgress),
                options: .new,
                context: nil
            )
        guard let selectedWebsite = selectedWebsite else { return }
        let url = URL(string: "https://www.\(selectedWebsite.lowercased()).com")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    @objc private func openTapped() {
        let alertController = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        
        for website in websites {
            alertController
                .addAction(
                    UIAlertAction(
                        title: website,
                        style: .default,
                        handler: openPage
                    )
                )
        }
        alertController
            .addAction(
                UIAlertAction(title: "Cancel", style: .cancel)
            )
        alertController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(alertController, animated: true)
    }
    
    private func openPage(action: UIAlertAction) {
        guard let urlString = action.title?.lowercased(),
              let url = URL(string: "https://\(urlString).com") else { return }
        
        webView.load(URLRequest(url: url))
    }
}

// MARK: - WKNavigationDelegate
extension EasyBrowserViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping @MainActor (WKNavigationActionPolicy) -> Void
    ) {
        guard let url = navigationAction.request.url, let host = url.host else {
            decisionHandler(.cancel)
            return
        }
        
        if host.contains("google.com"), url.path.contains("/search") {
            decisionHandler(.allow)
            return
        }
        
        for website in websites {
            if host.contains(website.lowercased()) {
                decisionHandler(.allow)
                return
            }
        }
        
        let alertController = UIAlertController(
            title: "This website is not supported",
            message: "Please choose another website",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            let googleURL = URL(string: "https://google.com")!
            self.webView.load(URLRequest(url: googleURL))
        }))
        
        decisionHandler(.cancel)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView?.estimatedProgress ?? 0.0)
        }
    }
}


