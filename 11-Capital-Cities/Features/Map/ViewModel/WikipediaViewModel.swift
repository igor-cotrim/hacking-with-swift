//
//  WikipediaViewModel.swift
//  11-Capital-Cities
//
//  Created by Igor Cotrim on 23/01/25.
//

import Foundation
import WebKit

class WikipediaViewModel {
    let cityName: String
    let url: URL
    
    init(cityName: String, url: URL) {
        self.cityName = cityName
        self.url = url
    }
    
    func createURLRequest() -> URLRequest {
        return URLRequest(url: url)
    }
    
    var navigationTitle: String {
        return "\(cityName) on Wikipedia"
    }
}
