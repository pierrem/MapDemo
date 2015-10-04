//
//  DepartementsDatabase.swift
//  MapDemo
//
//  Created by Pierre Marty on 18/02/2015.
//  Copyright (c) 2015 Pierre Marty. All rights reserved.
//

import Foundation
import MapKit

typealias GeoRing = Array<CLLocationCoordinate2D>       // an elementary polygon on earth
typealias GeoPolygon = Array<GeoRing>                    // the first GeoRing must be the exterior ring and any others must be interior rings or holes

struct GeoGeometry: CustomStringConvertible {
    var polygons:Array<GeoPolygon>      // an array of GeoPolygon, representing a geographical entity
    var mapRect:MKMapRect
    var description: String {   // printable protocol
        return "(\(polygons.count), mapRect:\(mapRect)"
    }
}

struct Departement : CustomStringConvertible {
    var code:String
    var name:String
    var geometry:GeoGeometry
    var description: String {
        return "\(code) \(name) \(geometry)"
    }
}

class DepartementsDatabase {
    
    class var sharedInstance: DepartementsDatabase {
        struct Singleton {
            static let instance = DepartementsDatabase()
        }
        return Singleton.instance
    }
    
    var departements = Array<Departement>()
    
    init () {
        // let dataPath = NSBundle.mainBundle().resourcePath! + "/Data/departements-100.geojson"   // precision reduced to 100 (meters ?)
        let dataPath = NSBundle.mainBundle().resourcePath! + "/Data/departements.geojson"
        let url = NSURL(fileURLWithPath: dataPath)
        let data = NSData(contentsOfURL:url)
        self.loadFromJSON(data)
    }
    
    private func loadFromJSON (data:NSData!) {
        let startTime = CFAbsoluteTimeGetCurrent()
        if (data != nil) {
            var jsonError: NSError?
            var jsonData:AnyObject?
            do {
                jsonData = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            } catch let error as NSError {
                jsonError = error
                jsonData = nil
                print("\(jsonError)")
            }
            let duration = (CFAbsoluteTimeGetCurrent() - startTime)
            print(String(format: "JSONObjectWithData %.4f sec", duration))
            
            if let jsonDictionary = jsonData as? Dictionary<String, AnyObject>,
                jsonDepartements = jsonDictionary["features"] as? [Dictionary<String, AnyObject>] {
                    for jsonDepartement in jsonDepartements {
                        if let properties = jsonDepartement["properties"] as? Dictionary<String, AnyObject>,
                            code = properties["CODE_DEPT"] as? String,
                            name = properties["NOM_DEPT"] as? String,
                            jsonGeometry = jsonDepartement["geometry"] as? Dictionary<String, AnyObject> {
                                let geometry = loadGeometry(jsonGeometry)
                                let departement = Departement(code:code, name:name, geometry:geometry)
                                self.departements.append(departement)
                        }
                    }
            }
        }
        let duration = (CFAbsoluteTimeGetCurrent() - startTime)
        print(String(format: "loadFromJSON %.4f sec", duration))      // aka [NSString stringWithFormat:
    }
    
    private func loadGeometry(jsonGeometry:Dictionary<String, AnyObject>) -> GeoGeometry {
        var geometry = GeoGeometry(polygons:Array(), mapRect:MKMapRectNull)
        if let geometryType = jsonGeometry["type"] as? String, coordinates = jsonGeometry["coordinates"] as? Array<AnyObject> {
            if geometryType == "Polygon" {
                // jsonGeometry represents a GeoPolygon, ie an array of GeoRings
                let geoPolygon = loadGeoPolygon(coordinates)
                geometry.polygons.append(geoPolygon)
            }
                
            else if geometryType == "MultiPolygon" {
                // jsonGeometry represents an array of GeoPolygons
                for jsonObj in coordinates {
                    if let jsonPolygon = jsonObj as? Array<AnyObject> {
                        let geoPolygon = loadGeoPolygon(jsonPolygon)
                        geometry.polygons.append(geoPolygon)
                    }
                }
            }
            else {
                print("invalid geometryType: \(geometryType)")
            }
        }
        updateGeometryExtent(&geometry)
        
        return geometry
    }
    
    private func loadGeoPolygon(coordinates:Array<AnyObject>) -> GeoPolygon {
        var geoPolygon = GeoPolygon()
        for jsonRing in coordinates {
            if let ring = jsonRing as? Array<Array<CLLocationDegrees>> {        // expensive dynamic casting !
                var geoRing = GeoRing()
                for jsonPoint in ring {
                    if jsonPoint.count == 2 {
                        let longitude = jsonPoint[0]
                        let latitude = jsonPoint[1]
                        let point = CLLocationCoordinate2D(latitude:latitude, longitude:longitude)
                        geoRing.append(point)
                    }
                }
                geoPolygon.append(geoRing)
            }
        }
        return geoPolygon
    }
        
    private func updateGeometryExtent(inout geometry:GeoGeometry) {
        var minLatitude = 90.0, maxLatitude = 0.0, minLongitude = 360.0, maxLongitude = 0.0
        
        for geoPolygon in geometry.polygons {
            for geoRing in geoPolygon {
                for coordinate in geoRing { // a CLLocationCoordinate2D
                    if coordinate.latitude < minLatitude {minLatitude = coordinate.latitude}
                    if coordinate.latitude > maxLatitude {maxLatitude = coordinate.latitude}
                    if coordinate.longitude < minLongitude {minLongitude = coordinate.longitude}
                    if coordinate.longitude > maxLongitude {maxLongitude = coordinate.longitude}
                }
            }
        }
        
        // convert to a MKMapRect
        let upperLeft = MKMapPointForCoordinate(CLLocationCoordinate2D(latitude:maxLatitude, longitude:minLongitude))
        let lowerRight = MKMapPointForCoordinate(CLLocationCoordinate2D(latitude:minLatitude, longitude:maxLongitude))
        let mapRect = MKMapRectMake(upperLeft.x, upperLeft.y, lowerRight.x - upperLeft.x, lowerRight.y - upperLeft.y)
        geometry.mapRect = mapRect;
    }
    
    func departementsIntersectingRect(rect:MKMapRect) -> Array<Departement> {
        var result = Array<Departement>()
        for departement in self.departements {
            if MKMapRectIntersectsRect(rect, departement.geometry.mapRect) {
                result.append(departement)
            }
        }
        return result
    }
}





