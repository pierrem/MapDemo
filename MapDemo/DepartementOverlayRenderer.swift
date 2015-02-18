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
        // println is not thread safe !
        //        dispatch_async(dispatch_get_main_queue(), {
        //            println("drawMapRect \(zoomScale)")
        //        })
        
        // test: draw borders
        var path = CGPathCreateMutable()
        var rect:CGRect = rectForMapRect(mapRect)
        CGPathAddRect(path, nil, rect)
        CGContextSetLineWidth(context, UIScreen.mainScreen().scale / zoomScale)     // 1 point width, not airline on retina !
        CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
        CGContextSetAlpha(context, 1.0)
        CGContextBeginPath(context)
        CGContextAddPath(context, path)
        CGContextStrokePath(context)
        
        
    }
    
}
