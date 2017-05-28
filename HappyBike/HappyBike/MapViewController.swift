//
//  MapViewController.swift
//  HappyBike
//
//  Created by Norbert Nagy on 27/05/2017.
//  Copyright © 2017 Norbert Nagy. All rights reserved.
//

import UIKit
import GoogleMaps

enum SlideMenuType {
    case VeloTM, SafeSpot, Repair, Shop
}

struct SlideMenuItem {
    var title: String
    var type: SlideMenuType
}

class MapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var leftSlideMenuMask: CollectionMaskView!
    @IBOutlet weak var rightSlideMenuMask: CollectionMaskView!
    
    var locationManager = CLLocationManager()
    
    var slideMenuItems = [SlideMenuItem]()
    var selectedSlideMenuItemIndexPath: IndexPath?
    
    var velotmpois = [VeloTMPOI]()
    var safeSpotpois = [Any]()
    var repairpois = [Any]()
    var shoppois = [Any]()
    
    var veloMarkers = [GMSMarker]()
    var safeSpotMarkers = [GMSMarker]()
    var repairMarkers = [GMSMarker]()
    var shopMarkers = [GMSMarker]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createSlideMenu()
        
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
            strongSelf.showVeloPois(strongSelf.velotmpois)
        }
    }
    
    private func createSlideMenu() {
//        addMaskGradient(leftSlideMenuMask)
//        addMaskGradient(rightSlideMenuMask)
        leftSlideMenuMask.isHidden = true
        rightSlideMenuMask.isHidden = true
        
        slideMenuItems = [SlideMenuItem(title: "VELOTM", type: .VeloTM), SlideMenuItem(title: "SAFE SPOTS", type: .SafeSpot), SlideMenuItem(title: "BIKE REPAIR", type: .Repair), SlideMenuItem(title: "BIKE SHOP", type: .Shop), SlideMenuItem(title: "BIKE SHOP1", type: .Shop), SlideMenuItem(title: "BIKE SHOP2", type: .Shop), SlideMenuItem(title: "BIKE SHOP3", type: .Shop), SlideMenuItem(title: "BIKE SHOP4", type: .Shop)]
        collectionView.register(UINib(nibName: "SlideMenuCell", bundle: nil), forCellWithReuseIdentifier: "SlideMenuCell")
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 100, height: 40)
        }
        collectionView.reloadData()
    }
    
    private func addMaskGradient(_ maskView: UIView) {
        maskView.backgroundColor = UIColor.clear
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor,
                           UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.0).cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = maskView.bounds
        maskView.layer.insertSublayer(gradient, at: 0)
    }
    
    private func startLcoationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
//        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func showVeloPois(_ pois: [VeloTMPOI]) {
        veloMarkers.removeAll()
        for poi in pois {
            guard let coordinate = poi.coordinate, CLLocationCoordinate2DIsValid(coordinate) else {
                return
            }
            
            let marker = GMSMarker(position: coordinate)
            marker.icon = UIImage(named: "pinblue")
            marker.userData = poi
            marker.isTappable = true
            marker.title = poi.stationName
            if let occupied = poi.occupiedSpots, let max = poi.maxBikes {
                marker.snippet = "\(occupied)" + "/" + "\(max)"
            }
            marker.map = mapView
            
            veloMarkers.append(marker)
        }
        
        collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .top)
        let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as! SlideMenuCell
        cell.selectCell(true)
        selectedSlideMenuItemIndexPath = IndexPath(item: 0, section: 0)
    }
    
    private func showRepair(_ services: [Any]) {
        
    }
    
    private func showSafeSpots(_ safeSpots: [Any]) {
        
    }
    
    private func showShops(_ shops: [Any]) {
        
    }
    
    private func showBikeLanes(_ lanes: [Any]) {
        
    }
    
    private func drawRoute(_ coords: [CLLocationCoordinate2D]) {
        
    }
    
    // MARK: - 
    
    func removeMarker(_ type: SlideMenuType) {
//        let arr: [GMSMarker]
//        switch type {
//        case .VeloTM:
//            arr = veloMarkers
//        case .Repair:
//            arr = repairMarkers
//        case .SafeSpot:
//            arr = safeSpotMarkers
//        case .Shop:
//            arr = shopMarkers
//        }
//        
//        for marker in arr {
//            marker.map = nil
//        }
        mapView.clear()
    }
    
    func addMarker(_ type: SlideMenuType) {
        switch type {
        case .VeloTM:
            showVeloPois(velotmpois)
        case .Repair:
            showRepair(repairpois)
        case .SafeSpot:
            showSafeSpots(safeSpotpois)
        case .Shop:
            showShops(shoppois)
        }
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


extension MapViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slideMenuItems.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SlideMenuCell", for: indexPath) as! SlideMenuCell
        cell.label.text = slideMenuItems[indexPath.row].title
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! SlideMenuCell
        let selection = slideMenuItems[indexPath.row]
        
        if selectedSlideMenuItemIndexPath?.row == indexPath.row {
//            cell.selectCell(false)
//            removeMarker(selection.type)
        } else {
            cell.selectCell(true)
            let previousCell = collectionView.cellForItem(at: selectedSlideMenuItemIndexPath!) as! SlideMenuCell
            previousCell.selectCell(false)
            mapView.clear()
            addMarker(selection.type)
        }
        
        selectedSlideMenuItemIndexPath = indexPath
    }
}
