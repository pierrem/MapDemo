//
//  CommunesDatabase.swift
//  MapDemo
//
//  Created by Pierre Marty on 16/02/2015.
//  Copyright (c) 2015 Pierre Marty. All rights reserved.
//

import Foundation

class CommunesDatabase {
    
    class var sharedInstance: CommunesDatabase {
        struct Singleton {
            static let instance = CommunesDatabase()
        }
        return Singleton.instance
    }
    
    init () {
        let dataPath = NSBundle.mainBundle().resourcePath! + "communes.geojson"
        let url = NSURL(fileURLWithPath: dataPath)
        // let data = NSData(contentsOfFile:dataPath)
        //NSURL *myURL = [NSURL fileURLWithPath:path];
        let data = NSData(contentsOfURL:url!)
        self.parseJSON(data)
    }
    
    func parseJSON (data:NSData!) {
        if (data != nil) {
            var jsonError: NSError?
            var jsonResult:AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError)
            var categories:Array<Dictionary<String, AnyObject>> = []
            
            if let resultDictionary = jsonResult as? Dictionary<String, AnyObject>, allCommunes = resultDictionary["features"] as? [Dictionary<String, AnyObject>]{
                for oneCommune in allCommunes {
                    if let properties = oneCommune["properties"] as? Dictionary<String, AnyObject>,
                        code = properties["CODE_COM"] as? String,
                        insee = properties["INSEE_COM"] as? String,
                        name = properties["NOM_COM"] as? String,
                        superficy = properties["SUPERFICIE"] as? Int,
                        population = properties["POPULATION"] as? Int {
                            print("name: \(name)")
                            
                    }
                    
                }
            }
        }
    }
    
}

