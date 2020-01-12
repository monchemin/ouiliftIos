//
//  DriverRouteListTableViewController.swift
//  ouilift
//
//  Created by Mewena on 2019-12-15.
//  Copyright © 2019 AwessoMeTech. All rights reserved.
//

import UIKit

class PublishedRoutesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var publishedRouteHour: UILabel!
    
    @IBOutlet weak var publishedRouteFrom: UILabel!
    
    @IBOutlet weak var publishedRouteTo: UILabel!
    
    @IBOutlet weak var publishedRoutePrice: UILabel!
    
    @IBOutlet weak var publishedRoutePlace: UILabel!
}

class DriverRouteListTableViewController: UITableViewController {
    
    struct DateSection: Codable {
        var publishedRouteDate: String
        var publishedRoutes : [PublishedRoute] = []
        
        static func < (lhs: DateSection, rhs: DateSection) -> Bool {
            return lhs.publishedRouteDate < rhs.publishedRouteDate
        }
        
        static func == (lhs: DateSection, rhs: DateSection) -> Bool {
            return lhs.publishedRouteDate == rhs.publishedRouteDate
        }
    }
    
    struct PublishedRoute: Codable {
        var routeId: String
        var routeDate: String
        var routePrice: String
        var routePlace: String
        var remainingPlace: String
        var hour: String
        var fStation: String
        var fStationDetail: String
        var fZone: String
        var tStation: String
        var tStationDetail: String
        var tZone: String
        
        init (_ routeId: String, _ routeDate: String, _ routePrice: String, _ routePlace: String, _ remainingPlace: String, _ hour: String, _ fStation: String, _ fStationDetail: String, _ fZone: String, _ tStation: String, _ tStationDetail: String, _ tZone: String) {
            self.routeId = routeId
            self.routeDate = routeDate
            self.routePrice = routePrice
            self.routePlace = routePlace
            self.remainingPlace = remainingPlace
            self.hour = hour
            self.fStation = fStation
            self.fStationDetail = fStationDetail
            self.fZone = fZone
            self.tStation = tStation
            self.tStationDetail = fZone
            self.tZone = tStation
        }
    }
    
    struct PublishedRouteFilter: Codable {
        var customerId: String
        
        init (_ customerId: String) {
            self.customerId = customerId
        }
    }
    
    var publishedRoutes : [PublishedRoute] = []
    var publishedRoutesByDate : [DateSection] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let publishedRouteApi = BaseAPI<PublishedRoute>(endpoint: "published-routes.php")
        
        let filterParam = PublishedRouteFilter(OuiLiftTabBarController.connectedCustomer?.Id ?? "")
        
        publishedRouteApi.post(TRequest: filterParam, completion: {(result) in
            self.publishedRoutes = result;
            
            let groups = Dictionary(grouping: self.publishedRoutes) { (publishedRoute) in
                return publishedRoute.routeDate
            }
            self.publishedRoutesByDate = groups.map(DateSection.init(publishedRouteDate:publishedRoutes:))//.sorted()
            //self.internaleRoutesByDate.sorted()
            /*self.internaleRoutesByDate = groups.map { (key, values) in
                return DateSection(internalRouteDate: key, internalRoutes: values)
            }*/
    
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if publishedRoutesByDate.count == 0 {
            // NSLocalizedString("", comment: "")
            tableView.setEmptyView("Pas de trajet disponible", "Veuillez changer vos filtres")
        }
        else {
            tableView.restore()
        }
        //return the number of sections
        return publishedRoutesByDate.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.publishedRoutesByDate[section]
        return section.publishedRoutes.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.publishedRoutesByDate[section]
        return section.publishedRouteDate
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PublishedRouteCell", for: indexPath) as! PublishedRoutesTableViewCell
        let section = self.publishedRoutesByDate[indexPath.section]
        cell.publishedRouteFrom?.text = "De: \(section.publishedRoutes[indexPath.row].fStation)"
        cell.publishedRouteTo?.text = "À: \(section.publishedRoutes[indexPath.row].tStation)"
        cell.publishedRouteHour?.text = section.publishedRoutes[indexPath.row].hour
        cell.publishedRoutePlace?.text = "\(section.publishedRoutes[indexPath.row].remainingPlace) / \(section.publishedRoutes[indexPath.row].routePlace) Place(s)"
        cell.publishedRoutePrice?.text = "\(section.publishedRoutes[indexPath.row].routePrice)"
        
        return cell
    }

}
