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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let camera = GMSCameraPosition.camera(withLatitude: 45.761218, longitude: 21.209991, zoom: 15)
        mapView.camera = camera
    }

}
