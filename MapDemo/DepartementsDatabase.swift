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
typealias GeoGeometry = Array<GeoPolygon>                // an array of polygons, representing a geographical entity

struct Departement {
    var code:String
    var name:String
    var geometry:GeoGeometry
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
        let dataPath = NSBundle.mainBundle().resourcePath! + "/Data/departements.geojson"
        let url = NSURL(fileURLWithPath: dataPath)
        let data = NSData(contentsOfURL:url!)
        self.loadFromJSON(data)
    }
    
    private func loadFromJSON (data:NSData!) {
        if (data != nil) {
            var jsonError: NSError?
            var jsonData:AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError)
            
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
    }
    
    private func loadGeometry(jsonGeometry:Dictionary<String, AnyObject>) -> GeoGeometry {
        var geometry = GeoGeometry()
        if let geometryType = jsonGeometry["type"] as? String, coordinates = jsonGeometry["coordinates"] as? Array<AnyObject> {
            if geometryType == "Polygon" {
                // jsonGeometry represents a GeoPolygon, ie an array of GeoRings
                var geoPolygon = loadGeoPolygon(coordinates)
                geometry.append(geoPolygon)
            }
                
            else if geometryType == "MultiPolygon" {
                // jsonGeometry represents an array of GeoPolygons
                for jsonObj in coordinates {
                    if let jsonPolygon = jsonObj as? Array<AnyObject> {
                        var geoPolygon = loadGeoPolygon(jsonPolygon)
                        geometry.append(geoPolygon)
                    }
                }
            }
            else {
                println("invalid geometryType: \(geometryType)")
            }
        }
        return geometry
    }
    
    private func loadGeoPolygon(coordinates:Array<AnyObject>) -> GeoPolygon {
        var geoPolygon = GeoPolygon()
        for jsonRing in coordinates {
            if let ring = jsonRing as? Array<Array<CLLocationDegrees>> {
                var geoRing = GeoRing()
                for jsonPoint in ring {     // TODO: test ring.count
                    let longitude = jsonPoint[0]
                    let latitude = jsonPoint[1]
                    let point = CLLocationCoordinate2D(latitude:latitude, longitude:longitude)
                    geoRing.append(point)
                }
                geoPolygon.append(geoRing)
            }
        }
        return geoPolygon
    }
    
}



