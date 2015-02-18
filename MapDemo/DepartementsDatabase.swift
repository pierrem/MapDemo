//
//  DepartementsDatabase.swift
//  MapDemo
//
//  Created by Pierre Marty on 18/02/2015.
//  Copyright (c) 2015 Pierre Marty. All rights reserved.
//

import Foundation

class DepartementsDatabase {
    
    class var sharedInstance: DepartementsDatabase {
        struct Singleton {
            static let instance = DepartementsDatabase()
        }
        return Singleton.instance
    }
    
    init () {
        let dataPath = NSBundle.mainBundle().resourcePath! + "/Data/departements.geojson"
        let url = NSURL(fileURLWithPath: dataPath)
        let data = NSData(contentsOfURL:url!)
        self.parseJSON(data)
    }
    
    private func parseJSON (data:NSData!) {
        if (data != nil) {
            var jsonError: NSError?
            var jsonData:AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError)
            
            if let jsonDictionary = jsonData as? Dictionary<String, AnyObject>,
                jsonDepartements = jsonDictionary["features"] as? [Dictionary<String, AnyObject>] {
                    for jsonDepartement in jsonDepartements {
                        // get properties we are interressed in
                        if let properties = jsonDepartement["properties"] as? Dictionary<String, AnyObject>,
                            code = properties["CODE_DEPT"] as? String,
                            name = properties["NOM_DEPT"] as? String {
                                println("\(name)")
                        }
                        // get the geometry
                        if let jsonGeometry = jsonDepartement["geometry"] as? Dictionary<String, AnyObject>,
                            geometryType = jsonGeometry["type"] as? String,
                            coordinates = jsonGeometry["coordinates"] as? [AnyObject] {
                                let geometry = parseGeometry(geometryType, coordinates:coordinates)
                            
                        }
                        
                    }
            }
        }
    }
    
    private func parseGeometry(geometryType:String, coordinates:Array<AnyObject>) -> Array<AnyObject> {
        if (geometryType == "Polygon") {
            // an array of LinearRing coordinate arrays.
            // For Polygons with multiple rings, the first must be the exterior ring and any others must be interior rings or holes.
            
        }
        else if (geometryType == "MultiPolygon") {
            // an array of Polygon coordinate arrays
        }
        else {
            println("invalid geometryType: \(geometryType)")
        }
        
        return coordinates
    }
}

/*


if (type == 'Polygon') {
    // an array of LinearRing coordinate arrays.
    // For Polygons with multiple rings, the first must be the exterior ring and any others must be interior rings or holes.
    var polygons = []
    for (var ringKey in coordinates) {
        var ring = coordinates[ringKey]
        var newRing = convertRing(ring)
        polygons.push(newRing)
    }
    newCoordinates.push(polygons);
}
else if (type == 'MultiPolygon') {
    // an array of Polygon coordinate arrays
    for (var onePoly in coordinates) {
        for (var ringKey in onePoly) {
            var ring = coordinates[ringKey]
            var newRing = convertRing(ring)
            polygons.push(newRing)
        }
    }
    newCoordinates.push(polygons);
} else {
    console.log('Oups ! type:' + type)
}

*/



