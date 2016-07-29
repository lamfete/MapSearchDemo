//
//  LocationSearchTable.swift
//  MapSearchDemo
//
//  Created by PT. Wavin Tunas Utama on 7/26/16.
//  Copyright © 2016 PT. Wavin Tunas Utama. All rights reserved.
//

import UIKit
import SwiftyJSON

class LocationSearchTable: UITableViewController {
    
    var custData: JSON = []
    
    let data = ["New York, NY", "Los Angeles, CA", "Chicago, IL", "Houston, TX",
                "Philadelphia, PA", "Phoenix, AZ", "San Diego, CA", "San Antonio, TX",
                "Dallas, TX", "Detroit, MI", "San Jose, CA", "Indianapolis, IN",
                "Jacksonville, FL", "San Francisco, CA", "Columbus, OH", "Austin, TX",
                "Memphis, TN", "Baltimore, MD", "Charlotte, ND", "Fort Worth, TX"]
    
    var filteredData: [String]!
    
    func getCustData() {
        let path = NSBundle.mainBundle().pathForResource("cust_toko", ofType: "json")
        let jsonData = NSData(contentsOfFile: path!)
        let json = JSON(data: jsonData!)
        
        self.custData = json
        //self.collectionView.reloadData()
        
        print("JSON: \(json)")
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        cell.textLabel?.text = filteredData[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(filteredData[indexPath.row])
    }
}

extension LocationSearchTable: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filteredData = searchText.isEmpty ? data : data.filter({(dataString: String) -> Bool in
                return dataString.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
            })
            
            tableView.reloadData()
        }
    }
}
/*
extension LocationSearchTable {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        cell.textLabel?.text = filteredData[indexPath.row]
        return cell
    }
}*/