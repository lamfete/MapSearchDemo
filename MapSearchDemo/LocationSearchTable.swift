//
//  LocationSearchTable.swift
//  MapSearchDemo
//
//  Created by PT. Wavin Tunas Utama on 7/26/16.
//  Copyright © 2016 PT. Wavin Tunas Utama. All rights reserved.
//

import UIKit
import SwiftyJSON
import MapKit

class LocationSearchTable: UITableViewController {
    
    var custData: JSON = []
    
    let data = ["New York, NY", "Los Angeles, CA", "Chicago, IL", "Houston, TX",
                "Philadelphia, PA", "Phoenix, AZ", "San Diego, CA", "San Antonio, TX",
                "Dallas, TX", "Detroit, MI", "San Jose, CA", "Indianapolis, IN",
                "Jacksonville, FL", "San Francisco, CA", "Columbus, OH", "Austin, TX",
                "Memphis, TN", "Baltimore, MD", "Charlotte, ND", "Fort Worth, TX"]
    
    let data2 = ["Logam Jaya, UD", "Terang, TK", "Sinar Family", "Lancar Laksana, TB"]
    
    var filteredData: [String]!
    var namaToko: String = ""
    var alamatToko: String = ""
    var longToko: Double = 0.0
    var latToko: Double = 0.0
    
    var handleMapSearchDelegate: HandleMapSearch? = nil
    
    func getCustData() {
        let path = NSBundle.mainBundle().pathForResource("cust_toko", ofType: "json")
        let jsonData = NSData(contentsOfFile: path!)
        let json = JSON(data: jsonData!)
        
        self.custData = json
        //self.collectionView.reloadData()
        
        //print("JSON: \(json)")
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        cell.textLabel?.text = filteredData[indexPath.row]
        cell.detailTextLabel?.text = ""
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(filteredData[indexPath.row])
        
        for var i=0; i < custData.count; ++i {
            if (filteredData[indexPath.row] == custData[i]["nama_customer"].stringValue) {
                print(custData[i]["alamat_customer"].stringValue)
                print(custData[i]["gps_long"].doubleValue)
                print(custData[i]["gps_lat"].doubleValue)
                
                namaToko = custData[i]["nama_customer"].stringValue
                alamatToko = custData[i]["alamat_customer"].stringValue
                longToko = custData[i]["gps_long"].doubleValue
                latToko = custData[i]["gps_lat"].doubleValue
                
                let toko = Toko(title: namaToko,
                                locationName: alamatToko,
                                coordinate: CLLocationCoordinate2D(latitude: latToko, longitude: longToko))
                
                handleMapSearchDelegate?.dropPinZoomIn(toko)
                dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
}

extension LocationSearchTable: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filteredData = searchText.isEmpty ? data2 : data2.filter({(dataString: String) -> Bool in
                return dataString.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
            })
            
            tableView.reloadData()
        }
    }
}
/*
extension LocationSearchTable: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            let searchPredicate = NSPredicate(format: "nama_customer contains[cd] %@", searchText)
            if let array = custData.arrayObject as? [[String:String]] {
                let filterArr = JSON(array.filter{ searchPredicate.evaluateWithObject($0) })
                filteredData = filterArr.map({ String($0["nama_customer"])})
                tableView.reloadData()
            }
        }
    }
}*/
/*
 
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