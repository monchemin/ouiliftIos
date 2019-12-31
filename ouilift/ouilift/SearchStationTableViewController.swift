//
//  SearchStationTableViewController.swift
//  ouilift
//
//  Created by Mewena on 2019-10-25.
//  Copyright © 2019 AwessoMeTech. All rights reserved.
//

import UIKit

class StationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var stationName: UILabel?
    
    @IBOutlet weak var stationAddress: UILabel?
    
}

class SearchStationTableViewController: UITableViewController, UISearchResultsUpdating {
    
    struct RouteStation: Codable {
        var stationId: String
        var stationName: String
        var stationAddress: String
        
        init (stationId: String, stationName: String, stationAddress: String) {
            self.stationId = stationId
            self.stationName = stationName
            self.stationAddress = stationAddress
        }
    }
    
    var routeStations : [RouteStation] = []
    
    var filteredData: [RouteStation]!
    
    var searchController: UISearchController!
    
    var isFromClicked: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        let internalRouteApi = BaseAPI<RouteStation>(endpoint: "route-station.php")
        internalRouteApi.get(completion: {(result) in
            self.routeStations = result;
            self.filteredData = result;
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        
        searchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  (((searchController) != nil) && searchController.isActive) {
            return filteredData.count
        } else {
            return routeStations.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StationTableCell", for: indexPath) as! StationTableViewCell

        if (searchController.isActive) {
            cell.stationName?.text = filteredData[indexPath.row].stationName
            cell.stationAddress?.text = filteredData[indexPath.row].stationAddress
        } else {
            cell.stationName?.text = routeStations[indexPath.row].stationName
            cell.stationAddress?.text = routeStations[indexPath.row].stationAddress
        }

        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredData?.removeAll(keepingCapacity: false)
        if (searchController.searchBar.text != nil && searchController.searchBar.text != "") {
            filteredData = routeStations.filter { (routeStation: RouteStation) -> Bool in
                return routeStation.stationName.lowercased().contains(searchController.searchBar.text!.lowercased())
            }
        } else {
            filteredData = routeStations
        }
        
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueToSearchRouteController") {
            let searchRoutesVC = segue.destination as! SearchRoutesViewController
            
            let selectedIndex = tableView.indexPathForSelectedRow?.row
            if (isFromClicked!) {
                OuiLiftTabBarController.fromStationId = filteredData[selectedIndex!].stationId
                OuiLiftTabBarController.formStationName = filteredData[selectedIndex!].stationName
            } else {
                OuiLiftTabBarController.toStationId = filteredData[selectedIndex!].stationId
                OuiLiftTabBarController.toStationName = filteredData[selectedIndex!].stationName
            }
            
        }
    }
}
