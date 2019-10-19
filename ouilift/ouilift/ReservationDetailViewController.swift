//
//  ReservationDetailViewController.swift
//  ouilift
//
//  Created by Mewena on 2019-10-19.
//  Copyright © 2019 AwessoMeTech. All rights reserved.
//

import UIKit

class ReservationDetailViewController: UIViewController {
    
    var routeId: String?
    var detailDate: String?
    var detailPrice: String?
    var detailRemainingPlace: String?
    var detailHour: String?
    var detailFStation: String?
    var detailFStationDetails: String?
    var detailTStation: String?
    var detailTStationDetails: String?
    var defaulValue: String = ""
    
    
    @IBOutlet weak var reservationDetailDateHeure: UILabel!
    @IBOutlet weak var reservationDetailFrom: UILabel!
    @IBOutlet weak var reservationDetailFromDetails: UILabel!
    @IBOutlet weak var reservationDetailTo: UILabel!
    @IBOutlet weak var reservationDetailToDetails: UILabel!
    @IBOutlet weak var reservationDetailPrice: UILabel!
    @IBOutlet weak var reservationPlace: UILabel!
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
    // Specify the orientation.
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        reservationDetailDateHeure.text = "Départ le \(detailDate ?? defaulValue) à \(detailHour ?? defaulValue)"
        reservationDetailFrom.text = "De: \(detailFStation ?? defaulValue)"
        reservationDetailFromDetails.text = detailFStationDetails ?? defaulValue
        reservationDetailTo.text = "À: \(detailTStation ?? defaulValue)"
        reservationDetailToDetails.text = detailTStationDetails ?? defaulValue
        reservationDetailPrice.text =  detailPrice ?? defaulValue
        reservationPlace.text = "\(detailRemainingPlace ?? defaulValue) Place(s)"
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
