//
//  CapitalCitiesViewController.swift
//  11-Capital-Cities
//
//  Created by Igor Cotrim on 22/01/25.
//

import UIKit
import MapKit

class CapitalCitiesViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let london = Capital(
            title: "London",
            coordinate: CLLocationCoordinate2DMake(51.507222, -0.1275),
            info: "Home to the 2012 Summer Olympics"
        )
        let oslo = Capital(
            title: "Oslo",
            coordinate: CLLocationCoordinate2DMake(59.95, 10.75),
            info: "Founded over a thousand years ago"
        )
        let paris = Capital(
            title: "Paris",
            coordinate: CLLocationCoordinate2DMake(48.8567, 2.3508),
            info: "Oftn called the City of Love"
        )
        let rome = Capital(
            title: "Rome",
            coordinate: CLLocationCoordinate2DMake(41.9, 12.5),
            info: "Has a whole country inside it"
        )
        let washingtionDc = Capital(
            title: "Washington D.C",
            coordinate: CLLocationCoordinate2DMake(38.895111, -77.036667),
            info: "Named after George himself"
        )

        mapView.addAnnotations([london, oslo, paris, rome, washingtionDc])
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let identifier = "CapitalAnnotation"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(
                annotation: annotation,
                reuseIdentifier: identifier
            )
            annotationView?.canShowCallout = true
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(
        _ mapView: MKMapView,
        annotationView view: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl
    ) {
        guard let capital = view.annotation as? Capital else { return }
        
        let alert = UIAlertController(
            title: capital.title,
            message: capital.info,
            preferredStyle: .alert
        )
        
        present(alert, animated: true)
    }
}
