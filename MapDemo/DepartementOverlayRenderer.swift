//
//  DepartementOverlayRenderer.swift
//  MapDemo
//
//  Created by Pierre Marty on 18/02/2015.
//  Copyright (c) 2015 Pierre Marty. All rights reserved.
//

import UIKit
import MapKit


class DepartementOverlayRenderer: MKOverlayRenderer {
    
    override func canDrawMapRect(mapRect:MKMapRect, zoomScale: MKZoomScale) -> Bool {
        return true
    }
    
    override func drawMapRect(mapRect:MKMapRect, zoomScale: MKZoomScale, inContext context: CGContext!) {
        
        let departementsToDraw = DepartementsDatabase.sharedInstance.departementsIntersectingRect(mapRect)
/*
        dispatch_async(dispatch_get_main_queue(), {
            println("--")
            for departement in departementsToDraw {
                println("\(departement.name)")
            }
        })
*/
        for departement in departementsToDraw {
            drawDepartement(departement, zoomScale:zoomScale, inContext:context)
        }
        
    }
    
    func drawDepartement(departement:Departement, zoomScale: MKZoomScale, inContext context: CGContext!) {
        var path = CGPathCreateMutable()
        
        let polygons = departement.geometry.polygons
        for rings in polygons {   // a GeoPolygon
            for ring in rings {     // a GeoRing, ie an array of CLLocationCoordinate2D
                let coordinate = ring[0]
                let mapPoint = MKMapPointForCoordinate(coordinate)
                let relativePoint = self.pointForMapPoint(mapPoint)
                CGPathMoveToPoint(path, nil, relativePoint.x, relativePoint.y)
                var isFirst = false
                for coordinate in ring {
                    let mapPoint = MKMapPointForCoordinate(coordinate)
                    let relativePoint = self.pointForMapPoint(mapPoint)
                    if (isFirst) {
                        isFirst =  false
                        CGPathMoveToPoint(path, nil, relativePoint.x, relativePoint.y)
                    }
                    else {
                        CGPathAddLineToPoint(path, nil, relativePoint.x, relativePoint.y)
                    }
                }
            }
        }
        
        CGContextSetLineWidth(context, UIScreen.mainScreen().scale / zoomScale)     // 1 point width, not airline on retina !
        CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
        CGContextSetAlpha(context, 1.0)
        CGContextBeginPath(context)
        CGContextAddPath(context, path)
        CGContextStrokePath(context)
    }
}
