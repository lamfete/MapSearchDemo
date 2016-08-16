//
//  ViewController.swift
//  MapSearchDemo
//
//  Created by PT. Wavin Tunas Utama on 7/26/16.
//  Copyright © 2016 PT. Wavin Tunas Utama. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import SwiftyJSON

protocol HandleMapSearch {
    func dropPinZoomIn(toko: Toko)
}

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    var searchController: UISearchController!
    var selectedPin: Toko? = nil
    
    let locationManager = CLLocationManager()
    let searchRadius: Double = 4 //in kilometer
    var tokos: [Toko] = []
    
    var userLocation: CLLocationCoordinate2D? = nil
    var destLat: Double = 0.0
    var destLong: Double = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        let locationSearchTable = storyboard!.instantiateViewControllerWithIdentifier("LocationSearchTable") as! LocationSearchTable
        
        locationSearchTable.getCustData()
        locationSearchTable.tableView.dataSource = locationSearchTable.self
        //locationSearchTable.filteredData = locationSearchTable.data
        
        searchController = UISearchController(searchResultsController: locationSearchTable)
        searchController?.searchResultsUpdater = locationSearchTable.self
        
        //searchController.dimsBackgroundDuringPresentation = false
        
        searchController.searchBar.sizeToFit()
        
        let searchBar = searchController!.searchBar
        //searchBar.sizeToFit()
        searchBar.placeholder = "Find Store"
        navigationItem.titleView = searchController?.searchBar
        
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.dimsBackgroundDuringPresentation = false
        
        definesPresentationContext = true
        
        locationSearchTable.handleMapSearchDelegate = self
        
        //navigation
        //navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        
        //button
        let backButton: UIButton = UIButton(type: .Custom)
        backButton.setImage(UIImage(named: "ico_back_white"), forState: UIControlState.Normal)
        backButton.addTarget(self, action: #selector(ViewController.backButtonPressed), forControlEvents: UIControlEvents.TouchUpInside)
        backButton.frame = CGRectMake(0, 0, 20, 20)
        
        let barButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    func backButtonPressed() {
        print("back button pressed")
    }
    
    func degreesToRadians(degrees: Double) -> Double {
        return degrees * M_PI / 180.0
    }
    
    func radiansToDegrees(radians: Double) -> Double {
        return radians * 180.0 / M_PI
    }
    
    func computeDistance(userLat: Double, userLong: Double, storeLat: Double, storeLong: Double) -> Double {
        //user coordinate
        let earth_radius: Double = 6371.0
        
        let degreesLat = degreesToRadians(storeLat - userLat)
        let degreesLong = degreesToRadians(storeLong - userLong)
        
        let a = sin(degreesLat/2) * sin(degreesLat/2) + cos(degreesToRadians(userLat)) * cos(degreesToRadians(storeLat)) * sin(degreesLong/2) * sin(degreesLong/2)
        let c = 2 * asin(sqrt(a))
        let d = earth_radius * c
        
        return d
    }
    
    func getDirections() {
        let sourceLocation = CLLocationCoordinate2D(latitude: userLocation!.latitude, longitude: userLocation!.longitude)
        let destinationLocation = CLLocationCoordinate2D(latitude: destLat, longitude: destLong)
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let sourceAnnotation = MKPointAnnotation()
        if let srcLocation = sourcePlacemark.location {
            sourceAnnotation.coordinate = srcLocation.coordinate
        }
        
        let destinationAnnotation = MKPointAnnotation()
        if let destLocation = destinationPlacemark.location {
            destinationAnnotation.coordinate = destLocation.coordinate
        }
        
        self.mapView.showAnnotations([sourceAnnotation, destinationAnnotation], animated: true)
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .Automobile
        
        let directions = MKDirections(request: directionRequest)
        
        directions.calculateDirectionsWithCompletionHandler {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
            
            let route = response.routes[0]
            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.AboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        /*if let overlay = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(circle: overlay)
            circleRenderer.fillColor = UIColor.blueColor().colorWithAlphaComponent(0.1)
            return circleRenderer
        }
        else {
            return MKOverlayRenderer(overlay: overlay)
        }*/
        self.mapView.removeOverlay(overlay)
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blueColor()
        renderer.lineWidth = 4.0
        
        return renderer
    }
    
    func removeDirectionPath() {
        var overlaysToRemove = [MKOverlay]()
        let overlays = self.mapView.overlays
        
        for overlay in overlays {
            overlaysToRemove.append(overlay)
        }
        self.mapView.removeOverlays(overlaysToRemove)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? Toko {
            let identifier = "pin"
            //get direction var
            let smallSquare = CGSize(width: 30, height: 30)
            let button = UIButton(frame: CGRect(origin: CGPointZero, size: smallSquare))
            //end of getDirection var
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            }
            else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
                
                //get direction
                button.setBackgroundImage(UIImage(named: "ico_car"), forState: .Normal)
                button.addTarget(self, action: #selector(ViewController.getDirections), forControlEvents: .TouchUpInside)
                view.leftCalloutAccessoryView = button
                
                destLat = annotation.coordinate.latitude
                destLong = annotation.coordinate.longitude
                //end of get direction
            }
            return view
        }
        return nil
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            let circle = MKCircle(centerCoordinate: location.coordinate, radius: searchRadius)
            mapView.setRegion(region, animated: true)
            //mapView.addOverlay(circle)
            
            let lst = LocationSearchTable()
            lst.getCustData()
            
            //let userLocation: CLLocationCoordinate2D = manager.location!.coordinate
            userLocation = manager.location!.coordinate
            
            for(_, subJson) in lst.custData {
                if let name: String = subJson["nama_customer"].stringValue {
                    if let address: String = subJson["alamat_customer"].stringValue {
                        if let city: String = subJson["kota"].stringValue {
                            if let province: String = subJson["provinsi"].stringValue {
                                if let lat: Double = subJson["gps_lat"].doubleValue {
                                    if let long: Double = subJson["gps_long"].doubleValue {
                                        if(computeDistance(userLocation!.latitude, userLong: userLocation!.longitude, storeLat: lat, storeLong: long) < searchRadius) {
                                            let toko = Toko(
                                                title: name,
                                                locationName: address,
                                                cityName:  city,
                                                provinsiName:  province,
                                                coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long)
                                            )
                                            tokos.append(toko)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            mapView.addAnnotations(tokos)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error:: \(error)")
    }
}

extension ViewController: HandleMapSearch {
    func dropPinZoomIn(toko: Toko) {
    //func dropPinZoomIn(longtitute: String, lattitude: String) {
        //cache the pin
        selectedPin = toko
        
        //clear existing pins
        //mapView.removeAnnotations(mapView.annotations)
        
        /*
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "(city) (state)"
        }*/
        
        //let toko = Toko(title: locationSearchTable.namaToko, locationName: locationSearchTable.alamatToko,coordinate: CLLocationCoordinate2D(latitude: locationSearchTable.latToko, longitude: locationSearchTable.longToko))
        //print("NAMA TOKO: \(locationSearchTable.namaToko)")
        mapView.addAnnotation(toko)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(toko.coordinate, span)
    
        mapView.setRegion(region, animated: true)
    }
}