//
//  ViewController.swift
//  MapSearchDemo
//
//  Created by PT. Wavin Tunas Utama on 7/26/16.
//  Copyright © 2016 PT. Wavin Tunas Utama. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(toko: Toko)
}

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    var searchController: UISearchController!
    var selectedPin: MKPlacemark? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locationSearchTable = storyboard!.instantiateViewControllerWithIdentifier("LocationSearchTable") as! LocationSearchTable
        
        locationSearchTable.getCustData()
        locationSearchTable.tableView.dataSource = locationSearchTable.self
        locationSearchTable.filteredData = locationSearchTable.data
        
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
        backButton.addTarget(self, action: "backButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.frame = CGRectMake(0, 0, 20, 20)
        
        let barButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    func backButtonPressed() {
        print("back button pressed")
    }

    /*
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filteredData = searchText.isEmpty ? data : data.filter({(dataString: String) -> Bool in
                return dataString.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
            })
            
            tableView.reloadData()
        }
    }*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: HandleMapSearch {
    func dropPinZoomIn(toko: Toko) {
    //func dropPinZoomIn(longtitute: String, lattitude: String) {
        //cahce the pin
        //selectedPin = placemark
        
        //clear existing pins
        mapView.removeAnnotations(mapView.annotations)
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