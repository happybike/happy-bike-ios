//
//  PolylineAnimator.swift
//  HappyBike
//
//  Created by Norbert Nagy on 29/05/2017.
//  Copyright © 2017 Norbert Nagy. All rights reserved.
//

import UIKit
import GoogleMaps

typealias PathAnimationCompletionBlock = (_ finished: Bool) -> Void

class PolylineAnimator {
    var animationIndex: UInt = 0
    var animationPath = GMSMutablePath()
    var animationPolylines = [GMSPolyline]()
    
    var completionBlock: PathAnimationCompletionBlock?
    
    func animatePath(_ path: GMSPath, onMap map: GMSMapView, completion: @escaping PathAnimationCompletionBlock) {
        completionBlock = completion
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(tick(_:)), userInfo: ["path":path, "map":map], repeats: true)
    }
    
    @objc func tick(_ timer: Timer) {
        guard let userInfo = timer.userInfo as? [String: AnyObject] else {
            timer.invalidate()
            if (completionBlock != nil) {
                completionBlock!(true)
            }
            return
        }
        
        let path = userInfo["path"] as! GMSPath
        let ggMap = userInfo["map"] as! GMSMapView
        
        DispatchQueue.main.async {
            if self.animationIndex < path.count() {
                self.animationPath.add(path.coordinate(at: self.animationIndex))
                let polyline = GMSPolyline(path: self.animationPath)
                polyline.strokeColor = UIColor.blue
                polyline.strokeWidth = 4
                polyline.map = ggMap
                self.animationPolylines.append(polyline)
                self.animationIndex = self.animationIndex + 1
            } else {
                timer.invalidate()
                self.animationIndex = 0
                self.animationPath = GMSMutablePath()
                for polyline in self.animationPolylines {
                    polyline.map = nil
                }
                self.animationPolylines.removeAll()
                if (self.completionBlock != nil) {
                    self.completionBlock!(true)
                }
            }
        }
    }
}
