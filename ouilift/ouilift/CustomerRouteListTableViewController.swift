//
//  CustomerRouteListTableViewController.swift
//  ouilift
//
//  Created by Mewena on 2019-10-19.
//  Copyright © 2019 AwessoMeTech. All rights reserved.
//

import UIKit

class CustomerRouteListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var myRouteHour: UILabel!
    @IBOutlet weak var myRouteFrom: UILabel!
    @IBOutlet weak var myRouteTo: UILabel!
    @IBOutlet weak var myRoutePrice: UILabel!
    @IBOutlet weak var myRoutePlace: UILabel!
    
}

class CustomerRouteListTableViewController: UITableViewController {
    
    struct MyReservationsDateSection: Codable {
        var customerReservationDate: String
        var customerReservations : [CustomerReservation] = []
        
        /*static func < (lhs: DateSection, rhs: DateSection) -> Bool {
         return lhs.customerReservationDate < rhs.customerReservationDate
         }
         
         static func == (lhs: DateSection, rhs: DateSection) -> Bool {
         return lhs.customerReservationDate == rhs.customerReservationDate
         }*/
    }
    
    struct CustomerReservation: Codable {
        var reservation: String
        var remainingPlace: String
        var PK: String
        var routeDate: String
        var routePrice: String
        var hour: String
        var fStation: String
        var fStationDetail: String?
        var fZone: String
        var tStation: String
        var tStationDetail: String?
        var tZone: String
        var registrationNumber: String
        var year: String
        var modelName: String
        var brandName: String
        var colorName: String
        var firstName: String
        var lastName: String
        
        init (_ reservation: String, _ remainingPlace: String, _ PK: String, _ routeDate: String, _ routePrice: String, _ hour: String, _ fStation: String, _ fStationDetail: String, _ fZone: String, _ tStation: String, _ tStationDetail: String, _ tZone: String, _ registrationNumber: String, _ year: String, _ modelName: String, _ brandName: String, _ colorName: String, _ firstName: String, _ lastName: String) {
            self.reservation = reservation
            self.remainingPlace = remainingPlace
            self.PK = PK
            self.routeDate = routeDate
            self.routePrice = routePrice
            self.hour = hour
            self.fStation = fStation
            self.fStationDetail = fStationDetail
            self.fZone = fZone
            self.tStation = tStation
            self.tStationDetail = tStationDetail
            self.tZone = tZone
            self.registrationNumber = registrationNumber
            self.year = year
            self.modelName = modelName
            self.brandName = brandName
            self.colorName = colorName
            self.firstName = firstName
            self.lastName = lastName
        }
    }
    
    var customerReservations : [CustomerReservation] = []
    var customerReservationsByDate: [MyReservationsDateSection] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let customerRouteListApi = BaseAPI<CustomerReservation>(endpoint: "reservation-list.php/57")
        customerRouteListApi.get(completion: {(result) in
            self.customerReservations = result;
            
            let groups = Dictionary(grouping: self.customerReservations) { (customerReservation) in
             return customerReservation.routeDate
             }
             self.customerReservationsByDate = groups.map(MyReservationsDateSection.init(customerReservationDate:customerReservations:))
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if customerReservationsByDate.count == 0 {
            // NSLocalizedString("", comment: "")
            tableView.setEmptyView("Vous n'avez aucune réservation", "")
        }
        else {
            tableView.restore()
        }
        
        return customerReservationsByDate.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let section = self.customerReservationsByDate[section]
        return section.customerReservations.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
     let section = self.customerReservationsByDate[section]
     return section.customerReservationDate
     }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RouteCell", for: indexPath) as! CustomerRouteListTableViewCell

        let section = self.customerReservationsByDate[indexPath.section]
        cell.myRouteHour?.text = section.customerReservations[indexPath.row].hour
        cell.myRouteFrom?.text = section.customerReservations[indexPath.row].fStation
        cell.myRouteTo?.text = section.customerReservations[indexPath.row].tStation
        cell.myRoutePrice?.text = section.customerReservations[indexPath.row].routePrice
        cell.myRoutePlace?.text = section.customerReservations[indexPath.row].remainingPlace
        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueToMyReservationDetail") {
            let routeDetailVC = segue.destination as! ReservationDetailViewController
            
            let selectedSectionIndex = tableView.indexPathForSelectedRow?.section
            let selectedIndex = tableView.indexPathForSelectedRow?.row
            let section = self.customerReservationsByDate[selectedSectionIndex!]
            routeDetailVC.detailDate = section.customerReservations[selectedIndex!].routeDate
            routeDetailVC.detailFStation = section.customerReservations[selectedIndex!].fStation
            routeDetailVC.detailHour = section.customerReservations[selectedIndex!].hour
            routeDetailVC.detailPrice = section.customerReservations[selectedIndex!].routePrice
            routeDetailVC.detailRemainingPlace = section.customerReservations[selectedIndex!].remainingPlace
            routeDetailVC.detailTStation = section.customerReservations[selectedIndex!].tStation
            routeDetailVC.detailFStationDetails = section.customerReservations[selectedIndex!].fStationDetail
            routeDetailVC.detailTStationDetails = section.customerReservations[selectedIndex!].tStationDetail
            routeDetailVC.routeId = section.customerReservations[selectedIndex!].PK
        }
    }
}
