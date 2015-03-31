# MapDemo
MapKit with open data in Swift

Requires Swift 1.2 (XCode 6.3) !

This project demonstrates some MapKit features with Swift.
It displays french département borders, extracted from a public database converted to GeoJSON.

Data  come from IGN (open licence) at:
http://professionnels.ign.fr/geofla

I used ogr2ogr software to convert them from Shapefile format to JSON.
http://gdal.gloobe.org/ogr/ogr2ogr.html

ogr2ogr -f GeoJSON -t_srs crs:84 -simplify 100 departements-100.geojson DEPARTEMENT.shp

The -simplify 100 option allows to reduce the precision to 100 meters and to reduce the data size from 8 to 2 MBytes.
The aim is mainly to reduce load time.

You can change tiles used to render the map:
in FrenchMapViewController.swift:

    var useAlternatesTiles = true      // Apple vs alternate tile server
    private let template:String = "http://tile.stamen.com/watercolor/{z}/{x}/{y}.png";

There is an article in french at :

[http://www.alpeslog.com/cartographie-avec-donnees-publiques/](http://www.alpeslog.com/cartographie-avec-donnees-publiques/)
