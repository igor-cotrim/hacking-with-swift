//
//  CapitalCitiesViewController.swift
//  11-Capital-Cities
//
//  Created by Igor Cotrim on 22/01/25.
//

import UIKit
import MapKit

class CapitalCitiesViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    private let viewModel = CapitalCitiesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
        setupNavigationBar()
    }
    
    private func setupMapView() {
        mapView.delegate = self
        mapView.addAnnotations(viewModel.capitals)
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Edit Map Style",
            style: .plain,
            target: self,
            action: #selector(chooseMapStyle)
        )
    }
    
    @objc private func chooseMapStyle() {
        let alert = UIAlertController(
            title: "Choose Map Style",
            message: "Select a map display style",
            preferredStyle: .actionSheet
        )
        
        viewModel.getMapStyles().forEach { style in
            alert.addAction(
                UIAlertAction(title: style.title, style: .default) { [weak self] _ in
                    self?.mapView.mapType = style.type
                }
            )
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: - MKMapViewDelegate
extension CapitalCitiesViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let capital = annotation as? Capital else { return nil }
        
        let identifier = "CapitalAnnotation"
        let annotationView = MKMarkerAnnotationView(annotation: capital, reuseIdentifier: identifier)
        
        annotationView.canShowCallout = true
        annotationView.markerTintColor = .systemBlue
        annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital,
              let url = viewModel.getWikipediaURL(for: capital) else { return }
        
        let wikipediaVM = WikipediaViewModel(cityName: capital.title ?? "", url: url)
        let wikipediaVC = WikipediaViewController(viewModel: wikipediaVM)
        
        let navController = UINavigationController(rootViewController: wikipediaVC)
        navController.modalPresentationStyle = .fullScreen
        
        present(navController, animated: true)
    }
}
