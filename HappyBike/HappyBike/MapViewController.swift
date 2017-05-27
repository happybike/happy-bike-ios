//
//  MapViewController.swift
//  HappyBike
//
//  Created by Norbert Nagy on 27/05/2017.
//  Copyright © 2017 Norbert Nagy. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    
    var velotmpois = [VeloTMPOI]()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let camera = GMSCameraPosition.camera(withLatitude: 45.761218, longitude: 21.209991, zoom: 15)
        mapView.camera = camera
        
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.addObserver(self, forKeyPath: "myLocation", options: .new, context: nil)
        DispatchQueue.main.async {
            self.mapView.isMyLocationEnabled = true
        }
        
        startLcoationManager()
        
        let veloTMAPI = VeloTMAPI()
        veloTMAPI.veloTMPoints { [weak self] (pois: [VeloTMPOI]) in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.velotmpois = pois
            strongSelf.showPois(strongSelf.velotmpois)
        }
    }
    
    private func startLcoationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
//        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func showPois(_ pois: [VeloTMPOI]) {
        for poi in pois {
            guard let coordinate = poi.coordinate, CLLocationCoordinate2DIsValid(coordinate) else {
                return
            }
            
            let marker = GMSMarker(position: coordinate)
            marker.userData = poi
            marker.isTappable = true
            marker.title = poi.stationName
            if let occupied = poi.occupiedSpots, let max = poi.maxBikes {
                marker.snippet = "\(occupied)" + "/" + "\(max)"
            }
            marker.map = mapView
        }
    }
    
    private func drawRoute(_ coords: [CLLocationCoordinate2D]) {
        
    }

    // MARK: GMSMapViewDelegate
    
//    func mapViewDidFinishTileRendering(_ mapView: GMSMapView) {
//        let location = mapView.myLocation
//        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude:(location?.coordinate.longitude)!, zoom:14)
//        mapView.animate(to: camera)
//    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        //let poi = marker.userData
        
    }
    
    // MARK: CLLocationManagerDelegate
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else {return}
//        let timestamp = location.timestamp.timeIntervalSinceNow
////        if abs(timestamp) < 15.0 {
////            mapView.myLocation = location
////        }
//    }
    
    // MARK: Observer
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let location = change?[NSKeyValueChangeKey.newKey] as? CLLocationCoordinate2D else {
            return
        }
        mapView.camera = GMSCameraPosition.camera(withTarget: location, zoom: 15)
    }
    
    deinit {
        mapView.removeObserver(self, forKeyPath: "myLocation", context: nil)
    }
}
