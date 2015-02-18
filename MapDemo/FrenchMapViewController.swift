//
//  FrenchMapViewController.swift
//  MapDemo
//
//  Created by Pierre Marty on 16/02/2015.
//  Copyright (c) 2015 Pierre Marty. All rights reserved.
//

import UIKit
import MapKit

class FrenchMapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    private var template:String? = "http://tile.stamen.com/watercolor/{z}/{x}/{y}.png";
    private var overlay:MKTileOverlay? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.overlay = MKTileOverlay(URLTemplate:template)
        if self.overlay != nil {
            self.overlay!.canReplaceMapContent = true;
            self.mapView.addOverlay(self.overlay, level:MKOverlayLevel.AboveLabels)
        }
        
        DepartementsDatabase.sharedInstance
        
    }
    
    // MARK: - MKMapViewDelegate
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if let tileOverlay = overlay as? MKTileOverlay {
            if (tileOverlay == self.overlay) {
                let rendered = MKTileOverlayRenderer(overlay:overlay)
                return rendered
            }
        }
        return nil
    }
    
}

