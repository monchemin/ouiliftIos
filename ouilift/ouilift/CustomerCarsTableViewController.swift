//
//  CustomerCarsTableViewController.swift
//  ouilift
//
//  Created by Mewena on 2019-12-30.
//  Copyright © 2019 AwessoMeTech. All rights reserved.
//

import UIKit

class CarTableViewCell: UITableViewCell {

    @IBOutlet weak var brandAndModel: UILabel!
    
    @IBOutlet weak var numberAndColor: UILabel!
}

class CustomerCarsTableViewController: UITableViewController, UISearchResultsUpdating {
    
    struct Car: Codable {
        var Id: String
        var number: String
        var year: String
        var model: String
        var brand: String
        var color: String
        
        init (_ Id: String, _ number: String, _ year: String, _ model: String, _ brand: String, _ color: String) {
            self.Id = Id
            self.number = number
            self.year = year
            self.model = model
            self.brand = brand
            self.color = color
        }
    }
    
    struct CarFilter: Codable {
        var customerId: String
        
        init (_ customerId: String) {
            self.customerId = customerId
        }
    }
    
    var cars : [Car] = []
    
    var filteredData: [Car]!
    
    var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        let carApi = BaseAPI<Car>(endpoint: "car.php")
        
        // let filterParam = CarFilter(OuiLiftTabBarController.connectedCustomer?.Id ?? "")
        
        let filterParam = CarFilter("72")

        carApi.post(TRequest: filterParam,completion: {(result) in
            self.cars = result;
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
        
        // tableView.reloadData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  (((searchController) != nil) && searchController.isActive) {
            return filteredData.count
        } else {
            return cars.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarTableCell", for: indexPath) as! CarTableViewCell
        
        if (searchController.isActive) {
            cell.brandAndModel?.text = "\(filteredData[indexPath.row].brand) - \(filteredData[indexPath.row].model)"
            cell.numberAndColor?.text = "\(filteredData[indexPath.row].number) - \(filteredData[indexPath.row].color)"
        } else {
            cell.brandAndModel?.text = "\(cars[indexPath.row].brand) - \(cars[indexPath.row].model)"
            cell.numberAndColor?.text = "\(cars[indexPath.row].number) - \(cars[indexPath.row].color)"
        }

        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredData?.removeAll(keepingCapacity: false)
        if (searchController.searchBar.text != nil && searchController.searchBar.text != "") {
            filteredData = cars.filter { (car: Car) -> Bool in
                return car.brand.lowercased().contains(searchController.searchBar.text!.lowercased())
            }
        } else {
            filteredData = cars
        }
        
        self.tableView.reloadData()
    }

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
