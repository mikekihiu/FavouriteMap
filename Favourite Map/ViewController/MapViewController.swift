//
//  MapViewController.swift
//  Favourite Map
//
//  Created by Mike on 12/11/2020.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var mapItem: MKMapItem?
    var boundingRegion: MKCoordinateRegion?
    
    private enum AnnotationReusableID: String {
        case pin
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        if let region = boundingRegion {
            mapView.region = region
        }
        if let mapItem = mapItem {
            mapView.region.center = mapItem.placemark.coordinate
            mapView.addAnnotation(Location(coordinate: mapItem.placemark.coordinate, title: mapItem.name!))
            BookmarkedLocation.save(mapItem)
        }

        // Register reusable identifiers
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: AnnotationReusableID.pin.rawValue)
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapViewDidFailLoadingMap(_ mapView: MKMapView, withError error: Error) {
        print("Failed to load the map: \(error)")
        showError(error)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Location else { return nil }
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: AnnotationReusableID.pin.rawValue, for: annotation) as? MKMarkerAnnotationView
        view?.clusteringIdentifier = "searchResult"
        return view
    }
}




