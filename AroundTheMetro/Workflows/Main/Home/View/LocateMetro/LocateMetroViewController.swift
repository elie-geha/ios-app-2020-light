//
//  LocateMetroViewController.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 24.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import MapKit
import UIKit
import SVProgressHUD

class StationAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?

    init(with coordinate: CLLocationCoordinate2D, title: String) {
        self.coordinate = coordinate
        self.title = title
    }
}

class LocateMetroViewController: UIViewController {
    @IBOutlet var noDataView: UIView!
    @IBOutlet var mapView: MKMapView!

    var stations: [MetroStationLocation] = [] {
        didSet {
            if isViewLoaded {
                loadPins(with: stations)
            }
        }
    }

    private var locationManager = CLLocationManager()
    private var locatingMe: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        loadPins(with: stations)
    }

    @IBAction func locateMe() {
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .notDetermined || CLLocationManager.authorizationStatus() == .denied {
                locatingMe = true
                locationManager.requestWhenInUseAuthorization()
                SVProgressHUD.show()
            } else if let location = mapView.userLocation.location {
                mapView.setRegion(MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 200, longitudinalMeters: 200),
                                  animated: true)
            } else {
                print("Unable to show user location")
            }
        } else {
            print("Unable to show user location")
        }
    }

    private func loadPins(with stations: [MetroStationLocation]) {
        noDataView.isHidden = !stations.isEmpty

        var leftTopOfPins: CLLocationCoordinate2D?
        var rightBottomOfPins: CLLocationCoordinate2D?
        let annotations: [StationAnnotation] = stations.map {
            let lat = CLLocationDegrees($0.latitude)
            let long = CLLocationDegrees($0.longitude)

            if let leftTop = leftTopOfPins {
                if leftTop.latitude > lat { leftTopOfPins?.latitude = lat }
                if leftTop.longitude > long { leftTopOfPins?.longitude = long }
            } else {
                leftTopOfPins = CLLocationCoordinate2D(latitude: lat, longitude: long)
            }

            if let rightBottom = rightBottomOfPins {
                if rightBottom.latitude < lat { rightBottomOfPins?.latitude = lat }
                if rightBottom.longitude < long { rightBottomOfPins?.longitude = long }
            } else {
                rightBottomOfPins = CLLocationCoordinate2D(latitude: lat, longitude: long)
            }

            return StationAnnotation(with: CLLocationCoordinate2D(latitude: lat,
                                                                  longitude: long),
                              title: $0.name)
        }

        mapView.addAnnotations(annotations)

        guard let leftTop = leftTopOfPins, let rightBottom = rightBottomOfPins else { return }

        let latDelta = (rightBottom.latitude - leftTop.latitude) * 1.01
        let longDelta = (rightBottom.longitude - leftTop.longitude) * 1.01
        let center = CLLocationCoordinate2D(latitude: leftTop.latitude + latDelta / 2,
                                            longitude: leftTop.longitude + longDelta / 2)
        mapView.setRegion(MKCoordinateRegion(center: center,
                                             span: MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)),
                          animated: false)
    }
}

extension LocateMetroViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if locatingMe {
            manager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locatingMe {
            locateMe()
            locatingMe = false
            SVProgressHUD.dismiss()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locatingMe = false
        SVProgressHUD.showError(withStatus: "Unable to determine location")
        SVProgressHUD.dismiss(withDelay: 3.0)
    }
}
