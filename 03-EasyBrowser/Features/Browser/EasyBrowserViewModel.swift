//
//  EasyBrowserViewModel.swift
//  03-EasyBrowser
//
//  Created by Igor Cotrim on 20/12/24.
//

import Foundation

final class EasyBrowserViewModel {
    private(set) var websites: [String] = ["Google", "Github", "Stackoverflow"]
    
    func isAllowed(url: URL) -> Bool {
        guard let host = url.host else { return false }
        
        if host.contains("google.com"), url.path.contains("/search") {
            return true
        }
        return websites.contains { host.contains($0.lowercased()) }
    }
    
    func buildURL(for website: String) -> URL? {
        let urlString = "https://\(website.lowercased()).com"
        return URL(string: urlString)
    }
}
