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

    //private var template:String? = "http://tile.openstreetmap.org/{z}/{x}/{y}.png";
    private var template:String? = "http://tile.stamen.com/watercolor/{z}/{x}/{y}.png";


    override func viewDidLoad() {
        super.viewDidLoad()
        var overlay:MKTileOverlay = MKTileOverlay(URLTemplate:template)
        overlay.canReplaceMapContent = true;
        self.mapView.addOverlay(overlay, level:MKOverlayLevel.AboveLabels)
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!)  -> MKOverlayRenderer! {
        let rendered = MKTileOverlayRenderer(overlay:overlay)
        return rendered
    }
    
}

