//
//  MapViewController.swift
//  HappyBike
//
//  Created by Norbert Nagy on 27/05/2017.
//  Copyright © 2017 Norbert Nagy. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, GMSMapViewDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    
    var velotmpois = [VeloTMPOI]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let camera = GMSCameraPosition.camera(withLatitude: 45.761218, longitude: 21.209991, zoom: 15)
        mapView.camera = camera
        
        let veloTMAPI = VeloTMAPI()
        veloTMAPI.veloTMPoints { [weak self] (pois: [VeloTMPOI]) in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.velotmpois = pois
            strongSelf.showPois(strongSelf.velotmpois)
        }
    }
    
    private func showPois(_ pois: [VeloTMPOI]) {
        for poi in pois {
            guard let coordinate = poi.coordinate, CLLocationCoordinate2DIsValid(coordinate) else {
                return
            }
            
            let marker = GMSMarker(position: coordinate)
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
    
}
