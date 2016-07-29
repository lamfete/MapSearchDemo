//
//  ViewController.swift
//  MapSearchDemo
//
//  Created by PT. Wavin Tunas Utama on 7/26/16.
//  Copyright © 2016 PT. Wavin Tunas Utama. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var searchController: UISearchController!

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
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = searchController?.searchBar
        
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.dimsBackgroundDuringPresentation = false
        
        definesPresentationContext = true
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

