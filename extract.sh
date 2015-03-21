#!/usr/bin/env node

'use strict';

/*
	pm 17 feb 2015
	node.js script
	extraction du fichier json des communes
	
	geoJSON specifications: http://geojson.org/geojson-spec.html
*/

var fs = require('fs');

var jsonObj = require('./communes-in.json')
var sourceCommunes = jsonObj['features']

var communes = [];
for (var myKey in sourceCommunes) {
    var original = sourceCommunes[myKey]
    var properties = original['properties']
    var name = properties['NOM_COM']
    var code = parseInt(properties['INSEE_COM'])
    var population = properties['POPULATION']
    var newCommune = {
        'code': code,
        'name': name,
        'population': population
    }

    var geometry = original['geometry']
    var type = geometry['type']
    var coordinates = geometry['coordinates']
    var newCoordinates = []

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

    newCommune['coordinates'] = newCoordinates
	
	communes.push(newCommune)
}

fs.writeFileSync('./communes.json', JSON.stringify(communes))

function convertRing(ring) {
	// a ring is an array of pairs of coordinates
    var newRing = []
    for (var i in ring) {
    	var coordinates = ring[i]
    	var longitude = parseFloat(coordinates[0])
    	var latitude = parseFloat(coordinates[1])
		var newCoordinates = [Math.round(longitude*1000000)/1000000, Math.round(latitude*1000000)/1000000]
		newRing.push(newCoordinates)
	}
	return newRing
}
