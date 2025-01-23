//
//  CapitalCitiesViewModel.swift
//  11-Capital-Cities
//
//  Created by Igor Cotrim on 23/01/25.
//

import Foundation
import MapKit

class CapitalCitiesViewModel {
    private(set) var capitals: [Capital]
    
    init() {
        self.capitals = Capital.defaultCapitals()
    }
    
    func getMapStyles() -> [(title: String, type: MKMapType)] {
        return [
            ("Standard", .standard),
            ("Hybrid", .hybrid),
            ("Muted Standard", .mutedStandard),
            ("Satellite", .satellite),
            ("Satellite Flyover", .satelliteFlyover)
        ]
    }
    
    func getWikipediaURL(for capital: Capital) -> URL? {
        guard let cityName = capital.title,
              let encodedCityName = cityName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        return URL(string: "https://en.wikipedia.org/wiki/\(encodedCityName)")
    }
}
