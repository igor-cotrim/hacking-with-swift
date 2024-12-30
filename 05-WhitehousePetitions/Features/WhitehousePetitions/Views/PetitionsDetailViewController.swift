//
//  PetitionsDetailViewController.swift
//  05-WhitehousePetitions
//
//  Created by Igor Cotrim on 27/12/24.
//

import UIKit
import WebKit

class PetitionsDetailViewController: UIViewController {
    private var webView: WKWebView!
    var detailItem: PetitionModel?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let detailItem = detailItem else { return }
        
        let html = """
            <html>
                <head>
                    <meta name="viewport" content="width=device-width, initial-scale=1">
                    <style>
                        body {
                            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
                            font-size: 18px;
                            line-height: 1.6;
                            color: #333;
                            margin: 20px;
                            padding: 0;
                            background-color: #f9f9f9;
                        }
                        h1 {
                            font-size: 24px;
                            text-align: center;
                            color: #007AFF;
                            margin-bottom: 20px;
                        }
                        p {
                            text-align: justify;
                            margin-bottom: 15px;
                        }
                        .signature-count {
                            font-size: 16px;
                            color: #666;
                            text-align: center;
                            margin-top: 20px;
                            padding: 10px;
                            border-top: 1px solid #ddd;
                        }
                    </style>
                </head>
                <body>
                    <h1>\(detailItem.title)</h1>
                    <p>\(detailItem.body)</p>
                    <div class="signature-count">
                        Signatures: \(detailItem.signatureCount)
                    </div>
                </body>
            </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)
    }
}
