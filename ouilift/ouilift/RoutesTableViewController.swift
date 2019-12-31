//
//  RoutesTableViewController.swift
//  ouilift
//
//  Created by Mewena on 2019-08-10.
//  Copyright © 2019 AwessoMeTech. All rights reserved.
//

import UIKit

class RoutesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var routeFrom: UILabel!
    
    @IBOutlet weak var routeTo: UILabel!
    
    @IBOutlet weak var routeHour: UILabel!
    
    @IBOutlet weak var routePlace: UILabel!
    @IBOutlet weak var routePrice: UILabel!

}

class RoutesTableViewController: UITableViewController {
    
    struct DateSection: Codable {
        var internalRouteDate: String
        var internalRoutes : [InternalRoute] = []
        
        static func < (lhs: DateSection, rhs: DateSection) -> Bool {
            return lhs.internalRouteDate < rhs.internalRouteDate
        }
        
        static func == (lhs: DateSection, rhs: DateSection) -> Bool {
            return lhs.internalRouteDate == rhs.internalRouteDate
        }
    }
    
    struct InternalRoute: Codable {
        var routeId: String
        var routeDate: String
        var routePrice: String
        var routePlace: String
        var remainingPlace: String
        var hour: String
        var fStation: String
        var fStationDetail: String?
        var fZone: String
        var tStation: String
        var tStationDetail: String?
        var tZone: String
        
        init (routeId: String, routeDate: String, routePrice: String, routePlace: String, remainingPlace: String, hour: String, fStation: String, fStationDetail: String, fZone: String, tStation: String, tStationDetail: String, tZone: String) {
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
            self.tStationDetail = tStationDetail
            self.tZone = tZone
        }
    }
    
    struct InternalRouteFilter: Codable {
        var fromStation: String
        var toStation: String
        var startDate: String
        
        init (_ fromStation: String, _ toStation: String, _ startDate: String) {
            self.fromStation = fromStation
            self.toStation = toStation
            self.startDate = startDate
        }
    }
    
    var internalRoutes : [InternalRoute] = []
    var internaleRoutesByDate: [DateSection] = []

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
        
        let internalRouteApi = BaseAPI<InternalRoute>(endpoint: "internal-routes.php")
        
        let filterParam = InternalRouteFilter(OuiLiftTabBarController.fromStationId ?? "", OuiLiftTabBarController.toStationId ?? "", OuiLiftTabBarController.stationDate ?? "")
        
        
        internalRouteApi.post(TRequest: filterParam, completion: {(result) in
            self.internalRoutes = result;
            
            let groups = Dictionary(grouping: self.internalRoutes) { (internalRoute) in
                return internalRoute.routeDate
            }
            self.internaleRoutesByDate = groups.map(DateSection.init(internalRouteDate:internalRoutes:))//.sorted()
            //self.internaleRoutesByDate.sorted()
            /*self.internaleRoutesByDate = groups.map { (key, values) in
                return DateSection(internalRouteDate: key, internalRoutes: values)
            }*/
            
            // initialisation des parametres de filtres
            OuiLiftTabBarController.fromStationId = ""
            OuiLiftTabBarController.toStationId = ""
            OuiLiftTabBarController.stationDate = ""
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if internaleRoutesByDate.count == 0 {
            // NSLocalizedString("", comment: "")
            tableView.setEmptyView("Pas de trajet disponible", "Veuillez changer vos filtres")
        }
        else {
            tableView.restore()
        }
        //return the number of sections
        return internaleRoutesByDate.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return the number of rows
        let section = self.internaleRoutesByDate[section]
        return section.internalRoutes.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.internaleRoutesByDate[section]
        return section.internalRouteDate
    }

    /**/
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RouteCell", for: indexPath) as! RoutesTableViewCell
        let section = self.internaleRoutesByDate[indexPath.section]
        cell.routeFrom?.text = "De: \(section.internalRoutes[indexPath.row].fStation)"
        cell.routeTo?.text = "À: \(section.internalRoutes[indexPath.row].tStation)"
        cell.routeHour?.text = section.internalRoutes[indexPath.row].hour
        cell.routePlace?.text = "\(section.internalRoutes[indexPath.row].remainingPlace) Place(s)"
        cell.routePrice?.text = "\(section.internalRoutes[indexPath.row].routePrice)"
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueToRouteDetail") {
            let routeDetailVC = segue.destination as! RouteDetailViewController
            
            let selectedSectionIndex = tableView.indexPathForSelectedRow?.section
            let selectedIndex = tableView.indexPathForSelectedRow?.row
            let section = self.internaleRoutesByDate[selectedSectionIndex!]
            routeDetailVC.detailDate = section.internalRoutes[selectedIndex!].routeDate
            routeDetailVC.detailFStation = section.internalRoutes[selectedIndex!].fStation
            routeDetailVC.detailHour = section.internalRoutes[selectedIndex!].hour
            routeDetailVC.detailPrice = section.internalRoutes[selectedIndex!].routePrice
            routeDetailVC.detailRemainingPlace = section.internalRoutes[selectedIndex!].remainingPlace
            routeDetailVC.detailTStation = section.internalRoutes[selectedIndex!].tStation
            routeDetailVC.detailFStationDetails = section.internalRoutes[selectedIndex!].fStationDetail
            routeDetailVC.detailTStationDetails = section.internalRoutes[selectedIndex!].tStationDetail
            routeDetailVC.routeId = section.internalRoutes[selectedIndex!].routeId
        }
    }
    /**/

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

}
