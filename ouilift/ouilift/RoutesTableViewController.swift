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
}

class RoutesTableViewController: UITableViewController {
    
    struct InternalRoute: Codable {
        var PK: String
        var routeDate: String
        var routePrice: String
        var remainingPlace: String
        var hour: String
        var fStation: String
        var fStationDetail: String?
        var fZone: String
        var tStation: String
        var tStationDetail: String?
        var tZone: String
        
        init (PK: String, routeDate: String, routePrice: String, remainingPlace: String, hour: String, fStation: String, fStationDetail: String, fZone: String, tStation: String, tStationDetail: String, tZone: String) {
            self.PK = PK
            self.routeDate = routeDate
            self.routePrice = routePrice
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
    
    var internalRoutes : [InternalRoute] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let internalRouteApi = BaseAPI<InternalRoute>(endpoint: "internal-routes.php")
        internalRouteApi.get(completion: {(result) in self.internalRoutes = result; DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }

    // MARK: - Table view data source

    /*override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }*/

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return internalRoutes.count
    }
    
    /*override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    } */

    /**/
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RouteCell", for: indexPath) as! RoutesTableViewCell
        cell.routeFrom?.text = internalRoutes[indexPath.row].fStation
        cell.routeTo?.text = internalRoutes[indexPath.row].tStation
        cell.routeHour?.text = internalRoutes[indexPath.row].hour
        cell.routePlace?.text = internalRoutes[indexPath.row].remainingPlace
        //cell.textLabel?.text = internalRoutes[indexPath.row].fStation //"Row \(indexPath.row)"
        return cell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
