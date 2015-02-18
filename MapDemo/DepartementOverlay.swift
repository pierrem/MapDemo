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
    
    // from MKAnnotation protocol, for areas this should return the centroid of the area.
    // in our case, it has no meaning ?
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(0, 0)
    }

    var boundingMapRect:MKMapRect {
        // France
        // NE 51.089062, 9.559320
        // SW 41.333740, -5.140600
        let topLeft = CLLocationCoordinate2DMake(51.089062, -5.140600)
        let bottomRight = CLLocationCoordinate2DMake(41.333740, 9.559320)
        let MKupperLeft  = MKMapPointForCoordinate(topLeft)
        let MKlowerRight = MKMapPointForCoordinate(bottomRight)
        let width  = MKlowerRight.x - MKupperLeft.x;
        let height = MKlowerRight.y - MKupperLeft.y;
        let bounds = MKMapRectMake (MKupperLeft.x, MKupperLeft.y, width, height);
        
        return bounds;
    }
}


