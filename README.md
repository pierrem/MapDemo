# MapDemo
MapKit with open data in Swift

Requires Swift 1.2 (XCode 6.3) !

This project demonstrates some MapKit features with Swift.
It displays french département borders, extracted from a public database converted to GeoJSON.

You can change tiles used to render the map:
in FrenchMapViewController.swift:

    var useAlternatesTiles = true      // Apple vs alternate tile server
    private let template:String = "http://tile.stamen.com/watercolor/{z}/{x}/{y}.png";



There is an article in french at :

[http://www.alpeslog.com/cartographie-avec-donnees-publiques/](http://www.alpeslog.com/cartographie-avec-donnees-publiques/)
