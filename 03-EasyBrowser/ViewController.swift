//
//  ViewController.swift
//  03-EasyBrowser
//
//  Created by Igor Cotrim on 20/12/24.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    var webView: WKWebView!
    var progressView: UIProgressView!
    var websites: [String] = [
        "Google",
        "Apple",
        "Youtube",
        "Github",
        "Stackoverflow",
    ]
    
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
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        
        let progressButton = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [progressButton, spacer, refreshButton]
        navigationController?.isToolbarHidden = false
        
        webView
            .addObserver(
                self,
                forKeyPath: #keyPath(WKWebView.estimatedProgress),
                options: .new,
                context: nil
            )
        let url = URL(string: "https://www.\(websites[0].lowercased()).com")!
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
extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping @MainActor (WKNavigationActionPolicy) -> Void
    ) {
        let url = navigationAction.request.url
        
        if let host = url?.host {
            for website in websites {
                if host.contains("\(website.lowercased()).com") {
                    decisionHandler(.allow)
                    return
                }
            }
        }
        
        decisionHandler(.cancel)
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


