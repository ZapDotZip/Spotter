//
//  CustomMapViewDelegate.swift
//  Spotter
//

import UIKit
import MapKit

class CustomMapViewDelegate: NSObject, MKMapViewDelegate {
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		if annotation is MKUserLocation {
			return nil
		}
		let annotationView = MKAnnotationView()
		annotationView.annotation = annotation
		annotationView.image = UIImage(systemName: "mappin.circle.fill")?.withRenderingMode(.alwaysOriginal)
		return annotationView
	}
}
