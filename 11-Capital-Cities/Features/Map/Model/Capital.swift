//
//  Capital.swift
//  11-Capital-Cities
//
//  Created by Igor Cotrim on 22/01/25.
//

import UIKit
import MapKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String

    init(
        title: String? = nil,
        coordinate: CLLocationCoordinate2D,
        info: String
    ) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
