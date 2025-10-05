//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Eltonia Leonard on 10/3/25.
//

import UIKit
import MapKit
import CoreLocation

final class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // location manager and one time zoom flag
    private let locationManager = CLLocationManager()
    private var hasZoomedToUser = false


    var mapView: MKMapView!

    override func loadView() {
        // Create a map view
        mapView = MKMapView()

        // Set it as *the* view of this view controller
        view = mapView
        
        // show the blue dot
        mapView.showsUserLocation = true
        
        // receive user location updates
        mapView.delegate = self
        
        //Segmented controls
        let segmentedControl
                 = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
         segmentedControl.backgroundColor = UIColor.systemBackground
         segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self,
                                   action: #selector(mapTypeChanged(_:)),
                                   for: .valueChanged)

         segmentedControl.translatesAutoresizingMaskIntoConstraints = false
         view.addSubview(segmentedControl)
        
        //Define constraints
        let topConstraint =
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                  constant: 8)
        let margins = view.layoutMarginsGuide
        let leadingConstraint =
            segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint =
            segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        // Activate constraints
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
        // Points of Interest (label and switch)
        let poiLabel = UILabel()
        poiLabel.text = "Points of Interest"
        poiLabel.translatesAutoresizingMaskIntoConstraints = false

        let poiSwitch = UISwitch()
        poiSwitch.isOn = true                           // default ON
        poiSwitch.translatesAutoresizingMaskIntoConstraints = false
        poiSwitch.addTarget(self, action: #selector(togglePOI(_:)), for: .valueChanged)

        // add to view
        view.addSubview(poiLabel)
        view.addSubview(poiSwitch)

        // layout under the segmented control (uses safe area margins)
        NSLayoutConstraint.activate([
            poiLabel.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 12),
            poiLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),

            poiSwitch.centerYAnchor.constraint(equalTo: poiLabel.centerYAnchor),
            poiSwitch.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])

        // initial state
        mapView.pointOfInterestFilter = .includingAll
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        print("MapViewController loaded its view.")
    }
    
    // Case function forsegmentedControl
    @objc func mapTypeChanged(_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }

    // toggle Points of Interests on/off
    @objc private func togglePOI(_ sender: UISwitch) {
        mapView.pointOfInterestFilter = sender.isOn ? .includingAll : .excludingAll
    }
    
    // MKMapViewDelegate (called when blue dot location updates)
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        guard !hasZoomedToUser, CLLocationCoordinate2DIsValid(userLocation.coordinate) else { return }

        let region = MKCoordinateRegion(center: userLocation.coordinate,
                                        latitudinalMeters: 2000,
                                        longitudinalMeters: 2000)
        mapView.setRegion(region, animated: true)
        hasZoomedToUser = true
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.delegate = self
        // if not decided yet, ask and if already allowed, we will get updates immediately
        locationManager.requestWhenInUseAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        default:
            break
        }
    }

}
