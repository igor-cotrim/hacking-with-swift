//
//  PetitionsDetailViewController.swift
//  05-WhitehousePetitions
//
//  Created by Igor Cotrim on 27/12/24.
//

import UIKit
import WebKit

class PetitionsDetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: PetitionModel?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let detailItem else { return }
        
        let html = """
                <html>
                    <head>
                        <meta name="viewport" content="width=device-width, initial-scale=1">
                        <style> body { font-size: 150%; } </style>
                    </head>
                    <body>
                        \(detailItem.body)
                    </body>
                </html>
                """
        
        webView.loadHTMLString(html, baseURL: nil)
    }
}
