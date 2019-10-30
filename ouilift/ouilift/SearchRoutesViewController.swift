//
//  SearchRoutesViewController.swift
//  ouilift
//
//  Created by Mewena on 2019-09-09.
//  Copyright © 2019 AwessoMeTech. All rights reserved.
//

import UIKit

class SearchRoutesViewController: UIViewController {
    
    var defaulValue: String = ""
    
    var isFromClicked: Bool?
    
    @IBOutlet weak var formStation: UITextField?
    
    @IBOutlet weak var toStation: UITextField?
    
    @IBOutlet weak var dateRoute: UITextField?
    
    @IBAction func fromStationAction(_ sender: Any) {
        isFromClicked = true
        self.performSegue(withIdentifier: "segueToStationController", sender: nil)
    }
    
    @IBAction func toStationAction(_ sender: Any) {
        isFromClicked = false
        self.performSegue(withIdentifier: "segueToStationController", sender: nil)
    }
    
    
    @IBAction func dateRouteAction(_ sender: Any) {
        self.performSegue(withIdentifier: "segueToDatePickerController", sender: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formStation?.text = OuiLiftTabBarController.formStationName ?? defaulValue
        toStation?.text = OuiLiftTabBarController.toStationName ?? defaulValue
        dateRoute?.text = OuiLiftTabBarController.stationDate ?? defaulValue
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueToStationController") {
            let searchStationsVC = segue.destination as! SearchStationTableViewController
            searchStationsVC.isFromClicked = isFromClicked
        }
        // toDo traiter lautre segue pour aller à routeTableVC
    }

}
