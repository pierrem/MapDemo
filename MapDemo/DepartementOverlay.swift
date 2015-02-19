//
//  DepartementOverlay.swift
//  MapDemo
//
//  Created by Pierre Marty on 18/02/2015.
//  Copyright (c) 2015 Pierre Marty. All rights reserved.
//

import UIKit
import MapKit

class DepartementOverlay : NSObject, MKOverlay {
    
    // MARK:MKOverlay protocol
    
    // MKAnnotation protocol (MKOverlay is an MKAnnotation): for areas this should return the centroid of the area.
    // any meaning in our case ?
    let coordinate = CLLocationCoordinate2D(latitude:0, longitude:0)

    var boundingMapRect:MKMapRect {
        // France: NE 51.089062, 9.559320, SW 41.333740, -5.140600
        let topLeft = CLLocationCoordinate2D(latitude:51.089062, longitude:-5.140600)
        let bottomRight = CLLocationCoordinate2D(latitude:41.333740, longitude:9.559320)
        let MKupperLeft  = MKMapPointForCoordinate(topLeft)     // project on map
        let MKlowerRight = MKMapPointForCoordinate(bottomRight)
        let width  = MKlowerRight.x - MKupperLeft.x;
        let height = MKlowerRight.y - MKupperLeft.y;
        let bounds = MKMapRectMake (MKupperLeft.x, MKupperLeft.y, width, height);
        
        return bounds;
    }
}


