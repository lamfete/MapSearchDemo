//
//  LocationSearchTable.swift
//  MapSearchDemo
//
//  Created by PT. Wavin Tunas Utama on 7/26/16.
//  Copyright © 2016 PT. Wavin Tunas Utama. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import MapKit

class LocationSearchTable: UITableViewController {
    
    var custData: JSON = []
    var dbTokos : [Toko] = []
    
    let data = ["New York, NY", "Los Angeles, CA", "Chicago, IL", "Houston, TX",
                "Philadelphia, PA", "Phoenix, AZ", "San Diego, CA", "San Antonio, TX",
                "Dallas, TX", "Detroit, MI", "San Jose, CA", "Indianapolis, IN",
                "Jacksonville, FL", "San Francisco, CA", "Columbus, OH", "Austin, TX",
                "Memphis, TN", "Baltimore, MD", "Charlotte, ND", "Fort Worth, TX"]
    
    let data2 = ["Logam Jaya, UD", "Terang, TK", "Sinar Family", "Lancar Laksana, TB"]
    
    var filteredDataToko: [Toko]!
    
    var handleMapSearchDelegate: HandleMapSearch? = nil
    var vc = ViewController()
    
    func getCustData() {
        let path = NSBundle.mainBundle().pathForResource("cust_toko", ofType: "json")
        let jsonData = NSData(contentsOfFile: path!)
        let json = JSON(data: jsonData!)
        
        self.custData = json
        //self.collectionView.reloadData()
        
        //print("JSON: \(json)")
        splitData()
    }
    
    func splitData() {
        for(_, subJson):(String, JSON) in self.custData {
            if let name: String = subJson["nama_customer"].stringValue {
                if let address: String = subJson["alamat_customer"].stringValue {
                    if let city: String = subJson["kota"].stringValue {
                        if let province: String = subJson["provinsi"].stringValue {
                            if let lat: Double = subJson["gps_lat"].doubleValue {
                                if let long: Double = subJson["gps_long"].doubleValue {
                                    /*namaTokoArr.append(name)
                                     alamatTokoArr.append(address)
                                     kotaTokoArr.append(city)
                                     provinsiTokoArr.append(province)*/
                                    let toko = Toko(title: name,
                                                    locationName: address,
                                                    cityName: city,
                                                    provinsiName: province,
                                                    coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
                                    dbTokos.append(toko)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDataToko.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        cell.textLabel!.text = String(filteredDataToko[indexPath.row].title!)
        cell.detailTextLabel!.text = String(filteredDataToko[indexPath.row].locationName) + ", " + String(filteredDataToko[indexPath.row].cityName) + ", " + String(filteredDataToko[indexPath.row].provinsiName)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //print(filteredDataToko[indexPath.row])
        
        let toko = Toko(title: filteredDataToko[indexPath.row].title!,
                        locationName: filteredDataToko[indexPath.row].locationName,
                        cityName: filteredDataToko[indexPath.row].cityName,
                        provinsiName: filteredDataToko[indexPath.row].provinsiName,
                        coordinate: filteredDataToko[indexPath.row].coordinate)
        
        handleMapSearchDelegate?.dropPinZoomIn(toko)
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension LocationSearchTable: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            /*filteredData = searchText.isEmpty ? namaTokoArr : namaTokoArr.filter(
                {
                    (dataString: String) -> Bool in
                    return dataString.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
                }
            )*/
            filteredDataToko = searchText.isEmpty ? dbTokos : dbTokos.filter(
                {
                    (dataString: Toko) -> Bool in
                    return dataString.title?.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
                }
            )
            
            tableView.reloadData()
            //print("namaTokoArr: \(namaTokoArr)")
            //print(dbTokos)
            //print(filteredDataToko)
        }
    }
}
/*
extension LocationSearchTable: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            let searchPredicate = NSPredicate(format: "nama_customer contains[cd] %@", searchText)
            if let array = custData.arrayObject as? [[String:AnyObject]!] {
                let filterArr = array.filter{ searchPredicate.evaluateWithObject($0) }
                filteredData = filterArr.map({ String($0["nama_customer"]) })
                filteredData2 = filterArr.map({ String($0["alamat_customer"]) })
                filteredData3 = filterArr.map({ String($0["kota"]) })
                filteredData4 = filterArr.map({ String($0["provinsi"]) })
                tableView.reloadData()
                print(filterArr)
            }
        }
    }
}*/