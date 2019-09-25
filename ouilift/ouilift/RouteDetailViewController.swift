//
//  RouteDetailViewController.swift
//  ouilift
//
//  Created by Mewena on 2019-09-14.
//  Copyright © 2019 AwessoMeTech. All rights reserved.
//

import UIKit

class RouteDetailViewController: UIViewController {
    
    var detailDate: String?
    var detailPrice: String?
    var detailRemainingPlace: String?
    var detailHour: String?
    var detailFStation: String?
    var detailFStationDetails: String?
    var detailTStation: String?
    var detailTStationDetails: String?
    var defaulValue: String = ""
   
    @IBOutlet weak var routeDetailDateHeure: UILabel!
    
    @IBOutlet weak var routeDetailFrom: UILabel!
    
    @IBOutlet weak var routeDetailTo: UILabel!
    
    @IBOutlet weak var routeDetailPrice: UILabel!
    
    @IBOutlet weak var routeDetailPlace: UILabel!
    
    @IBOutlet weak var routeDetailFromDetails: UILabel!
    
    @IBOutlet weak var routeDetailToDetails: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        routeDetailDateHeure.text = "Départ le \(detailDate ?? defaulValue) à \(detailHour ?? defaulValue)"
        routeDetailFrom.text = "De: \(detailFStation ?? defaulValue)"
        routeDetailFromDetails.text = detailFStationDetails ?? defaulValue
        routeDetailTo.text = "À: \(detailTStation ?? defaulValue)"
        routeDetailToDetails.text = detailTStationDetails ?? defaulValue
        routeDetailPrice.text =  detailPrice ?? defaulValue
        routeDetailPlace.text = "\(detailRemainingPlace ?? defaulValue) Place(s)"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
