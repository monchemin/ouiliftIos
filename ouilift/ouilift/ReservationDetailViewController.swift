//
//  ReservationDetailViewController.swift
//  ouilift
//
//  Created by Mewena on 2019-10-19.
//  Copyright © 2019 AwessoMeTech. All rights reserved.
//

import UIKit

class ReservationDetailViewController: UIViewController {
    
    var reservationId: String?
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
    
    struct CanceledReservation: Codable {
        var customerId: String
        var reservationId: String
        
        init (_ customerId: String, _ reservationId: String) {
            self.customerId = customerId
            self.reservationId = reservationId
        }
    }
    
    
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
    
    @IBAction func cancelReservation(_ sender: Any) {
        let customerId = OuiLiftTabBarController.connectedCustomer?.Id
        let reservationApi = BaseAPI<CanceledReservation>(endpoint: "reservations.php")
        let reservation = CanceledReservation(customerId!, self.reservationId!)
        reservationApi.delete(TRequest: reservation, completion: { (status) in
            if (status == 200) {
                
                DispatchQueue.main.async {
                    self.showAlert(message: "Confirmation de votre enregistrement")
                    //toDo : revenir a ecran de recherche de route
                    // self.performSegue(withIdentifier: "segueToCreateAccount", sender: nil)
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(message: "Une erreur est survenue. Veuillez réessayer")
                }
            }
        })
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Oui Lift", message:
            message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alertController, animated: false, completion: nil)
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
