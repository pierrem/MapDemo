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
    
    var useAlternatesTiles = false      // Apple vs alternate tile server
    private let template:String = "http://tile.stamen.com/watercolor/{z}/{x}/{y}.png";
    //private let template:String = "http://tile.openstreetmap.org/{z}/{x}/{y}.png";
    private var baseOverlay:MKTileOverlay? = nil
    private var departementOverlay:DepartementOverlay? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (useAlternatesTiles) {
            self.baseOverlay = MKTileOverlay(URLTemplate:template)
            if self.baseOverlay != nil {
                self.baseOverlay!.canReplaceMapContent = true;
                self.mapView.addOverlay(self.baseOverlay!, level:MKOverlayLevel.AboveRoads)
            }
        }
        
        self.departementOverlay = DepartementOverlay()
        if self.departementOverlay != nil {
            self.mapView.addOverlay(self.departementOverlay!, level:MKOverlayLevel.AboveLabels)
        }
    }
    
    // MARK: - MKMapViewDelegate
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if let tileOverlay = overlay as? MKTileOverlay {
            if (tileOverlay == self.baseOverlay) {
                return MKTileOverlayRenderer(overlay:overlay)
            }
        }
        else if let departementOverlay = overlay as? DepartementOverlay {
            if (departementOverlay == self.departementOverlay) {
                return DepartementOverlayRenderer(overlay:overlay)
            }
        }
        return nil
    }
    
}

