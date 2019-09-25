//
//  SearchRoutesViewController.swift
//  ouilift
//
//  Created by Mewena on 2019-09-09.
//  Copyright © 2019 AwessoMeTech. All rights reserved.
//

import UIKit

class SearchRoutesViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var fromStationPicker: UIPickerView!
    struct RouteSatation: Codable {
        var PK: String
        var stationName: String
        var stationAddress: String
        
        init (PK: String, stationName: String, stationAddress: String) {
            self.PK = PK
            self.stationName = stationName
            self.stationAddress = stationAddress
        }
    }
    
    var pickerData: [String] = [String]()
    
    var routeStations : [RouteSatation] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.fromStationPicker.delegate = self
        self.fromStationPicker.dataSource = self
        let internalRouteApi = BaseAPI<RouteSatation>(endpoint: "route-station.php")
        internalRouteApi.get(completion: {(result) in
            self.routeStations = result;
            DispatchQueue.main.async {
                self.viewDidLoad()
                self.viewWillAppear(true)
            }
        })
        
    }

    // MARK: - Table view data source

    /*override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    } */
    
    //
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return routeStations.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return routeStations[row].stationName
    }

}
